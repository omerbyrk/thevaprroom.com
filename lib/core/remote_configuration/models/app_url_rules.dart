import '../defaults.dart';

class AppURLRule {
  final String url;
  final String rule;
  final int index;
  const AppURLRule({
    required this.url,
    required this.rule,
    required this.index,
  });

  factory AppURLRule.fromMap(Map map) {
    return AppURLRule(
      url: map["url"] ?? Defaults.urlRule.url,
      rule: map["rule"] ?? Defaults.urlRule.rule,
      index: map["index"] ?? Defaults.urlRule.index,
    );
  }

  Map<String, dynamic> toMap() => {"url": url, "rule": rule, "index": index};
}
