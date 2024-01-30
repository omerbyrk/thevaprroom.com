import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'feature.dart';

class SubscribeToTopic extends Feature {
  @override
  void trigger() async {
    if (parameters.containsKey("topic")) {
      FirebaseMessaging.instance.subscribeToTopic(parameters["topic"]!);
      debugPrint("SubscribeToTopic ${parameters['topic']!} ");
    }
  }
}
