ARG UBUNTU_VERSION=20.04
FROM ubuntu:${UBUNTU_VERSION}
ENV DEBIAN_FRONTEND=nonintercative

# development dependencies
RUN apt-get update -y && apt-get install -y \
  automake \
  build-essential \
  g++\
  git \
  jq \
  libicu-dev \
  libffi-dev \
  libgmp-dev \
  liblzma-dev \
  libncursesw5 \
  libpq-dev \
  libssl-dev \
  libsystemd-dev \
  libtinfo-dev \
  libtool \
  make \
  pkg-config \
  tmux \
  wget \
  zlib1g-dev libreadline-dev  libnuma-dev \
  &&  if test  "$(arch)" = 'x86_64'; then  apt-get  install -y  llvm; fi &&  rm -rf /var/lib/apt/lists/*

ARG IOHK_LIBSODIUM_GIT_REV=66f017f16633f2060db25e17c170c2afa0f2a8a1
ARG IOKH_LIBSECP251_GIT_REV=ac83be33d0956faf6b7f61a60ab524ef7d6a473a

# install secp2561k library with prefix '/usr'
RUN git clone https://github.com/bitcoin-core/secp256k1 &&\
  cd secp256k1 \
  && git fetch --all --tags &&\
  git checkout ${IOKH_LIBSECP251_GIT_REV} \
  && ./autogen.sh && \
  ./configure --prefix=/usr --enable-module-schnorrsig --enable-experimental && \
  make && \
  make install  && cd .. && rm -rf ./secp256k1

# install libsodium from sources with prefix '/usr'
RUN git clone https://github.com/input-output-hk/libsodium.git &&\
  cd libsodium \
  && git fetch --all --tags &&\
  git checkout ${IOHK_LIBSODIUM_GIT_REV} \
  && ./autogen.sh && \
  ./configure --prefix=/usr && \
  make && \
  make install  && cd .. && rm -rf ./libsodium

# We create home folder for non-root user.
RUN useradd -u 1001 -U  -d /haskell -m  haskell && mkdir -p /app && chown haskell:haskell /app
WORKDIR /haskell

USER  haskell
# install ghcup

ARG CABAL_VERSION=3.6.2.0
ARG GHC_VERSION=8.10.7
ENV PATH=${PATH}:${HOME:-/haskell}/.ghcup/bin
RUN wget --secure-protocol=TLSv1_2 \
  https://downloads.haskell.org/~ghcup/$(arch)-linux-ghcup  \ 
  && chmod +x $(arch)-linux-ghcup \
  && mkdir -p ${HOME:-/haskell}/.ghcup/bin \
  && mv $(arch)-linux-ghcup ${HOME:-/haskell}/.ghcup/bin/ghcup 

RUN ghcup config set downloader Wget \
  &&  ghcup install ghc ${GHC_VERSION} \
  &&  ghcup install cabal ${CABAL_VERSION} \
  && ghcup set ghc ${GHC_VERSION}