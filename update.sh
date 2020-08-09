#!/bin/bash

echo "---------------successfully login to $USER---------------"

JWTSECRET='yourjwtscript'
DB_USERNAME='todo'
DB_PASSWORD='adming'
DB_NAME='todoDB'

LAST_IMAGE=`cat /home/$USER/.lastImage.txt`
echo "read last version image info successfully"

HUB_APP=$1
VERSION=$2
FULL_IMAGE_NAME="$HUB_APP:$VERSION"

echo "====last image version info: $LAST_IMAGE===="
echo "====new image version info: $FULL_IMAGE_NAME===="

if [[ $1 = '' ]];
then
  echo "---------------need a full version info---------------"
  exit
fi

if [[ $FULL_IMAGE_NAME = $LAST_IMAGE ]];
then
  echo "---------------last version is same with new new version, no need update---------------"
  exit
fi

docker logout
# to avoid Error response from daemon: Get https://registry-1.docker.io/v2/g6219700/love/manifests/v1: unauthorized: incorrect username or password
if [ $? -ne 0 ]; then
    echo "---------------logout docker failed, that's fine---------------"
else
    echo "---------------logout docker successfully---------------"
fi

docker pull $FULL_IMAGE_NAME
if [ $? -ne 0 ]; then
    echo "---------------pull $FULL_IMAGE_NAME from hub failed---------------"
    exit
else
    echo "---------------pull $FULL_IMAGE_NAME from hub successfully---------------"
fi

ImageId=`docker images | grep -E $HUB_APP | grep -E $VERSION | awk '{print $3}'`
echo "image id: '$ImageId'"

if [ $ImageId = '' ]; then
    echo "---------------pull $FULL_IMAGE_NAME failed---------------"
    exit
else
    echo "successfully pull $FULL_IMAGE_NAME from hub"
fi

docker rm -f backup
if [ $? -ne 0 ]; then
    echo "old server backup removed failed"
    exit
else
    echo "old server backup removed"
fi

docker run -d --name backup -p 5999:5000  -e JWTSECRET=$JWTSECRET -e DB_USERNAME=$DB_USERNAME -e DB_PASSWORD=$DB_PASSWORD -e DB_NAME=$DB_NAME $ImageId
if [ $? -ne 0 ]; then
    echo "backup server started failed"
    exit
else
    echo "backup server started"
fi

seconds_left=10
echo "please wait for ${seconds_left}s, to ensure that the backup server starts successfully"
while [ $seconds_left -gt 0 ];do
    echo -n $seconds_left
    sleep 1
    seconds_left=$(($seconds_left - 1))
    echo -ne "\r     \r" #clear digital
done

echo '---------------counter down 10s, server mern1, mern2 start to remove---------------'

docker rm -f mern1
if [ $? -ne 0 ]; then
    echo "server mern1 removed failed"
else
    echo "---------------server mern1 removed---------------"
fi

docker rm -f mern2
if [ $? -ne 0 ]; then
    echo "server mern2 removed failed"
else
    echo "---------------server mern2 removed---------------"
fi

docker run -d --name mern1 -p 5001:5000 -e JWTSECRET=$JWTSECRET -e DB_USERNAME=$DB_USERNAME -e DB_PASSWORD=$DB_PASSWORD -e DB_NAME=$DB_NAME $ImageId
if [ $? -ne 0 ]; then
    echo "server mern1 started failed"
else
    echo "---------------server mern1 started---------------"
fi

docker run -d --name mern2 -p 5002:5000 -e JWTSECRET=$JWTSECRET -e DB_USERNAME=$DB_USERNAME -e DB_PASSWORD=$DB_PASSWORD -e DB_NAME=$DB_NAME $ImageId
if [ $? -ne 0 ]; then
    echo "server mern2 started failed"
else
    echo "---------------server mern2 started---------------"
fi

docker rmi $LAST_IMAGE
if [ $? -ne 0 ]; then
    echo "---------------old image removed failed---------------"
else
    echo "---------------old image removed---------------"
fi

echo $FULL_IMAGE_NAME > /home/$USER/.lastImage.txt
if [ $? -ne 0 ]; then
    echo "---------------new image info written failed---------------"
else
    echo "---------------new image info written successfully---------------"
fi

echo "---------------deploy finished---------------"
echo "---------------new version is $FULL_IMAGE_NAME---------------"





