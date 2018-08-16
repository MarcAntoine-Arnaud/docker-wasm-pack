FROM debian:stretch

MAINTAINER Marc-Antoine Arnaud <maarnaud@media-io.com>

WORKDIR /sources

# common packages
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    ca-certificates curl file \
    build-essential \
    autoconf automake autotools-dev libtool xutils-dev && \
    rm -rf /var/lib/apt/lists/*

ENV SSL_VERSION=1.0.2o

RUN curl https://www.openssl.org/source/openssl-$SSL_VERSION.tar.gz -O && \
    tar -xzf openssl-$SSL_VERSION.tar.gz && \
    cd openssl-$SSL_VERSION && ./config && make depend && make install && \
    cd .. && rm -rf openssl-$SSL_VERSION*

ENV OPENSSL_LIB_DIR=/usr/local/ssl/lib \
    OPENSSL_INCLUDE_DIR=/usr/local/ssl/include \
    OPENSSL_STATIC=1

RUN curl https://sh.rustup.rs -sSf | sh && \
    source $HOME/.cargo/env && \
    rustup install nightly && \
    rustup override set nightly && \
    rustup target add asmjs-unknown-emscripten --toolchain nightly && \
    rustup target add wasm32-unknown-emscripten --toolchain nightly && \
    cargo install wasm-pack

CMD wasm-pack init
