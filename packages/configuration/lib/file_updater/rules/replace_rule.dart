import '../file_updater.dart';

class ReplaceRule extends UpdateRule {
  ReplaceRule(UpdateRuleModel ruleModel) : super(ruleModel);
  @override
  UpdateResult update(String line) {
    isMatched = false;
    final result = line.replaceFirstMapped(ruleModel.regExp, (Match match) {
      isMatched = true;
      return ruleModel.resultValue;
    });

    validate(result);

    return UpdateResult(isMatched, result);
  }
}
