# vim: ft=dockerfile

FROM alpine:latest AS stage

ARG TARGETARCH

# Define an optional build argument to invalidate cache
ARG CACHEBUST=1

ARG VERSION=1.12.0 # Default value provided

# Common packages for all architectures
RUN apk --no-cache update && apk --no-cache upgrade \
&& apk --no-cache --update add alpine-sdk linux-headers openssl-dev make clang curl pkgconfig git \
&& rm -rf /var/cache/apk/*

# Architecture-specific setup
RUN if [ "$TARGETARCH" = "arm64" ] || [ "$TARGETARCH" = "arm" ]; then \
        # For ARM architectures, use the package manager
        apk --no-cache add rust cargo; \
    else \
        # For AMD64 and ARM64, use rustup
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y \
        && . "$HOME/.cargo/env"; \
    fi \
    && git clone -b ${VERSION} --depth 1 https://github.com/zerotier/ZeroTierOne.git

WORKDIR /ZeroTierOne
RUN /usr/bin/make -j$(nproc)

FROM alpine:latest

# Define an optional build argument to invalidate cache
ARG CACHEBUST=1

ARG VERSION=1.12.0 # Default value provided

LABEL org.opencontainers.image.title="zerotier"
LABEL org.opencontainers.image.version="${VERSION}"
LABEL org.opencontainers.image.description="ZeroTier One as Docker Image"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.source="https://github.com/lferrarotti74/ZeroTierOne"

COPY --from=stage /ZeroTierOne/zerotier-one /usr/sbin
RUN ln -sf /usr/sbin/zerotier-one /usr/sbin/zerotier-idtool && \
    ln -sf /usr/sbin/zerotier-one /usr/sbin/zerotier-cli

RUN echo "${VERSION}" > /etc/zerotier-version \
    && rm -rf /var/lib/zerotier-one \
    && apk --no-cache update && apk --no-cache upgrade \
    && apk --no-cache --update add iproute2 net-tools fping iputils-ping iputils-arping curl openssl libssl3 jq netcat-openbsd libstdc++ libgcc sudo \
    && rm -rf /var/cache/apk/* \
    && addgroup -S zerotier && adduser -S zerotier -G zerotier -h /var/lib/zerotier-one -g "zerotier" \
    && echo "export HISTFILE=/dev/null" >> /etc/profile

COPY scripts/entrypoint.sh /entrypoint.sh
COPY scripts/healthcheck.sh /healthcheck.sh
RUN chmod 755 /entrypoint.sh ; chmod 755 /healthcheck.sh ; echo "zerotier ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers

# Define a custom healthcheck command
HEALTHCHECK --interval=60s --timeout=5s --retries=3 CMD [ "/healthcheck.sh" ]

EXPOSE 9993/udp
USER zerotier

# Start the entrypoint script for the container image
ENTRYPOINT ["/entrypoint.sh"]

CMD []
