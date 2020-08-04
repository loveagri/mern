#!/usr/bin/env bash

#recover unsubmit code
git checkout .

#pull from remote repository
git gull

#install modules and package code of client
yarn heroku-postbuild

docker build -t g6219700/client:$VERSION .

docker login -u g6219700 -p tfh123580

docker