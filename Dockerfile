# vim: ft=dockerfile

FROM alpine:latest AS stage

ARG TARGETARCH

# Define an optional build argument to invalidate cache
ARG CACHEBUST=1

ARG VERSION=1.12.0 # Default value provided

# Common packages for all architectures
RUN echo "Cache invalidation: ${CACHEBUST}" \
&& apk --no-cache update && apk --no-cache upgrade \
&& apk --no-cache --update add alpine-sdk linux-headers openssl-dev make clang curl pkgconfig git \
&& rm -rf /var/cache/apk/*

# Architecture-specific setup
RUN if [ "$TARGETARCH" = "arm64" ] || [ "$TARGETARCH" = "arm" ]; then \
        # For ARM architectures, use the package manager
        apk --no-cache add rust cargo; \
    else \
        # For AMD64, use rustup
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y \
        && . "$HOME/.cargo/env"; \
    fi \
    && git clone -b ${VERSION} --depth 1 https://github.com/zerotier/ZeroTierOne.git

# Set environment variables for ARM builds to prevent linker crashes
# Use ENV instead of export to make them persistent across RUN instructions
RUN if [ "$TARGETARCH" = "arm64" ] || [ "$TARGETARCH" = "arm" ]; then \
        echo "export CARGO_PROFILE_RELEASE_LTO=false" >> /etc/profile.d/cargo.sh && \
        echo "export CARGO_PROFILE_RELEASE_CODEGEN_UNITS=1" >> /etc/profile.d/cargo.sh && \
        echo "export OPENSSL_NO_VENDOR=1" >> /etc/profile.d/cargo.sh; \
    fi

WORKDIR /ZeroTierOne

# Architecture-specific build commands
RUN if [ "$TARGETARCH" = "arm64" ] || [ "$TARGETARCH" = "arm" ]; then \
        # Source the environment variables and build for ARM
        . /etc/profile.d/cargo.sh 2>/dev/null || true && \
        export CARGO_PROFILE_RELEASE_LTO=false && \
        export CARGO_PROFILE_RELEASE_CODEGEN_UNITS=1 && \
        export OPENSSL_NO_VENDOR=1 && \
        echo "Building for ARM with reduced parallelism..." && \
        (/usr/bin/make -j2 || /usr/bin/make -j1); \
    else \
        # For AMD64: Use full parallelism
        echo "Building for AMD64 with full parallelism..." && \
        /usr/bin/make -j$(nproc); \
    fi

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
    && echo "Cache invalidation: ${CACHEBUST}" \
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
