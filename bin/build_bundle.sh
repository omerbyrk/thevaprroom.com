#!/bin/bash

set -e
cd $WEBVIFY_BASE_PATH
sh ./bin/force_remote_control.sh
set +e

flutter build appbundle --release --no-tree-shake-icons --build-name=$build_name --build-number=$build_number
