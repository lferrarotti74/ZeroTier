# vim: ft=dockerfile

FROM alpine:3 AS stage

ARG TARGETARCH
ARG TARGETVARIANT
ARG TARGETPLATFORM

# Define an optional build argument to invalidate cache
ARG CACHEBUST=1

ARG VERSION=1.12.0 # Default value provided

# Common packages for all architectures
RUN echo "Cache invalidation: ${CACHEBUST}" \
&& echo "Building for platform: ${TARGETPLATFORM}, arch: ${TARGETARCH}, variant: ${TARGETVARIANT}" \
&& apk --no-cache update && apk --no-cache upgrade \
&& apk --no-cache --update add alpine-sdk clang curl git linux-headers make openssl-dev pkgconfig \
&& rm -rf /var/cache/apk/*

# Architecture-specific setup with enhanced platform support
RUN if [ "$TARGETARCH" = "arm64" ] || [ "$TARGETARCH" = "arm" ]; then \
        # For ARM architectures, use the package manager
        echo "Setting up ARM architecture ($TARGETARCH)" && \
        apk --no-cache add rust cargo; \
    elif [ "$TARGETARCH" = "386" ]; then \
        # For i386 (32-bit x86), use Alpine packages for better compatibility
        echo "Setting up i386 (32-bit x86) architecture" && \
        apk --no-cache add rust cargo; \
    elif [ "$TARGETARCH" = "riscv64" ]; then \
        # For RISC-V, use Alpine packages (rustup doesn't support musl properly)
        echo "Setting up RISC-V 64-bit architecture" && \
        apk --no-cache add rust cargo; \
    elif [ "$TARGETARCH" = "ppc64le" ]; then \
        # For PowerPC 64-bit Little Endian, use Alpine packages as fallback
        echo "Setting up PowerPC 64-bit Little Endian architecture" && \
        apk --no-cache add rust cargo; \
    elif [ "$TARGETARCH" = "s390x" ]; then \
        # For IBM System z, use Alpine packages as fallback
        echo "Setting up IBM System z (s390x) architecture" && \
        apk --no-cache add rust cargo; \
    else \
        # For AMD64 (including variants v2, v3, v4), use rustup
        echo "Setting up AMD64 architecture (variant: ${TARGETVARIANT:-v1})" && \
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y \
        && . "$HOME/.cargo/env"; \
    fi \
    && git clone -b ${VERSION} --depth 1 https://github.com/zerotier/ZeroTierOne.git

# Set environment variables for specific architectures to prevent build issues
RUN if [ "$TARGETARCH" = "arm64" ] || [ "$TARGETARCH" = "arm" ]; then \
        # ARM-specific optimizations (using Alpine packages)
        echo "export CARGO_PROFILE_RELEASE_LTO=false" >> /etc/profile.d/cargo.sh && \
        echo "export CARGO_PROFILE_RELEASE_CODEGEN_UNITS=1" >> /etc/profile.d/cargo.sh && \
        echo "export OPENSSL_NO_VENDOR=1" >> /etc/profile.d/cargo.sh; \
    elif [ "$TARGETARCH" = "386" ]; then \
        # i386-specific optimizations (using Alpine packages, reduced resources)
        echo "export CARGO_PROFILE_RELEASE_LTO=false" >> /etc/profile.d/cargo.sh && \
        echo "export CARGO_PROFILE_RELEASE_CODEGEN_UNITS=1" >> /etc/profile.d/cargo.sh && \
        echo "export OPENSSL_NO_VENDOR=1" >> /etc/profile.d/cargo.sh && \
        echo "export CC=clang" >> /etc/profile.d/cargo.sh && \
        echo "export CXX=clang++" >> /etc/profile.d/cargo.sh; \
    elif [ "$TARGETARCH" = "riscv64" ] || [ "$TARGETARCH" = "ppc64le" ] || [ "$TARGETARCH" = "s390x" ]; then \
        # RISC-V, PowerPC, and s390x optimizations (using Alpine packages)
        echo "export CARGO_PROFILE_RELEASE_LTO=thin" >> /etc/profile.d/cargo.sh && \
        echo "export CARGO_PROFILE_RELEASE_CODEGEN_UNITS=4" >> /etc/profile.d/cargo.sh && \
        echo "export OPENSSL_NO_VENDOR=1" >> /etc/profile.d/cargo.sh && \
        echo "export CC=clang" >> /etc/profile.d/cargo.sh && \
        echo "export CXX=clang++" >> /etc/profile.d/cargo.sh; \
    fi

WORKDIR /ZeroTierOne

# Architecture-specific build commands with enhanced platform support
RUN if [ "$TARGETARCH" = "arm64" ] || [ "$TARGETARCH" = "arm" ]; then \
        # ARM builds with reduced parallelism to prevent memory issues
        . /etc/profile.d/cargo.sh 2>/dev/null || true && \
        export CARGO_PROFILE_RELEASE_LTO=false && \
        export CARGO_PROFILE_RELEASE_CODEGEN_UNITS=1 && \
        export OPENSSL_NO_VENDOR=1 && \
        echo "Building for ARM ($TARGETARCH) with reduced parallelism..." && \
        (/usr/bin/make -j2 || /usr/bin/make -j1); \
    elif [ "$TARGETARCH" = "386" ]; then \
        # i386 builds with minimal parallelism due to 32-bit memory constraints
        . /etc/profile.d/cargo.sh 2>/dev/null || true && \
        export CARGO_PROFILE_RELEASE_LTO=false && \
        export CARGO_PROFILE_RELEASE_CODEGEN_UNITS=1 && \
        export OPENSSL_NO_VENDOR=1 && \
        export CC=clang && \
        export CXX=clang++ && \
        echo "Building for i386 (32-bit x86) with minimal parallelism..." && \
        /usr/bin/make -j1; \
    elif [ "$TARGETARCH" = "riscv64" ] || [ "$TARGETARCH" = "ppc64le" ] || [ "$TARGETARCH" = "s390x" ]; then \
        # Exotic architectures using Alpine packages (no rustup env to source)
        . /etc/profile.d/cargo.sh 2>/dev/null || true && \
        export CARGO_PROFILE_RELEASE_LTO=thin && \
        export CARGO_PROFILE_RELEASE_CODEGEN_UNITS=4 && \
        export OPENSSL_NO_VENDOR=1 && \
        export CC=clang && \
        export CXX=clang++ && \
        echo "Building for $TARGETARCH with optimized settings..." && \
        (/usr/bin/make -j2 || /usr/bin/make -j1); \
    else \
        # AMD64 builds (including v2, v3, v4 variants) with full parallelism
        . "$HOME/.cargo/env" 2>/dev/null || true && \
        echo "Building for AMD64 (variant: ${TARGETVARIANT:-v1}) with full parallelism..." && \
        if [ "$TARGETVARIANT" = "v2" ] || [ "$TARGETVARIANT" = "v3" ] || [ "$TARGETVARIANT" = "v4" ]; then \
            # Enhanced optimizations for newer AMD64 variants
            export CFLAGS="-march=x86-64-${TARGETVARIANT} -mtune=generic" && \
            export CXXFLAGS="-march=x86-64-${TARGETVARIANT} -mtune=generic"; \
        fi && \
        /usr/bin/make -j$(nproc); \
    fi

FROM alpine:3

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
    ln -sf /usr/sbin/zerotier-one /usr/sbin/zerotier-cli && \
    echo "${VERSION}" > /etc/zerotier-version \
    && rm -rf /var/lib/zerotier-one \
    && echo "Cache invalidation: ${CACHEBUST}" \
    && apk --no-cache update && apk --no-cache upgrade \
    && apk --no-cache --update add \
    curl \
    fping \
    iproute2 \
    iputils-arping \
    iputils-ping \
    jq \
    libgcc \
    libssl3 \
    libstdc++ \
    net-tools \
    netcat-openbsd \
    openssl \
    sudo \
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
