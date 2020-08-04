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
echo "---------------finish build docker image---------------"

docker logout
echo "---------------logout docker successfully---------------"

cat .dockepwd | docker login --username g6219700 --password-stdin
echo "---------------login docker successfully---------------"

docker push $FULL_IMAGE_NAME
echo "---------------push to docker hub successfully---------------"

ssh fuhong_tang_china@34.72.111.143  /bin/bash /home/fuhong_tang_china/update.sh "$HUB/$APP" $VERSION
echo "---------------login to remote server successfully---------------"
















