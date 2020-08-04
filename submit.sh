#!/usr/bin/env bash

HUB="g6219700"
APP="mern"

if [[ $1 = '' ]];
then
  VERSION="latest"
else
  VERSION=$1
fi

#join full app name
FULL_APP_NAME="$HUB/$APP:$VERSION"
echo "full name: $FULL_APP_NAME"

#recover unsubmit code
git checkout .
echo 'finish checkout'

#pull from remote repository
git pull
echo 'finish pull from remote repository'

#install modules and package code of client
yarn install
yarn heroku-postbuild
echo "finish install js libraries and build project"

docker build -t $FULL_APP_NAME .
echo "finish build docker image"

docker logout
echo "logout docker successfully"

docker login -u g6219700 -p 787a4aed-15f0-4979-b060-a3103343aba9
echo "login docker successfully"

docker push $FULL_APP_NAME
echo "push to docker hub successfully"

#ssh fuhong_tang_china@34.72.111.143 sh ~/update.sh $FULL_APP_NAME
ssh fuhong_tang_china@34.72.111.143 sh ~/update.sh $FULL_APP_NAME
















