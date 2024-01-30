import 'dart:io';

import 'package:configuration/file_updater/rules/plist_rule.dart';
import 'package:configuration/file_updater/rules/replace_rule.dart';
import 'package:yaml/yaml.dart';

import '../../custom_exceptions.dart';

class UpdateResult {
  UpdateResult(this.isMatched, this.updatedData);
  final bool isMatched;
  final String updatedData;
}

class FileUpdater {
  FileUpdater(List<String> lines) : _data = lines;

  final List<String> _data;

  static Future<List<int>> updateFile(File file, UpdateRule updateRule) async {
    final FileUpdater fileUpdater = await FileUpdater.fromFile(file);
    final matches = fileUpdater.update(updateRule);
    fileUpdater.toFile(file);
    return matches;
  }

  static FileUpdater fromString(String s) {
    return FileUpdater(s.split('\n'));
  }

  static Future<FileUpdater> fromFile(File file) async {
    return FileUpdater(await file.readAsLines());
  }

  Future<void> toFile(File file) async {
    await file.writeAsString(_data.join('\n'));
  }

  List<int> update(UpdateRule rule) {
    final List<int> matches = [];
    for (int x = 0; x < _data.length; x++) {
      final updateResult = rule.update(_data[x]);
      _data[x] = updateResult.updatedData;
      if (updateResult.isMatched) {
        matches.add(x + 1);
      }
    }
    return matches;
  }

  @override
  String toString() {
    return _data.join('\n');
  }
}

class UpdateRuleModel {
  UpdateRuleModel(
    this._regExp,
    this._resultValue,
    this._ruleType,
    this._valueConfigPath,
    this._key,
    this._name,
    this._configYaml,
    this.expectedMatch,
    this.filePath,
  );

  factory UpdateRuleModel.fromMap(
      String name, Map<String, dynamic> map, YamlMap configYaml) {
    return UpdateRuleModel(
      map['reg_exp'],
      map['result_value'],
      map['rule_type'],
      map['value_config_path'],
      map['key'],
      name,
      configYaml,
      map['expected_match'],
      map['file_path'],
    );
  }

  final YamlMap _configYaml;

  final String _regExp;
  final String _resultValue;
  final String _ruleType;
  final String _valueConfigPath;
  final String? _key;
  final String _name;
  final int expectedMatch;
  final String filePath;

  RegExp get regExp => RegExp(_regExp);
  String? get key => _key;
  String get name => _name;

  String get resultValue {
    return _resultValue.replaceFirst('\$value', _value);
  }

  String get _value {
    final getValue = (String valuePath) {
      if (valuePath == '\$dot') return '.';
      final List<String> propertyKeys = valuePath.split('.');
      dynamic _value = _configYaml;
      for (final property in propertyKeys) {
        _value = _value[property];
      }
      return _value.toString();
    };

    final formatValue = (String value) {
      if (_name == 'iOS_dynamic_link') {
        final splitted = value.split('.');
        return splitted[splitted.length - 2];
      }
      return value;
    };

    String _value = '';

    for (final valuePath in _valueConfigPath.split('+')) {
      _value += formatValue(getValue(valuePath));
    }

    return _value;
  }

  UpdateRule? get rule {
    switch (_ruleType) {
      case 'Replace':
        return ReplaceRule(this);
      case 'PList':
        return PlistRule(this);
      default:
        return null;
    }
  }
}

abstract class UpdateRule {
  UpdateRule(this.ruleModel);

  bool isMatched = false;
  final UpdateRuleModel ruleModel;

  UpdateResult update(String line);
  void validate(String result) {
    if (isMatched && !ruleModel.regExp.hasMatch(result)) {
      throw InvalidFormatException(message: ruleModel.regExp.pattern);
    }
  }
}
