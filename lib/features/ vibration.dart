import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'feature.dart';
// import 'package:vibration/vibration.dart';

class VibrationFeature extends Feature {
  @override
  void trigger() async {
    // duration parametresi calismiyor ios tarafinda, o yuzden pattern ve intensities kullandik, boyle iyi
    /*int duration = int.tryParse(tr("vibrate_duration")) ?? 500;
    int amplitude = int.tryParse(tr("vibrate_amplitude")) ?? -1;

    if (parameters.containsKey("duration")) {
      duration = int.parse(parameters['duration']!);
    }

    if (parameters.containsKey("amplitude")) {
      amplitude = int.parse(parameters['amplitude']!);
    }

    Vibration.vibrate(
        pattern: [0, duration], intensities: [0, 255], amplitude: amplitude);*/
  }
}
