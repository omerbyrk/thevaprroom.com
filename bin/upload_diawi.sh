#!/bin/bash

set -e
cd $WEBVIFY_BASE_PATH
sh ./bin/force_remote_control.sh
set +e
echo "Uploading .apk to diawi!"
rm -r build/app
sh ./bin/build_apk.sh
curl https://upload.diawi.com/ -F token=$diawi_token -F file=@build/app/outputs/flutter-apk/app-release.apk -F callback_email=$diawi_callback_email >./build/diawi.json --http1.1

job=$(cat ./build/diawi.json | ./bin/jq -r '.job')

echo "${RED}Waiting for the links!!!!${NC}"
sleep 10

curl -vvv "https://upload.diawi.com/status?token=$diawi_token&job=$job" >./build/diawi_status.json

echo "${RED}You can access the test apk via below link!!!!${NC}"
cat ./build/diawi_status.json | ./bin/jq -r '.link'
