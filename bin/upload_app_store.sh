#!/bin/bash

set -e
cd $WEBVIFY_BASE_PATH
sh ./bin/force_remote_control.sh
set +e

start_time=$(date +%s)

mkdir -p ~/private_keys

cp $private_key_path ~/Library/Mobile\ Documents/com~apple~CloudDocs/private_keys/
mv $private_key_path ~/private_keys/

optionsFile="./assets/ipa/ExportOptions.plist"
if [ "$1" == "--manual" ]; then
    optionsFile="./assets/ipa/ExportOptions_mn.plist"
fi

rm -r build/ios/ipa/
/usr/libexec/PlistBuddy -c "Set :teamID '${team_id}'" $optionsFile
flutter build ipa --export-options-plist=$optionsFile --no-tree-shake-icons --build-name=$build_name --build-number=$build_number

echo "Uploading .ipa to app store!"

xcrun altool --upload-app --type ios -f build/ios/ipa/*.ipa --apiKey $api_key_id --apiIssuer $issuer_id

end_time=$(date +%s)

elapsed=$((end_time - start_time))

echo $elapsed
