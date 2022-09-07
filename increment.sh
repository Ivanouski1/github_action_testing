#!/bin/bash
# creating build number and release version
BUILD_NUMBER=$(cat ./app/version.properties | head -n 1 | tail -n 1 | sed -r 's/^[^0-9]*([0-9]+).*/\1/')
MINOR_VERSION=$(cat ./app/version.properties | head -n 2 | tail -n 1 | sed -r 's/^[^0-9]*([0-9]+).*/\1/')
MAJOR_VERSION=$(cat ./app/version.properties | head -n 3 | tail -n 1 | sed -r 's/^[^0-9]*([0-9]+).*/\1/')
BUILD_NUMBER=$((BUILD_NUMBER+1))
echo "BUILD_NUMBER = $BUILD_NUMBER"
echo "Release v = $MAJOR_VERSION.$MINOR_VERSION.$BUILD_NUMBER"
#replace build number in the file
REPLACE=$((BUILD_NUMBER-1))
sed -i "s/BUILD_VERSION=$REPLACE/BUILD_VERSION=$BUILD_NUMBER/g" ./app/version.properties
###