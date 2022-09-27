FROM --platform=linux/arm64/v8 redis:6.2-buster as redis-builder

FROM --platform=linux/arm64/v8 bluewalletorganization/lndhub:v1.4.1

USER root

RUN apt-get update && apt-get install -y tini wget bash curl
RUN wget https://github.com/mikefarah/yq/releases/download/v4.6.3/yq_linux_arm.tar.gz -O - |\
  tar xz && mv yq_linux_arm /usr/bin/yq

COPY --from=redis-builder /data /data
COPY --from=redis-builder /usr/local/bin/redis-server /usr/local/bin/redis-server

ADD docker_entrypoint.sh /usr/local/bin/docker_entrypoint.sh
RUN chmod a+x /usr/local/bin/docker_entrypoint.sh

WORKDIR /lndhub/
