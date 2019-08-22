#!/usr/bin/env bash

CNAME="${CNAME:-"sfosc.org"}"
SVG_MIN_CRED=${SVG_MIN_CRED:-0.5}
SVG_MAX_USERS=${SVG_MAX_USERS:-50}

toplevel="$(git -C "$(dirname "$0")" rev-parse --show-toplevel)"
cd "${toplevel}"

die() {
    printf >&2 'fatal: %s\n' "$@"
    exit 1
}

# Check our dependencies.
[ -z "$(which node)" ] && die "Node must be installed and available in \$PATH"
[ -z "$(which yarn)" ] && die "Yarn must be installed and available in \$PATH"

# Make sure we have a token.
[ -z "${SOURCECRED_GITHUB_TOKEN}" ] && die "No SOURCECRED_GITHUB_TOKEN has been set."

# Find our repository list.
[ ! -e "repositories.txt" ] && die "A repositories.txt file is expected in the repository root."
REPOS="$(cat repositories.txt)"

# Rebuild weight overrides from root toml file.
WEIGHTS_OPT=""
[ -e ".weights.json" ] && rm .weights.json
if [ -e "weights.toml" ]; then
	echo "Converting weights.toml"
	cd mkweights
	yarn --production
	cd ..
	cat weights.toml | node mkweights > .weights.json
	WEIGHTS_OPT="--weights ${toplevel}/.weights.json"
fi

# Rebuild sourcecred dependencies.
echo "Building SourceCred binaries."
cd "${toplevel}/sourcecred"
SOURCECRED_BIN="${toplevel}/sourcecred/bin"
yarn
yarn -s backend --output-path "${SOURCECRED_BIN}"

# Reload repository data.
echo "Loading repository data."
SOURCECRED_DIRECTORY="${toplevel}/sourcecred_data"
for repo in $REPOS; do
	SOURCECRED_DIRECTORY="${SOURCECRED_DIRECTORY}" node "${SOURCECRED_BIN}/sourcecred.js" load "${repo}" $WEIGHTS_OPT
done

# Create static website.
echo "Rebuilding static website"
cd "${toplevel}/sourcecred"
target="${toplevel}/site"
[ -d "${target}" ] && rm -rf "${target}"
SOURCECRED_DIRECTORY="${SOURCECRED_DIRECTORY}" yarn -s build --output-path "${target}"

# Import cred data.
mkdir "${target}/api/"
mkdir "${target}/api/v1/"
cp -r "${SOURCECRED_DIRECTORY}" "${target}/api/v1/data"
rm -rf "${target}/api/v1/data/cache"

# Set CNAME.
printf '%s' "${CNAME}" >"${target}/CNAME"  # no newline

# Generate widgets.
echo "Generating widgets"
cd "${toplevel}/widgets"
widgets_target="${target}/widgets"
mkdir -p "${widgets_target}"
yarn
for repo in $REPOS; do
	echo "Generating ${repo//\//-}-contributors.svg"
	# Buffer the score output to a file to prevent occasional read errors from STDIN.
	SOURCECRED_DIRECTORY="${SOURCECRED_DIRECTORY}" node "${SOURCECRED_BIN}/sourcecred.js" scores "${repo}" > "${toplevel}/${repo//\//-}-scores.json"
	SVG_MIN_CRED=$SVG_MIN_CRED SVG_MAX_USERS=$SVG_MAX_USERS \
		./bin/contributor-wall-svg.js > "${widgets_target}/${repo//\//-}-contributors.svg" < "${toplevel}/${repo//\//-}-scores.json"
	rm "${toplevel}/${repo//\//-}-scores.json"
done
