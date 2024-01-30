import 'dart:convert';
import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../extensions.dart';
import 'app_firebase_messaging.dart';
import 'app_helper.dart';

class NotificationHelper {
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static void init() async {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings("notification_icon");
    var initializationSettingsIOS = const IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? argPayload) async {
      if (argPayload != null && argPayload.isNotEmpty) {
        var payload = json.decode(argPayload) as Map<String, dynamic>;
        var notification = FirebaseNotificationModel.fromMap(payload);
        if (notification.isNotification) {
          (notification.link ?? "").toLinkRedirector
            ?..duration = const Duration(milliseconds: 500)
            ..redirect();
        } else if (notification.isRemoteConfigChanges) {
          AppHelper.remoteChangesNotification(notification);
        }
      }
    });
  }

  static void showNotification(FirebaseNotificationModel notificationObject) {
    if (notificationObject.hasPicture) {
      NotificationHelper.showBigPictureNotification(
        1,
        notificationObject.title,
        notificationObject.body,
        notificationObject.image!,
        json.encode(
          notificationObject.toJSON(),
        ),
      );
    } else {
      NotificationHelper.showNormal(
        1,
        notificationObject.title,
        notificationObject.body,
        json.encode(
          notificationObject.toJSON(),
        ),
      );
    }
  }

  static Future<void> showNormal(
      int id, String title, String body, String? payload) async {
    //var imageLocalPath = await _downloadAndSaveFile(imageURL, 'largeIcon');
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        "Channel_ID", "channel name",
        channelDescription: "channel description",
        importance: Importance.max,
        visibility: NotificationVisibility.public,
        priority: Priority.high,
        ticker: "test ticker");

    var iOSChannelSpecifics = const IOSNotificationDetails();
    var platformSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin
        .show(id, title, body, platformSpecifics, payload: payload);
  }

  static Future<void> showBigPictureNotification(int id, String title,
      String body, String pictureURL, String? payload) async {
    final String bigPicturePath =
        await _downloadAndSaveFile(pictureURL, 'bigPicture.jpg');

    // Android
    final BigPictureStyleInformation bigPictureStyleInformation =
        BigPictureStyleInformation(
      FilePathAndroidBitmap(bigPicturePath),
      //largeIcon: FilePathAndroidBitmap(largeIconPath),
    );
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'big text channel id', 'big text channel name',
            channelDescription: 'big text channel description',
            styleInformation: bigPictureStyleInformation);

    // IOS
    final IOSNotificationDetails iOSPlatformChannelSpecifics =
        IOSNotificationDetails(attachments: <IOSNotificationAttachment>[
      IOSNotificationAttachment(bigPicturePath)
    ]);

    // Macos
    final MacOSNotificationDetails macOSPlatformChannelSpecifics =
        MacOSNotificationDetails(attachments: <MacOSNotificationAttachment>[
      MacOSNotificationAttachment(bigPicturePath)
    ]);

    final NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics,
        macOS: macOSPlatformChannelSpecifics);
    await _flutterLocalNotificationsPlugin
        .show(id, title, body, platformChannelSpecifics, payload: payload);
  }

  static Future<String> _downloadAndSaveFile(
      String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final http.Response response = await http.get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }
}
