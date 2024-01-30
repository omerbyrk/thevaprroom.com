import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:yaml/yaml.dart';

import 'constants.dart';
import 'custom_exceptions.dart';
import 'file_updater/file_updater.dart';
import 'main.dart';
import 'printer.dart';

Future<void> runRegExRules() async {
  final YamlMap _configYaml = configYaml;

  final _updateRulesYaml = (await updateRulesYaml).cast<String, dynamic>();

  for (final key in _updateRulesYaml.keys) {
    final _updateRuleModel = UpdateRuleModel.fromMap(
        key, _updateRulesYaml[key].cast<String, dynamic>(), _configYaml);

    await updateFile(
      _updateRuleModel.filePath,
      _updateRuleModel.rule!,
      expectedMatchCount: _updateRuleModel.expectedMatch,
      operation: _updateRuleModel.name,
    );
  }
}

Future<YamlMap> get updateRulesYaml async {
  if (argResults[updateRulesOption] != null) {
    try {
      return loadYaml(File(argResults[updateRulesOption]).readAsStringSync());
    } catch (e) {
      error(e.toString());
    }
  }

  final _updateRuleText = (await http.get(Uri.parse(UPDATE_RULES_URL))).body;
  info('Update Rules loadded from Network');

  return loadYaml(_updateRuleText);
}

YamlMap get configYaml {
  YamlMap? config;

  if (argResults[fileOption] != null) {
    try {
      config = loadYaml(File(argResults[fileOption]).readAsStringSync());
    } catch (e) {
      error(e.toString());
      config = null;
    }
    if (config != null) return config;
  }

  for (String configFile in DEFAULT_CONFIG_FILES) {
    try {
      config = loadYaml(File(configFile).readAsStringSync());
    } catch (e) {
      error(e.toString());
      config = null;
    }
    if (config != null) return config;
  }

  throw NoConfigFoundException();
}

Future<void> updateFile(String file, UpdateRule rule,
    {String operation = '', int expectedMatchCount = -1}) async {
  try {
    final matches = await FileUpdater.updateFile(File(file), rule);
    final matchCount = matches.length;

    debug(
        '$operation is updated on $file, total changes: $matchCount, lines: [${matches.join(',')}]');
    if (expectedMatchCount != -1 && expectedMatchCount != matchCount) {
      error('$operation is not updated as expected, please repair the $file');
    }
  } on InvalidFormatException catch (e) {
    error(
        'the $operation value in the ${argResults[fileOption]} file is not valid! RegExp: ${e.message}, $file');
  }
  return Future.delayed(bufferDuration);
}
