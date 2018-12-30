#!/usr/bin/env bash

# Arguments:
# -w: Watch for updates

WATCH=0

rm -r server/src/api
rm -r app/lib/api
mkdir -p server/src/api/wcif
mkdir -p app/lib/api
echo """
import sys
import os

sys.path.append(os.path.dirname(__file__))
""" > server/src/api/__init__.py
cp server/src/api/__init__.py server/src/api/wcif/__init__.py

run_protoc() {
  protoc \
    --proto_path=api \
    --python_out=server/src/api \
    --dart_out=app/lib/api \
    --plugin=third_party/protobuf/protoc_plugin/bin/protoc-gen-dart \
    api/*.proto api/wcif/*.proto
}

while getopts "w" opt; do
  if [[ $opt == "w" ]]; then
    WATCH=1
  fi
done

run_protoc

if [[ $WATCH == 1 ]]; then
  echo "Watching for changes."
  while [[ true ]]; do
    if [[ $(find api -type f -mmin -0.05 -name *.proto) != "" ]] ; then
      echo "Change detected, re-compiling protos:"
      find api -type f -mmin -0.05 -name *.proto 
      run_protoc && echo "Changes compiled!"
      echo ""
    fi
    sleep 2.5
  done
fi
