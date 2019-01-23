ARG BUILD_FROM
FROM $BUILD_FROM

# Add env
ENV LANG C.UTF-8

# Setup base
RUN apk add --no-cache jq certbot py2-future python python-dev py-pip build-base libffi-dev openssl-dev \
    && pip install --upgrade pip \
    && pip install certbot-dns-google

# Copy data
COPY run.sh /

CMD [ "/run.sh" ]
