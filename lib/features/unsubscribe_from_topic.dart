import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'feature.dart';

class UnsubscribeFromTopic extends Feature {
  @override
  void trigger() async {
    if (parameters.containsKey("topic")) {
      FirebaseMessaging.instance.unsubscribeFromTopic(parameters["topic"]!);
      debugPrint("UnsubscribeFromTopic ${parameters['topic']!} ");
    }
  }
}
