#!/usr/bin/env bash

toplevel="$(git -C "$(dirname "$0")" rev-parse --show-toplevel)"
cd "${toplevel}"

export SOURCECRED_DIRECTORY="${toplevel}/sourcecred_data"

die() {
    printf >&2 'fatal: %s\n' "$@"
    exit 1
}

# Check our dependencies.
[ -z "$(which node)" ] && die "Node must be installed and available in \$PATH"
[ -z "$(which yarn)" ] && die "Yarn must be installed and available in \$PATH"

# Make sure we have a token.
[ ! -e "secrets/token" ] && die "A secrets/token file is expected relative to the repository root."
SOURCECRED_GITHUB_TOKEN=`cat secrets/token`
[ -z "${SOURCECRED_GITHUB_TOKEN}" ] && die "The secrets/token file is empty, it should contain a GitHub personal access token."

# Find our repository list.
[ ! -e "repositories.txt" ] && die "A repositories.txt file is expected in the repository root."
REPOS="$(cat repositories.txt)"

# Rebuild weight overrides from root toml file.
cd mkweights
yarn
cd ..
cat ./weights.toml | node mkweights > .weights.json

# Rebuild sourcecred dependencies.
cd sourcecred
yarn install
yarn backend

# Reload repository data.
for repo in $REPOS; do
	SOURCECRED_GITHUB_TOKEN=$SOURCECRED_GITHUB_TOKEN node bin/sourcecred.js load $repo --weights ../.weights.json
done
cd ..

# Generate our widgets using the scores.json export format.
cd widgets
yarn
export SVG_MIN_CRED=4.5
export SVG_MAX_USERS=50
for repo in $REPOS; do
	echo "Generating ${repo//\//-}-contributors.svg"
	node ../sourcecred/bin/sourcecred.js scores $repo | SOURCECRED_GITHUB_TOKEN=$SOURCECRED_GITHUB_TOKEN ./bin/contributor-wall-svg.js > "../${repo//\//-}-contributors.svg"
done
