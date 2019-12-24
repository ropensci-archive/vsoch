#!/bin/bash

# This script will derive the submodule name from the GitHub branch parameter
# in the event json, and then cd into the submodule folder and install
# packages using r-hub. This ideally would be a proper workflow file (yml)
# inserted into the main workflow, but for now we are using scripts to simplify.


# 1. Derive submodule name, and update
label_from=$(jq --raw-output .pull_request.head.label "${GITHUB_EVENT_PATH}");
submodule_hash=$(echo "${label_from//$LABEL_FROM}");
echo "Submodule and hash are $submodule_hash";
submodule=(${submodule_hash//-/ });
echo "Submodule is $submodule";
echo "${submodule}" > submodule-name;
git submodule update --init --remote --depth 1 -- "${submodule}";

# 2. Derive Version and package names
VERSION=$(grep '^Version:' "${submodule}/DESCRIPTION" | sed 's/^Version://')
VERSION=$(echo -n "${VERSION//[[:space:]]/}")
PKG_VERSION="${submodule}_${VERSION}"
PKG_SOURCE="${PKG_VERSION}.tar.gz"      
PKG_BINARY="${PKG_VERSION}${BINEXT}"
COMMIT_TIMESTAMP=$(git log -1 --format=%ct)

# 3. Show package contents, for debugging
cd "${submodule}";
echo "Present working directory is $PWD";
echo "Files provided in submodule folder are:";
ls ${PWD};

# 4. Set environment variables for following actions
echo "::set-env name=PKG::${submodule}"
echo "::set-env name=VERSION::${VERSION}"
echo "::set-env name=PKG_SOURCE::${PKG_SOURCE}"
echo "::set-env name=PKG_BINARY::${PKG_BINARY}"
echo "::set-env name=COMMIT_TIMESTAMP::${COMMIT_TIMESTAMP}"
