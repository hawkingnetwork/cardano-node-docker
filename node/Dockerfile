FROM debian:stable-slim
LABEL name="cardano-node"
LABEL maintainer="https://github.com/hawkingnetwork"

ARG GHCUP_VERSION=0.1.14
ARG GHC_VERSION=8.10.4
ARG CABAL_VERSION=3.4.0.0

ENV PATH=/root/.cabal/bin:/root/.ghcup/bin:$PATH
ENV DEBIAN_FRONTEND=noninteractive

RUN echo "export PATH=/root/.cabal/bin:/root/.ghcup/bin:$PATH" >> /root/.bashrc

# Install build dependencies
RUN apt-get update -y \
    && apt-get install -y automake \
    build-essential \
    apt-utils \
    pkg-config \
    libffi-dev \
    libgmp-dev \
    libssl-dev \
    libtinfo-dev \
    libsystemd-dev \
    zlib1g-dev \
    make \
    g++ \
    tmux \
    git \
    jq \
    wget \
    libncursesw5 \
    libtool \
    autoconf \
    libsqlite3-dev \
    m4 \
    ca-certificates \
    gcc \
    libc6-dev \
    && apt-get clean

WORKDIR /root

# Install GHC Haskell compiler
RUN wget -O ghcup https://downloads.haskell.org/~ghcup/${GHCUP_VERSION}/x86_64-linux-ghcup-${GHCUP_VERSION} && chmod 500 ghcup
RUN ./ghcup -v --downloader wget install ghc ${GHC_VERSION} && ./ghcup set ghc ${GHC_VERSION}

# Install cabal 
RUN ./ghcup -v --downloader wget install cabal ${CABAL_VERSION}

# Install Cardano Libsodium dependencies
RUN git clone https://github.com/input-output-hk/libsodium
RUN cd libsodium && git checkout 66f017f1 && ./autogen.sh && ./configure && make && make install
RUN rm -rf libsodium

ENV LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH"
ENV PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH"


ARG RELEASE=1.25.1
# Download cardano-node repository
RUN git clone https://github.com/input-output-hk/cardano-node.git
WORKDIR /root/cardano-node
RUN git fetch --all --recurse-submodules --tags
RUN git tag
RUN git checkout tags/${RELEASE}

# Add cabal config files
RUN echo "package cardano-crypto-praos" >>  cabal.project.local
RUN echo "  flags: -external-libsodium-vrf" >>  cabal.project.local

# # Build cardano-node binary
RUN cabal update
RUN cabal user-config update
RUN cabal build all

# Create files structure
RUN mkdir -p /cardano/configs /cardano/bin /cardano/db /cardano/socket /cardano/scripts
RUN cp -p dist-newstyle/build/x86_64-linux/ghc-${GHC_VERSION}/cardano-node-${RELEASE}/x/cardano-node/build/cardano-node/cardano-node /cardano/bin
RUN cp -p dist-newstyle/build/x86_64-linux/ghc-${GHC_VERSION}/cardano-cli-${RELEASE}/x/cardano-cli/build/cardano-cli/cardano-cli /cardano/bin

RUN rm -rf /root/cardano-node

# Add startup scripts
COPY scripts/start-relay.sh /cardano/scripts/start-relay.sh
COPY scripts/start-producer.sh /cardano/scripts/start-producer.sh
COPY scripts/start-with-topology.sh /cardano/scripts/start-with-topology.sh

# Install topologyUpdater script
COPY scripts/topologyUpdater.sh /cardano/scripts/topologyUpdater.sh

# Creating non root user cardano
RUN useradd -m cardano

# # Add permissions
RUN chown -R cardano:cardano /cardano
RUN chmod g+s /cardano
RUN chmod 540 /cardano/scripts/*
RUN chmod 540 /cardano/bin/*

ENV PATH=/cardano/scripts:/cardano/bin:$PATH
ENV CARDANO_NODE_SOCKET_PATH=/cardano/socket/node.socket

VOLUME ["/cardano/db"]

WORKDIR /root

# Image clean-up
RUN cabal clean
RUN apt-get autoremove -y
RUN apt-get clean
RUN apt-get autoclean

# Switch user
USER cardano:cardano
WORKDIR /cardano

# Expose ports
## cardano-node, EKG, Prometheus
EXPOSE 3000 12788 12798

CMD ["start-relay.sh"]