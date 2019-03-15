#!/bin/bash

set -eu
set -o pipefail

: "${DEPLOY_ENV:?Need to set DEPLOY_ENV}"
: "${KUBECONFIG:?Need to set KUBECONFIG}"
: "${TILLER_NAMESPACE:?Need to set TILLER_NAMESPACE}"
# TILLER_NAMESPACE=gitlab-ci

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

echo $KUBECONFIG > k
export KUBECONFIG=k
# echo $KUBECONFIG

set -x

ci_user=ci-user

export NAMESPACE="gitlab-${DEPLOY_ENV}"

kubectl -n ${NAMESPACE} get po # just a test

# Starting tiller in the background"
export HELM_HOST=:44134
tiller --storage=secret --listen "$HELM_HOST" >/dev/null 2>&1 &
helm init --client-only --service-account "${ci_user}" --wait

helm repo add gitlab https://charts.gitlab.io/
helm repo update
helm upgrade --install --wait \
  --namespace ${NAMESPACE} \
  -f <($SCRIPT_DIR/../values/gen-gitlab.sh) \
  gitlab-${DEPLOY_ENV} gitlab/gitlab

# Waiting for rollout to finish
DEPLOYMENTS="$(kubectl -n ${NAMESPACE} get deployments -o json | jq -r .items[].metadata.name)"
for DEPLOYMENT in $DEPLOYMENTS; do
    kubectl rollout status --namespace=${NAMESPACE} --timeout=2m \
        --watch deployment/${DEPLOYMENT}
done
