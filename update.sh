#!/bin/bash

echo "---------------successfully login to $USER---------------"

LAST_IMAGE=`cat /home/fuhong_tang_china/.lastImage.txt`
echo "read last version image info successfully"

HUB_APP=$1
VERSION=$2
FULL_IMAGE_NAME="$HUB_APP:$VERSION"

echo "====last image version info: $LAST_IMAGE===="
echo "====new image version info: $FULL_IMAGE_NAME===="

if [[ $1 = '' ]];
then
  echo "---------------nee a full version info---------------"
  exit
fi

if [[ $FULL_IMAGE_NAME = $LAST_IMAGE ]];
then
  echo "---------------last version is same with new new version, don't update---------------"
  exit
fi

docker pull $FULL_IMAGE_NAME
echo '---------------image pull finished---------------'

ImageId=`docker images | grep -E $HUB_APP | grep -E $VERSION | awk '{print $3}'`
echo "image id: $ImageId"

docker rm -f backup
echo "---------------old server backup removed---------------"

docker run -d --name backup -p 5999:5000  -e JWTSECRET=secret -e DB_USERNAME=todo -e DB_PASSWORD=adming -e DB_NAME=todoDB $ImageId
echo "backup server started"

docker rm -f mern1
echo "---------------server mern1 removed---------------"

docker rm -f mern2
echo "---------------server mern2 removed---------------"

docker run -d --name mern1 -p 5001:5000 -e JWTSECRET=secret -e DB_USERNAME=todo -e DB_PASSWORD=adming -e DB_NAME=todoDB $ImageId
echo "---------------server mern1 started---------------"

docker run -d --name mern2 -p 5002:5000 -e JWTSECRET=secret -e DB_USERNAME=todo -e DB_PASSWORD=adming -e DB_NAME=todoDB $ImageId
echo "---------------server mern2 started---------------"

docker rmi $LAST_IMAGE
echo "---------------old image removed---------------"

echo $FULL_IMAGE_NAME > /home/fuhong_tang_china/.lastImage.txt
echo "---------------new image info written successfully---------------"

echo "---------------deploy finished---------------"
echo "---------------new version is $FULL_IMAGE_NAME---------------"





