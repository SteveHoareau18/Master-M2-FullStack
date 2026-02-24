FROM postgres:15.6-alpine3.19

RUN apk update && \
    apk upgrade --no-cache && \
    rm -rf /var/cache/apk/*