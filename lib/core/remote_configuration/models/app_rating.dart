import '../defaults.dart';

class AppRatingModel {
  final bool active;
  final int delayTime;
  final int delayDay;
  const AppRatingModel(
      {required this.active, required this.delayTime, required this.delayDay});

  factory AppRatingModel.fromMap(Map map) {
    return AppRatingModel(
      delayTime: map["delay_time"] ?? Defaults.appRating.delayTime,
      active: map["active"] ?? Defaults.appRating.active,
      delayDay: map["delay_day"] ?? Defaults.appRating.delayDay,
    );
  }

  Map<String, dynamic> toMap() => {
        "active": active,
        "delay_time": delayTime,
        "delay_day": delayDay,
      };
}
