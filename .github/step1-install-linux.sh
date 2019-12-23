#!/bin/bash

# This script will derive the submodule name from the GitHub branch parameter
# in the event json, and then cd into the submodule folder and install
# packages using r-hub. This ideally would be a proper workflow file (yml)
# inserted into the main workflow, but for now we are using scripts to simplify.

label_from=$(jq --raw-output .pull_request.head.label "${GITHUB_EVENT_PATH}");
submodule_hash=$(echo "${label_from//$LABEL_FROM}");
echo "Submodule and hash are $submodule_hash";
submodule=(${submodule_hash//-/ });
echo "Submodule is $submodule";
echo "${submodule}" > submodule-name;
git submodule update --init --remote -- $submodule;
cd "${submodule}";
echo "Present working directory is $PWD";
echo "Files provided in submodule folder are:";
ls ${PWD};
Rscript -e "install.packages('remotes')" -e "remotes::install_github('r-hub/sysreqs')"
sysreqs=$(Rscript -e "cat(sysreqs::sysreq_commands('DESCRIPTION'))")
sudo -s eval "${sysreqs}"
