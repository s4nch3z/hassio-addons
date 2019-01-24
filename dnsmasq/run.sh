#!/bin/bash
set -e

CONFIG_PATH=/data/options.json

DEFAULTS=$(jq --raw-output '.defaults[]' ${CONFIG_PATH})
FORWARDS=$(jq --raw-output '.forwards | length' ${CONFIG_PATH})
HOSTS=$(jq --raw-output '.hosts | length' ${CONFIG_PATH})
DOMAIN=$(jq --raw-output '.domain // empty' ${CONFIG_PATH})
CACHE_SIZE=$(jq --raw-output '.cacheSize // empty' ${CONFIG_PATH})

# Add default forward servers
for line in ${DEFAULTS}; do
    echo "server=$line" >> /etc/dnsmasq.conf
done

# Create domain forwards
for (( i=0; i < "${FORWARDS}"; i++ )); do
    DOMAIN=$(jq --raw-output ".forwards[$i].domain" ${CONFIG_PATH})
    SERVER=$(jq --raw-output ".forwards[$i].server" ${CONFIG_PATH})

    echo "server=/${DOMAIN}/${SERVER}" >> /etc/dnsmasq.conf
done

# Create static hosts
for (( i=0; i < "${HOSTS}"; i++ )); do
    HOST=$(jq --raw-output ".hosts[$i].host" ${CONFIG_PATH})
    IP=$(jq --raw-output ".hosts[$i].ip" ${CONFIG_PATH})

    echo "address=/${HOST}/${IP}" >> /etc/dnsmasq.conf
done

if [[ -n "${DOMAIN}" ]]; then
    echo "domain=${DOMAIN}" >> /etc/dnsmasq.conf
fi

if [[ -n "${CACHE_SIZE}" ]]; then
    echo "cache-size=${CACHE_SIZE}" >> /etc/dnsmasq.conf
fi


# run dnsmasq
exec dnsmasq -C /etc/dnsmasq.conf -z < /dev/null
