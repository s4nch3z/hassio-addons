ARG BUILD_FROM
FROM $BUILD_FROM

# Add env
ENV LANG C.UTF-8

# Setup base
RUN apk add --no-cache jq nodejs nodejs-npm \
    && npm config set unsafe-perm true \
    && npm install -g smartthings-mqtt-bridge mustache \
    && npm config set unsafe-perm false

# Copy data
COPY template.yaml /templates/
COPY run.sh /

# We need to percist state, so using data
ENV CONFIG_DIR=/data

CMD [ "/run.sh" ]