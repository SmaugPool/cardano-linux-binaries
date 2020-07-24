# Use Alpine 3.11 with GHC 8.6.5
FROM alpine:3.11

# Cardano release tag or branch
ARG tag=1.17.0

# Install required packages
RUN apk add --no-cache git ghc cabal wget musl-dev zlib-dev zlib-static ncurses-dev ncurses-static

# For libsodium
RUN apk add --no-cache curl file make autoconf automake libtool

# Remove once https://github.com/input-output-hk/cardano-node/issues/1200 is fixed
RUN apk add --no-cache elogind-dev


# Build libsodium
RUN git clone -q -b tdammers/rebased-vrf --depth 1 https://github.com/input-output-hk/libsodium.git /libsodium
WORKDIR /libsodium
RUN git checkout 66f017f1
RUN ./autogen.sh && ./configure --disable-dependency-tracking && make && make install

# Clone cardano-node
RUN git clone -q -b $tag --depth 1 https://github.com/input-output-hk/cardano-node.git /cardano
WORKDIR /cardano

# Build statically linked binaries
RUN cabal new-update
RUN cabal new-build --ghc-option=-optl=-static --ghc-option=-split-sections --flags="-systemd" cardano-node:exe:cardano-node cardano-cli:exe:cardano-cli
RUN cp ./dist-newstyle/build/x86_64-linux/ghc-*/cardano-node-*/x/cardano-node/build/cardano-node/cardano-node /usr/local/bin/
RUN cp ./dist-newstyle/build/x86_64-linux/ghc-*/cardano-cli-*/x/cardano-cli/build/cardano-cli/cardano-cli /usr/local/bin/

# Remove debug symbols to optimize the binaries size
RUN strip -s /usr/local/bin/cardano-node
RUN strip -s /usr/local/bin/cardano-cli
