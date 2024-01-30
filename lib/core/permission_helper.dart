import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:permission_handler/permission_handler.dart' as ph;

class PermissionHelper {
  static Future<bool> lookLocationPermission() async {
    Location location = Location();
    bool serviceEnabled;
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return false;
      }
    }

    return (await Permission.locationWhenInUse.request()) ==
        ph.PermissionStatus.granted;
  }

  static Future<bool> lookStoragePermission() async {
    if (Platform.isIOS) {
      return true;
    } else if (Platform.isAndroid) {
      final info = await DeviceInfoPlugin().androidInfo;
      if (info.version.sdkInt > 28) {
        return true;
      }

      final status = await Permission.storage.status;
      if (status == ph.PermissionStatus.granted) {
        return true;
      }

      final result = await Permission.storage.request();
      return result == ph.PermissionStatus.granted;
    }

    return false;
  }
}
