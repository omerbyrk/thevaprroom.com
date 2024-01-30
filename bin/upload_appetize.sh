#!/bin/bash

set -e
cd $WEBVIFY_BASE_PATH
sh ./bin/force_remote_control.sh
set +e
rm -r ./build/app
rm -r ./build/ios
sh ./bin/build_apk.sh
sh ./bin/build_ios.sh
cd build/ios/iphoneos/
cd ../../..
zip -r build/ios/iphoneos/Runner.zip build/ios/iphoneos/Runner.app
echo $appetize_url
echo "Uploading .app and .apk to appetize!"
# curl --http1.1 $appetize_url -F "file=@build/app/outputs/flutter-apk/app-release.apk" -F "platform=android" -F "appPermissions.run=public" >./build/android_appetize.json
curl --http1.1 $appetize_url -F "file=@build/ios/iphoneos/Runner.zip" -F "platform=ios" -F "appPermissions.run=public" >./build/ios_appetize.json
echo "You can access the test simulator via below link!!!!"
cat ./build/android_appetize.json | ./bin/jq -r '.publicURL'
cat ./build/ios_appetize.json | ./bin/jq -r '.publicURL'
