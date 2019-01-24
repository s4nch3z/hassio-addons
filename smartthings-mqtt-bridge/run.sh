#!/bin/bash
set -e

mustache /data/options.json /templates/template.yaml > /data/config.yml
smartthings-mqtt-bridge