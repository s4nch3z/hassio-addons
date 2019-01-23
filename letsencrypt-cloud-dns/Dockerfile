ARG BUILD_FROM
FROM $BUILD_FROM

# Add env
ENV LANG C.UTF-8

# Setup base
RUN apk add --no-cache jq certbot py2-future
RUN pip install certbot-dns-google

# Copy data
COPY run.sh /

CMD [ "/run.sh" ]
