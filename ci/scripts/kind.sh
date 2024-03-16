#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

wget -q https://github.com/kubernetes-sigs/kind/releases/download/v0.22.0/kind-linux-amd64
chmod +x kind-linux-amd64 && mv kind-linux-amd64 /usr/local/bin/kind

K8SVERSION=${K8SVERSION:-"v1.27.3"}
WORKSPACE=$PWD

envsubst < ci/artifact/kind.yaml

envsubst < ci/artifact/kind.yaml | kind create cluster -v7 --retain --wait 4m --config -

# sed -i  's/K8SVERSION/'$K8SVERSION'/g' $WORKSPACE/ci/artifact/kind.yaml
# sed -i  's#WORKSPACE#'$WORKSPACE'#g' $WORKSPACE/ci/artifact/kind.yaml
#kind create cluster --retain --config $WORKSPACE/ci/artifact/kind.yaml

kubectl wait node --all --for condition=ready
