#!/usr/bin/env bash

export SOURCECRED_DIRECTORY=$(pwd)/sourcecred_data
SOURCECRED_GITHUB_TOKEN=`cat secrets/token`
REPOS=`cat repositories.txt`

cd mkweights
yarn
cd ..

cat ./weights.toml | node mkweights > .weights.json

cd sourcecred
yarn install
yarn backend
for repo in $REPOS; do
	SOURCECRED_GITHUB_TOKEN=$SOURCECRED_GITHUB_TOKEN node bin/sourcecred.js load $repo --weights ../.weights.json
done
cd ..

cd widgets
yarn
export SVG_MIN_CRED=4.5
export SVG_MAX_USERS=50
for repo in $REPOS; do
	echo "Generating ${repo//\//-}-contributors.svg"
	node ../sourcecred/bin/sourcecred.js scores $repo | SOURCECRED_GITHUB_TOKEN=$SOURCECRED_GITHUB_TOKEN ./bin/contributor-wall-svg.js > "../${repo//\//-}-contributors.svg"
done
