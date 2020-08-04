#!/bin/bash

HUB="g6219700"
APP="mern"

if [[ $1 = '' ]];
then
  VERSION="latest"
else
  VERSION=$1
fi

#join full app name
FULL_IMAGE_NAME="$HUB/$APP:$VERSION"
echo "---------------full name: $FULL_IMAGE_NAME---------------"

#recover unsubmit code
git checkout .
echo '---------------finish checkout---------------'

#pull from remote repository
git pull
echo '---------------finish pull from remote repository---------------'

#install modules and package code of client
yarn install
yarn heroku-postbuild
echo "---------------finish install js libraries and build project---------------"

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

ssh fuhong_tang_china@34.72.111.143  /bin/bash /home/fuhong_tang_china/update.sh "$HUB/$APP" $VERSION
if [ $? -ne 0 ]; then
    echo "---------------login to remote server failed---------------"
    exit
else
    echo "---------------login to remote server successfully---------------"
fi
















