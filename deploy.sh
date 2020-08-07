#!/bin/bash

HUB="g6219700"
APP="love"

if [[ $1 = '' ]];
then
  echo "---------------please offer project version---------------"
  exit
else
  VERSION=$1
fi

#join full app name
FULL_IMAGE_NAME="$HUB/$APP:$VERSION"
echo "---------------full name: $FULL_IMAGE_NAME---------------"

#recover unsubmit code
git checkout .
echo "---------------finish checkout---------------"

#pull from remote repository
git pull
echo "---------------finish pull from remote repository---------------"

#install modules and package code of client
yarn install
yarn heroku-postbuild
echo "---------------finish install js libraries and build project---------------"

echo "---------------start to build docker image......---------------"
docker build -t $FULL_IMAGE_NAME .
if [ $? -ne 0 ]; then
    echo "---------------build docker image failed---------------"
    exit
else
    echo "---------------build docker image successfully--------------"
fi

docker logout
if [ $? -ne 0 ]; then
    echo "---------------logout docker failed, that's fine---------------"
else
    echo "---------------logout docker successfully---------------"
fi

cat .dockerpwd | docker login --username g6219700 --password-stdin
if [ $? -ne 0 ]; then
    echo "---------------login docker failed---------------"
    exit
else
    echo "---------------login docker successfully---------------"
fi

docker push $FULL_IMAGE_NAME
if [ $? -ne 0 ]; then
    echo "---------------push $FULL_IMAGE_NAME to docker hub  failed---------------"
    exit
else
    echo "---------------push $FULL_IMAGE_NAME to docker hub successfully---------------"
fi

docker rmi $FULL_IMAGE_NAME
if [ $? -ne 0 ]; then
    echo "---------------clear $FULL_IMAGE_NAME failed---------------"
else
    echo "---------------clear $FULL_IMAGE_NAME successfully---------------"
fi

seconds_left=20
echo "please wait for ${seconds_left}s, to ensure that the docker hub has synchronize the images successfully"
while [ $seconds_left -gt 0 ];do
    echo -n $seconds_left
    sleep 1
    seconds_left=$(($seconds_left - 1))
    echo -ne "\r     \r" #clear digital
done

ssh fuhong_tang_china@34.72.111.143  /bin/bash /home/fuhong_tang_china/update.sh "$HUB/$APP" $VERSION
if [ $? -ne 0 ]; then
    echo "---------------update finish failed---------------"
    exit
else
    echo "---------------update finish successfully---------------"
fi