#!/bin/bash

set -eu
set -o pipefail

# : "${DEPLOY_ENV:?Need to set DEPLOY_ENV}"
# : "${EMAIL_FROM_ADDRESS:?Need to set EMAIL_FROM_ADDRESS}"
# : "${EMAIL_HOST:?Need to set EMAIL_HOST}"
# : "${EMAIL_PORT:?Need to set EMAIL_PORT}"
# : "${EMAIL_USER:?Need to set EMAIL_USER}"
# : "${EMAIL_PASSWORD:?Need to set EMAIL_PASSWORD}"
# : "${EMAIL_USE_TLS:?Need to set EMAIL_USE_TLS}"
# : "${GOOGLE_CLIENT_ID:?Need to set GOOGLE_CLIENT_ID}"
# : "${GOOGLE_CLIENT_SECRET:?Need to set GOOGLE_CLIENT_SECRET}"
# : "${GITHUB_APP_ID:?Need to set GITHUB_APP_ID}"
# : "${GITHUB_API_SECRET:?Need to set GITHUB_API_SECRET}"
#
# case ${DEPLOY_ENV} in
#   ci)
#     HOSTNAME=sentry-ci.kapps.l.cld.gov.au
#     CLUSTER_ISSUER=letsencrypt-staging
#     ;;
#   prod)
#     HOSTNAME=sentry.cloud.gov.au
#     CLUSTER_ISSUER=letsencrypt-prod
#     ;;
#   *)
#     echo "Unknown DEPLOY_ENV: ${DEPLOY_ENV}"
#     exit 1
#     ;;
# esac
#
# export NAMESPACE="sentry-${DEPLOY_ENV}"
#
# TLS_SECRET_NAME="${HOSTNAME//./-}-tls"
#
# POSTGRES_DB_NAME="$(kubectl -n ${NAMESPACE} get secret sentry-db-binding -o json | jq -r '.data.DB_NAME' | base64 -d)"
# POSTGRES_ENDPOINT_ADDRESS="$(kubectl -n ${NAMESPACE} get secret sentry-db-binding -o json | jq -r '.data.ENDPOINT_ADDRESS' | base64 -d)"
# POSTGRES_MASTER_PASSWORD="$(kubectl -n ${NAMESPACE} get secret sentry-db-binding -o json | jq -r '.data.MASTER_PASSWORD' | base64 -d)"
# POSTGRES_MASTER_USERNAME="$(kubectl -n ${NAMESPACE} get secret sentry-db-binding -o json | jq -r '.data.MASTER_USERNAME' | base64 -d)"
# POSTGRES_PORT="$(kubectl -n ${NAMESPACE} get secret sentry-db-binding -o json | jq -r '.data.PORT' | base64 -d)"

cat <<EOF
global:
  hosts:
    domain: gitlab.kapps.l.cld.gov.au
    externalIP: 10.10.10.10
  ingress:
    configureCertmanager: false
certmanager:
  install: false
nginx-ingress:
  enabled: false
prometheus:
  install: false
gitlab-runner:
  install: false
EOF
