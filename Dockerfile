FROM ubuntu:jammy as builder

RUN set -eux \
    && apt update \
    && apt install -y git build-essential libssl-dev zlib1g-dev

RUN mkdir proxy
ADD . proxy/
RUN ls -lah proxy/
RUN cd proxy/MTProxy \
    && make

FROM ubuntu:jammy
RUN mkdir /data
RUN mkdir /etc/telegram
COPY --from=builder proxy/MTProxy/objs/bin/mtproto-proxy /usr/local/bin/mtproto-proxy
RUN set -eux \
    && apt-get update \
    && apt-get install -y --no-install-recommends iproute2 curl ca-certificates \
    && rm -rf /var/lib/apt/lists/* ;
COPY --from=builder proxy/run.sh /run.sh
ENTRYPOINT ["/run.sh"]
