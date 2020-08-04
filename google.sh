#!/usr/bin/env bash

LAST_IMAGE=`cat .lastImage.txt`
echo "read last version image info successfully"

if [[ $1 = '' ]];
then
  FULL_APP_NAME=$LAST_IMAGE
else
  FULL_APP_NAME=$1
fi

buildLog=`docker pull $FULL_APP_NAME | grep 'Digest: sha256:' `
echo 'image pull finished'

# example: buildLog="Digest: sha256:78600a7836b7dc69b15c8456ee5ab517d9cda2874c087eace8fc5b7f850b04b4"
echo $buildLog

ImageId=`echo $buildLog |  grep 'Digest: sha256:'|sed -r "s/Digest: sha256:(.*)/\1/g"`
echo $ImageId > .imageID.txt
echo "image id: $ImageId"

docker rm -f backup
echo "old server backup removed"

docker run -d --name backup -p 5999:5000  -e JWTSECRET=secret -e DB_USERNAME=todo -e DB_PASSWORD=adming -e DB_NAME=todoDB $ImageId
echo "backup server started"

docker rm -f mern1
echo "server mern1 removed"

docker rm -f mern2
echo "server mern2 removed"

docker run -d --name mern1 -p 5001:5000 -e JWTSECRET=secret -e DB_USERNAME=todo -e DB_PASSWORD=adming -e DB_NAME=todoDB $ImageId
echo "server mern1 started"

docker run -d --name mern2 -p 5002:5000 -e JWTSECRET=secret -e DB_USERNAME=todo -e DB_PASSWORD=adming -e DB_NAME=todoDB $ImageId
echo "server mern2 started"

docker rmi $LAST_IMAGE
echo "old image removed"

echo $FULL_APP_NAME > .lastImage.txt
echo "new image info written successfully"

echo "deploy finished"
echo "new version is $FULL_APP_NAME"





