import '../file_updater.dart';

class PlistRule extends UpdateRule {
  PlistRule(UpdateRuleModel ruleModel) : super(ruleModel);

  bool previousLineMatchedKey = false;

  @override
  UpdateResult update(String line) {
    isMatched = false;
    if (line.contains('<key>${ruleModel.key}</key>')) {
      previousLineMatchedKey = true;
      return UpdateResult(isMatched, line);
    }

    if (!previousLineMatchedKey) {
      return UpdateResult(isMatched, line);
    } else {
      previousLineMatchedKey = false;
      final result = line.replaceFirst(ruleModel.regExp, ruleModel.resultValue);
      isMatched = true;
      validate(result);
      return UpdateResult(isMatched, result);
    }
  }
}
