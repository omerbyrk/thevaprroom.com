import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../consts.dart';
import '../extensions.dart';
import '../globals.dart';
import 'app_helper.dart';
import 'app_local_notification.dart';

class FirebaseMessagingInitilizer {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  static bool initiated = false;

  static Future<void> init() async {
    if (initiated) {
      return;
    }
    initiated = true;
    try {
      _firebaseMessaging.getInitialMessage().then((message) async {
        if (message != null) {
          FlutterAppBadger.removeBadge();
          var notification =
              FirebaseNotificationModel.fromRemoteMessage(message);
          notification.log();
          if (notification.link != null && notification.link!.isNotEmpty) {
            notification.link!.toLinkRedirector
              ?..duration = const Duration(milliseconds: 500)
              ..redirect();
          }
        }
      });

      FirebaseMessaging.onMessage.listen((message) async {
        FlutterAppBadger.removeBadge();
        var notification = FirebaseNotificationModel.fromRemoteMessage(message);
        notification.log();

        if (notification.isNotification) {
          NotificationHelper.showNotification(notification);
        } else if (notification.isRemoteConfigChanges) {
          AppHelper.remoteChangesNotification(notification);
        }
      });

      FirebaseMessaging.onMessageOpenedApp.listen((message) async {
        FlutterAppBadger.removeBadge();
        var notification = FirebaseNotificationModel.fromRemoteMessage(message);
        notification.log();
        if (notification.isNotification) {
          if (notification.link != null && notification.link!.isNotEmpty) {
            notification.link!.toLinkRedirector
              ?..duration = const Duration(milliseconds: 500)
              ..redirect();
          }
        } else if (notification.isRemoteConfigChanges) {
          AppHelper.remoteChangesNotification(notification);
        }
      });

      Globals.firebaseToken = (await getToken)!;
      debugPrint("Firebase Token: ${Globals.firebaseToken}");
      _firebaseMessaging.setAutoInitEnabled(true);
      _firebaseMessaging.subscribeToTopic("all");
      _firebaseMessaging
          .subscribeToTopic(Globals.configuration.configurationKey);
      if (Globals.configuration.preferences.notificationPermission) {
        await _firebaseMessaging.requestPermission(
          alert: true,
          announcement: false,
          badge: true,
          carPlay: false,
          criticalAlert: false,
          provisional: false,
          sound: true,
        );
      }
    } catch (e, stack) {
      debugPrint(e.toString());
      debugPrint(stack.toString());
      AppHelper.alertError(e, stack);
      debugPrint(e.toString());
    }
  }

  static Future<String?> get getToken => _firebaseMessaging.getToken();
}

class FirebaseNotificationModel {
  String title;
  String body;
  String type;
  String? image;
  String? link;
  bool? forceToRestart;

  FirebaseNotificationModel({
    required this.title,
    required this.body,
    required this.type,
    this.image,
    this.link,
    this.forceToRestart,
  });

  bool get hasPicture => image != null;

  bool get isNotification => type == FirebaseNotificationTypes.notification;

  bool get isRemoteConfigChanges =>
      type == FirebaseNotificationTypes.remoteConfigChanges;

  void log() {
    debugPrint("title: $title");
    debugPrint("body: $body");
    debugPrint("image: $image");
    debugPrint("link: $link");
    debugPrint("type: $type");
  }

  Map<String, dynamic> toJSON() {
    return {
      "title": title,
      "body": body,
      "image": image,
      "link": link,
      "type": type,
      "force_to_restart": forceToRestart
    };
  }

  factory FirebaseNotificationModel.def() =>
      FirebaseNotificationModel(title: "", body: "", type: "");

  factory FirebaseNotificationModel.fromRemoteMessage(RemoteMessage message) {
    String? type = message.data.findValue("type");
    if (message.notification != null) {
      return FirebaseNotificationModel(
          title: message.notification!.title!,
          body: message.notification!.body!,
          link: message.data.findValue("link"),
          type: FirebaseNotificationTypes.notification,
          image: Platform.isAndroid
              ? message.notification!.android!.imageUrl
              : message.notification!.apple!.imageUrl);
    } else if (type == FirebaseNotificationTypes.remoteConfigChanges) {
      return FirebaseNotificationModel(
        title: message.data.findValue("title")!,
        body: message.data.findValue("body")!,
        type: message.data.findValue("type")!,
        forceToRestart: message.data.findValue("force_to_restart") == "true",
      );
    } else {
      return FirebaseNotificationModel.def();
    }
  }

  factory FirebaseNotificationModel.fromMap(Map<String, dynamic> map) {
    return FirebaseNotificationModel(
      title: map["title"],
      body: map["body"],
      link: map["link"],
      type: map["type"],
      image: map["image"],
      forceToRestart: map["force_to_restart"],
    );
  }
}

class FirebaseNotificationTypes {
  static const notification = "notification";
  static const remoteConfigChanges = "remote_config_changes";
}
