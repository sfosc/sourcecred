#!/usr/bin/env bash
# Make sure the pwd is the root of the repository.

# Rebuild weight overrides from root toml file.
rm .weights.json
if [ -e "weights.toml" ]; then
	echo "Converting weights.toml"
	cd mkweights
	npm install --production
	cd ..
	cat weights.toml | node mkweights > .weights.json
fi
