#!/bin/bash

# check latest released tagged version
LATEST_VERSION_TAG="$(curl https://api.github.com/repos/RPCS3/rpcs3-binaries-linux/releases/latest -s | jq .tag_name -r)"
CURRENT_VERSION_SNAP="$(snap info rpcs3-emu | grep stable | head -n 2 | tail -n 1 | awk -F ' ' '{print $2}')"
LATEST_VERSION_COMMIT=${LATEST_VERSION_TAG#build-}
LATEST_VERSION="$(curl https://api.github.com/repos/RPCS3/rpcs3-binaries-linux/releases/latest -s | jq .name -r)"


# compare versions
if [ $CURRENT_VERSION_SNAP != $LATEST_VERSION ]; then
    echo "versions don't match, github: $LATEST_VERSION snap: $CURRENT_VERSION_SNAP"
    echo "updating rpcs3 source commit"
    yq w -i snap/snapcraft.yaml parts.rpcs3.source-commit $LATEST_VERSION_COMMIT
    echo true >> build
    echo $LATEST_VERSION >> latest
    echo $LATEST_VERSION_COMMIT >> latest_commit
    echo $CURRENT_VERSION_SNAP >> current
else
    echo "versions match, github: $LATEST_VERSION snap: $CURRENT_VERSION_SNAP"
    echo false >> build
fi


