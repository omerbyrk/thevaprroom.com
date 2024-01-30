#!/bin/bash

set -e
cd $WEBVIFY_BASE_PATH
sh ./bin/force_remote_control.sh
set +e

start_time=$(date +%s)

/usr/libexec/PlistBuddy -c "Set :teamID '${team_id}'" ./assets/ipa/ExportOptions.plist
flutter build ipa --export-options-plist=./assets/ipa/ExportOptions.plist --no-tree-shake-icons --build-name=$build_name --build-number=$build_number
end_time=$(date +%s)

elapsed=$((end_time - start_time))

echo $elapsed
