# vim: ft=dockerfile

FROM debian:trixie-backports as stage

ARG VERSION=1.12.0 //Default value provided

RUN apt-get update -qq && apt-get upgrade -qq && apt-get -qq install make clang curl pkg-config libssl-dev git -y \
&& curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y \
&& . "$HOME/.cargo/env" \
&& git clone -b ${VERSION} --depth 1 https://github.com/zerotier/ZeroTierOne.git
WORKDIR /ZeroTierOne
RUN /usr/bin/make -j$(nproc)

FROM debian:trixie-backports

ARG VERSION=1.12.0 //Default value provided

COPY --from=stage /ZeroTierOne/zerotier-one /usr/sbin
RUN ln -sf /usr/sbin/zerotier-one /usr/sbin/zerotier-idtool
RUN ln -sf /usr/sbin/zerotier-one /usr/sbin/zerotier-cli

RUN echo "${VERSION}" > /etc/zerotier-version \
    && rm -rf /var/lib/zerotier-one \
    && apt-get -qq update && apt-get upgrade -qq \
    && apt-get -qq install iproute2 net-tools fping 2ping iputils-ping iputils-arping curl openssl libssl3t64 jq netcat-openbsd -y

COPY scripts/entrypoint.sh /entrypoint.sh
COPY scripts/healthcheck.sh /healthcheck.sh
RUN chmod 755 /entrypoint.sh
RUN chmod 755 /healthcheck.sh

# Define a custom healthcheck command
HEALTHCHECK --interval=60s --timeout=5s --retries=3 CMD [ "/healthcheck.sh" ]

CMD []
ENTRYPOINT ["/entrypoint.sh"]