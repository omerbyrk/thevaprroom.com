#!/bin/bash

export GREEN='\033[0;32m'
export BLUE='\033[0;34m'
export RED='\033[0;31m'
export MAGENTA='\033[0;35m'
export BOLD=$(tput bold)
export NF=$(tput sgr0)
export NC='\033[0m'

export WEBVIFY_BASE_PATH=$(pwd)
export BIN_BASE_PATH=$WEBVIFY_BASE_PATH/bin/

function help() {
    echo ""
    echo -e "$GREEN./webvify.sh build$NC"
    echo -e "${BOLD}Desctiption$NF: It produces $BLUE.apk$NC, $BLUE.abb$NC and $BLUE.app$NC file to publish on app store and google play$NC"
    echo -e "${BOLD}Examples$NF: $BLUE./webvify.sh build apk$NC, $BLUE./webvify.sh build bundle$NC, $BLUE./webvify.sh build ios$NC"

    echo ""
    echo -e "$GREEN./webvify.sh run$NC"
    echo -e "${BOLD}Desctiption$NF: It runs the app on the open simulator/emulator. Please open an android or ios simulator before use this command"

    echo ""
    echo -e "$GREEN./webvify.sh upload$NC"
    echo -e "${BOLD}Desctiption$NF: It uploads the output file(apk, ipa, .app) to app store, apptize or diawi."
    echo -e "${BOLD}Example 1$NF: $BLUE./webvify.sh upload appstore$NC, this uploads the ipa file to the your app store account. You need to configure .p8 file, issuer_id and team_id before use this command"
    echo -e "${BOLD}Example 2$NF: $BLUE./webvify.sh upload diawi$NC, this produces an .apk file and upload it to diawi platform. After upload is done, you can test the android side on your device via the output public link"
    echo -e "${BOLD}Example 3$NF: $BLUE./webvify.sh .shupload appetize$NC, this produces an .apk and .app file and upload them to appetize platform. After upload is done, you can test the android and ios apps on your browser via the output public link."

    echo ""
    echo -e "$GREEN./webvify.sh configuration$NC"
    echo -e "${BOLD}Desctiption$NF: After you changed anything on the ./asset folder(./assets/config/build-configuration.yaml, ./assets/build/images, ./assets/build/firebase), you need to run this command to apply the changes to the android and ios source code"
    echo ""
}

function beforeBuildOrUpload() {
    echo "${BLUE}${BOLD}Running configuration........$NC"
    flutter pub get
    flutter pub run configuration:main -f ./assets/config/build-configuration.yaml
    source ./build_variables.sh
    source ./upload_variables.sh
}

function upload() {
    beforeBuildOrUpload
    case $1 in
    app_store)
        sh upload_app_store.sh $2
        exit 1
        ;;
    appetize)
        sh upload_appetize.sh
        exit 1
        ;;
    diawi)
        sh upload_diawi.sh
        exit 1
        ;;
    *)
        echo -e "${RED}Error: Unrecognized command. Please type  $GREEN./webvify.sh help$RED to list all the commands.$NC"
        exit 1
        ;;
    esac
}

function build() {
    beforeBuildOrUpload
    case $1 in
    apk)
        sh build_apk.sh
        exit 1
        ;;
    ipa)
        sh build_ipa.sh
        exit 1
        ;;
    bundle)
        sh build_bundle.sh
        exit 1
        ;;
    ios)
        sh build_ios.sh
        exit 1
        ;;
    *)
        echo -e "${RED}Error: Unrecognized command. Please type  $GREEN./webvify.sh help$RED to list all the commands.$NC"
        exit 1
        ;;
    esac

}

case $1 in
help)
    help
    exit 1
    ;;
configuration)
    sh ./bin/configurations.sh
    exit 1
    ;;
upload)
    cd $BIN_BASE_PATH
    upload $2 $3
    exit 1
    ;;
build)
    cd $BIN_BASE_PATH
    build $2
    exit 1
    ;;
run)
    sh ./bin/run.sh
    exit 1
    ;;
clean)
    sh ./bin/clean.sh
    exit 1
    ;;
*)
    echo -e "${RED}Error: Unrecognized command. Please type  $GREEN./webvify.sh help$RED to list all the commands.$NC"
    exit 1
    ;;
esac
