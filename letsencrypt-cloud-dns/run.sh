#!/bin/bash
set -e

CERT_DIR=/data/letsencrypt
WORK_DIR=/data/workdir
CONFIG_PATH=/data/options.json

EMAIL=$(jq --raw-output ".email" ${CONFIG_PATH})
DOMAINS=$(jq --raw-output ".domains[]" ${CONFIG_PATH})
KEYFILE=$(jq --raw-output ".keyfile" ${CONFIG_PATH})
CERTFILE=$(jq --raw-output ".certfile" ${CONFIG_PATH})
CREDENTIALS=$(jq --raw-output ".credentials" ${CONFIG_PATH})
PROP_SECONDS=$(jq --raw-output ".propagationSeconds" ${CONFIG_PATH})

mkdir -p "$CERT_DIR"
echo "${CREDENTIALS}" > "${CERT_DIR}/credentials.json"
certbot -h certonly

# Generate new certs
if [[ ! -d "${CERT_DIR}/live" ]]; then
    DOMAIN_ARR=()
    for line in ${DOMAINS}; do
        DOMAIN_ARR+=(-d "${line}")
    done

    echo "${DOMAINS}" > /data/domains.gen
    certbot certonly --non-interactive --dns-google --dns-google-credentials "${CERT_DIR}/credentials.json" --dns-google-propagation-seconds "${PROP_SECONDS}" --email "${EMAIL}" --agree-tos --config-dir "${CERT_DIR}" --work-dir "${WORK_DIR}" --preferred-challenges "dns" "${DOMAIN_ARR[@]}"

# Renew certs
else
    certbot renew --non-interactive --dns-google --dns-google-credentials "${CERT_DIR}/credentials.json" --dns-google-propagation-seconds "${PROP_SECONDS}" --config-dir "${CERT_DIR}" --work-dir "${WORK_DIR}" --preferred-challenges "dns"
fi

# copy certs to store
cp "${CERT_DIR}"/live/*/privkey.pem "/ssl/${KEYFILE}"
cp "${CERT_DIR}"/live/*/fullchain.pem "/ssl/${CERTFILE}"
