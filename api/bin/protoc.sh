#!/usr/bin/env bash

# Arguments:
# -w: Watch for updates

WATCH=0

run_protoc() {
  protoc --proto_path=api --python_out=server/src/api api/wcif/*.proto
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
