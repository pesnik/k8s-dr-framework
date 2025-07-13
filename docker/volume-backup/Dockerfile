FROM alpine:3.18

RUN apk add --no-cache \
    kubectl \
    curl \
    jq \
    bash \
    tar \
    gzip \
    rsync

COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
