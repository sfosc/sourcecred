#!/usr/bin/env bash
# Make sure the pwd is the root of the repository.

# Rebuild weight overrides from root toml file.
rm sourcecred/weights.json
if [ -e "weights.toml" ]; then
	echo "Converting weights.toml"
	cd mkweights
	npm install --production
	cd ..
	cat weights.toml | node mkweights > sourcecred/weights.json
fi
