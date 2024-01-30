#!/bin/bash
if [ $force_remote_control == "true" ] && [ $use_local == "true" ]; then
    echo "${RED}FORCE REMOTE CONTROL IS OPEN! You try to build or upload the app with use_local=true !! Please make use_local=false in the ./assets/config/build-configuration.yaml file\n"
    exit 1
fi
