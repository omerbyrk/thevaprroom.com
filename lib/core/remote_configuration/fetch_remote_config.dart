import 'dart:convert';
import 'dart:io';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'configuration.dart';
import '../../consts.dart';
import '../app_helper.dart';

class FetchRemoteConfig {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  late Configuration _localConfiguration;

  FetchRemoteConfig._();

  static final FetchRemoteConfig _remoteConfigHelper = FetchRemoteConfig._();

  factory FetchRemoteConfig.getInstance() => _remoteConfigHelper;

  Future<void> fetchFromFirebase() async {
    await _remoteConfig.ensureInitialized();
    _localConfiguration = await Configuration.getInstanceFromLocal();

    await setConfigDefaults();

    int configFetchInterval = 0;

    try {
      configFetchInterval =
          json.decode(configuration)["config_fetch_interval"] ?? 0;
    } catch (e) {
      debugPrint('format error  on config file.! $e');
    } finally {
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: Duration(seconds: configFetchInterval),
      ));
    }

    try {
      bool success = await _remoteConfig.fetchAndActivate();

      if (success) {
        (await SharedPreferences.getInstance())
            .setString(AppConsts.configurationCacheKey, configuration);
      }
    } catch (error, stack) {
      debugPrint(error.toString());
      debugPrint(stack.toString());
      AppHelper.alertError(error, stack);
    } finally {
      debugPrint(_localConfiguration.configurationKey);
      debugPrint(_remoteConfig.getString(_localConfiguration.configurationKey));
    }
  }

  String get configuration {
    var conf = _remoteConfig.getString(
        "${Platform.isAndroid ? 'android' : 'ios'}_${_localConfiguration.configurationKey}");
    print("platform configuration (ios or android)->$conf");

    if (conf.isEmpty) {
      return _remoteConfig.getString(_localConfiguration.configurationKey);
    }

    return conf;
  }

  Future<void> setConfigDefaults() async {
    var cacheConfiguration = (await SharedPreferences.getInstance())
        .getString(AppConsts.configurationCacheKey);

    if (cacheConfiguration != null && cacheConfiguration != "") {
      await _remoteConfig.setDefaults(
          {_localConfiguration.configurationKey: cacheConfiguration});
    } else {
      await _remoteConfig.setDefaults({
        _localConfiguration.configurationKey:
            json.encode(_localConfiguration.toMap())
      });
    }
  }
}
