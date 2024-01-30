import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:configuration/printer.dart';

import 'constants.dart';
import 'custom_exceptions.dart';
import 'helper.dart';

const String fileOption = 'file';
const String updateRulesOption = 'update-rules';
const String helpFlag = 'help';
const String debugFlag = 'debug';

late ArgResults argResults;

Future<void> updateWebvifyConfigurationFromArguments(
    List<String> arguments) async {
  final parser = ArgParser(allowTrailingOptions: true);
  parser.addFlag(
    debugFlag,
    abbr: 'd',
    help: 'Usage Debug',
    negatable: false,
  );
  parser.addFlag(
    helpFlag,
    abbr: 'h',
    help: 'Usage help',
    negatable: false,
  );
  // Make default null to differentiate when it is explicitly set
  parser.addOption(
    fileOption,
    abbr: 'f',
    help: 'Config file (default: $DEFAULT_CONFIG_FILES)',
  );

  parser.addOption(
    updateRulesOption,
    abbr: 'r',
    help: 'Update Rules',
  );
  argResults = parser.parse(arguments);

  if (argResults[helpFlag]) {
    info('Updates Webvify Configuration for iOS and Android');
    stdout.writeln(parser.usage);
    exit(0);
  }

  try {
    await runRegExRules();
  } catch (e) {
    if (e is InvalidFormatException) {
      error('Invalid configuration format.');
    } else {
      error(e.toString());
    }
    exit(2);
  }
}

/*Future<void> updateWebvifyConfigurationFromConfig(Configuration config) async {
  await updateAndroidAppNameAndID(config);
  await updateIOSAppNameAndID(config);
  await updateDeepLink(config);
  await updateAdmob(config);
  await updateBuildVersion(config);
  await updateForceRemoteControl(config);
  await updateUseLocal(config);
}

Future<void> updateUseLocal(Configuration config) async {
  if (config.useLocal != null) {
    await updateFile(
      BUILD_VARIABLES_FILE,
      Shell(
        USE_LOCAL_KEY,
        config.useLocal!.toString(),
      ),
      operation: 'Use Local',
      expectedMatchCount: 1,
    );
  }

  return Future.delayed(bufferDuration);
}

Future<void> updateForceRemoteControl(Configuration config) async {
  if (config.forceRemoteControl != null) {
    await updateFile(
      BUILD_VARIABLES_FILE,
      Shell(
        FORCE_REMOTE_CONTROL,
        config.forceRemoteControl!.toString(),
      ),
      operation: 'Force Remote Control',
      expectedMatchCount: 1,
    );
  }
}

Future<void> updateBuildVersion(Configuration config) async {
  if (config.buildVersion == null) return;

  if (config.buildVersion!.buildName != null) {
    await updateFile(
      BUILD_VARIABLES_FILE,
      Shell(
        BUILD_NAME,
        config.buildVersion!.buildName!.toString(),
      ),
      operation: 'Build Name',
      expectedMatchCount: 1,
    );
  }

  if (config.buildVersion!.buildNumber != null) {
    await updateFile(
      BUILD_VARIABLES_FILE,
      Shell(
        BUILD_NUMBER,
        config.buildVersion!.buildNumber!.toString(),
      ),
      operation: 'Build Number',
      expectedMatchCount: 1,
    );
  }
}

Future<void> updateAdmob(Configuration config) async {
  if (config.admob == null) return;

  if (config.admob!.androidAppID != null) {
    await updateFile(
      ANDROID_MANIFEST_FILE,
      RegExpRule(
        RegExp(r'[a-z]{2}-[a-z]{3}-[a-z]{3}-[0-9]{16}~[0-9]{10}'),
        config.admob!.androidAppID!,
      ),
      operation: 'Android Admob',
      expectedMatchCount: 1,
    );
  }

  if (config.admob!.iOSAppID != null) {
    await updateFile(
      IOS_PLIST_FILE,
      RegExpRule(
        RegExp(r'[a-z]{2}-[a-z]{3}-[a-z]{3}-[0-9]{16}~[0-9]{10}'),
        config.admob!.iOSAppID!,
      ),
      operation: 'iOS Admob',
      expectedMatchCount: 1,
    );
  }
}

Future<void> updateDeepLink(Configuration config) async {
  if (config.deepLink == null) return;
  final deepLink = config.deepLink!.link!
      .replaceFirst('https://', '')
      .replaceFirst('http://', '');

  final List<String> deepLinkSplitted = deepLink.split('.');

  if (deepLinkSplitted.length < 2) {
    error(
        '${config.deepLink} is not correct format. Please use your hosting address as deep link. Like google.com, facebook.com(only domainaddress.extension)');
    return;
  }

  info(
      'Deep link must be same as your hosting address, For example if your link: https://webvify.app, deep link should be only webvify.app (without https://)');

  if (deepLinkSplitted.length > 2) {
    warning(
        'It seems you are using subdomain as deep link. Please consider to check this report...');
  }

  final _deepLink = '${deepLinkSplitted[deepLinkSplitted.length - 2]}';
  final _appLink = '$_deepLink.${deepLinkSplitted.last}';
  final _dynamicLink =
      '${deepLinkSplitted[deepLinkSplitted.length - 2]}.page.link';

  await updateFile(
    IOS_ENTITLEMENTS_FILE,
    RegExpRule(
      RegExp(r'(applinks:[a-z_-]*.page.link)<'),
      'applinks:$_dynamicLink<',
    ),
    operation: 'iOS Dynamic Link',
    expectedMatchCount: 1,
  );

  await updateFile(
    IOS_ENTITLEMENTS_FILE,
    RegExpRule(
      RegExp(r'(applinks:[a-z_-]*.[a-z_-]*)<'),
      'applinks:$_appLink<',
    ),
    operation: 'iOS Universal Link',
    expectedMatchCount: 1,
  );

  await updateFile(
    IOS_ENTITLEMENTS_FILE,
    RegExpRule(
      RegExp(r'(applinks:www.[a-z_-]*.[a-z_-]*)<'),
      'applinks:www.$_appLink<',
    ),
    operation: 'Second iOS Universal Link',
    expectedMatchCount: 1,
  );

  await updateFile(
    ANDROID_MANIFEST_FILE,
    RegExpRule(
      RegExp(r'android:host="[a-z-_]*[.][a-z-_]*"'),
      'android:host="$_appLink"',
    ),
    operation: 'Android App Link',
    expectedMatchCount: 1,
  );

  await updateFile(
    ANDROID_MANIFEST_FILE,
    RegExpRule(RegExp(r'android:host="www.[a-z-_]*[.][a-z-_]*"'),
        'android:host="www.$_appLink"'),
    operation: 'Second Android App Link',
    expectedMatchCount: 1,
  );

  /* await updateFile(
    ANDROID_MANIFEST_FILE,
    RegExpRule(
        RegExp(r'android:scheme="(?!http).*"'), 'android:scheme="$_deepLink"'),
    operation: 'Android Deep Link',
    expectedMatchCount: 1,
  );*/

  await updateFile(
    APPLE_APP_SITE_ASSOCIATION_FILE,
    JSONFile(IOS_APP_LINKS_BUNDLE_ID_KEY,
        '"${config.deepLink!.appleTeamID!}.${config.ios!.id!}"'),
    operation: 'Bundle ID for iOS Universal Link',
    expectedMatchCount: 1,
  );

  await updateFile(
    ASSETLINKS_FILE,
    JSONFile(ANDROID_APP_LINKS_BUNDLE_ID_KEY, '"${config.android!.id!}"'),
    operation: 'Bundle ID for Android App Link',
    expectedMatchCount: 1,
  );
}

Future<void> updateIOSAppNameAndID(Configuration config) async {
  if (config.ios == null) return;

  if (config.ios!.id != null) {
    await updateFile(
      IOS_PBXPROJ_FILE,
      Pbxproj(
        IOS_APPID_KEY,
        config.ios!.id!,
      ),
      operation: 'iOS Application ID',
      expectedMatchCount: 4,
    );
  }

  if (config.ios!.name != null) {
    await updateFile(
      IOS_PLIST_FILE,
      Plist(IOS_APPNAME_KEY, config.ios!.name!),
      operation: 'iOS Application Name',
      expectedMatchCount: 1,
    );
  }
}

Future<void> updateAndroidAppNameAndID(Configuration config) async {
  if (config.android == null) return;

  if (config.android!.id != null) {
    await updateFile(
      ANDROID_GRADLE_FILE,
      GradleString(
        ANDROID_APPID_KEY,
        config.android!.id!,
      ),
      operation: 'Android Application ID',
      expectedMatchCount: 1,
    );
  }
  if (config.android!.name != null) {
    await updateFile(
      ANDROID_MANIFEST_FILE,
      XmlAttribute(
        ANDROID_APPNAME_KEY,
        config.android!.name!,
      ),
      operation: 'Android Application Name',
      expectedMatchCount: 1,
    );
  }
}*/
