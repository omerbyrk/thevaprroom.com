#!/bin/bash

cd $WEBVIFY_BASE_PATH
set -e
echo "${BLUE}Creating flutter_version.txt........$NC"
flutter doctor --verbose >flutter_version.txt
flutter pub get
echo "${BLUE}Running configuration........$NC"
flutter pub run configuration:main -f ./assets/config/build-configuration.yaml -d
echo "${BLUE}Running flutter_launcher_icons........$NC"
flutter pub run flutter_launcher_icons:main -f ./assets/config/build-configuration.yaml
echo "${BLUE}Running flutter_native_splash.........$NC"
flutter pub run flutter_native_splash:create --path=./assets/config/build-configuration.yaml
echo "${BLUE}cp android notification icon..........$NC"
cp ./assets/build/android_icon/android_notification_icon.png ./android/app/src/main/res/drawable/notification_icon.png
cp ./assets/build/android_icon/android_notification_icon.png ./android/app/src/main/res/drawable-hdpi/notification_icon.png
cp ./assets/build/android_icon/android_notification_icon.png ./android/app/src/main/res/drawable-mdpi/notification_icon.png
cp ./assets/build/android_icon/android_notification_icon.png ./android/app/src/main/res/drawable-v21/notification_icon.png
cp ./assets/build/android_icon/android_notification_icon.png ./android/app/src/main/res/drawable-xhdpi/notification_icon.png
cp ./assets/build/android_icon/android_notification_icon.png ./android/app/src/main/res/drawable-xxhdpi/notification_icon.png
cp ./assets/build/android_icon/android_notification_icon.png ./android/app/src/main/res/drawable-xxxhdpi/notification_icon.png
echo "${BLUE}cp firebase files moving...............$NC"
cp ./assets/build/firebase/google-services.json ./android/app/

echo "${GREEN}All Done!$NC"
