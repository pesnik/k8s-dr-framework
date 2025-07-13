FROM postgres:13-alpine

RUN apk add --no-cache \
    mysql-client \
    mongodb-tools \
    aws-cli \
    curl \
    jq \
    bash

COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
