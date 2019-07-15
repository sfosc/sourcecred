#!/usr/bin/env bash

export SOURCECRED_DIRECTORY=$(pwd)/sourcecred_data
SOURCECRED_GITHUB_TOKEN=`cat secrets/token`

cd mkweights
npm i
cd ..

cat ./weights.toml | node mkweights > .weights.json

cd sourcecred
yarn install
yarn backend

SOURCECRED_GITHUB_TOKEN=$SOURCECRED_GITHUB_TOKEN node bin/sourcecred.js load sfosc/sfosc --weights ../.weights.json
SOURCECRED_GITHUB_TOKEN=$SOURCECRED_GITHUB_TOKEN node bin/sourcecred.js load sfosc/wizard --weights ../.weights.json

yarn start
