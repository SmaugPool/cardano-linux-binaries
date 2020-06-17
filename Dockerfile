# Use Alpine 3.11 with GHC 8.6.5
FROM alpine:3.11

# Cardano release tag
ARG tag=1.13.0-rewards

# Install required packages
RUN apk add --no-cache git ghc cabal wget musl-dev zlib-dev zlib-static ncurses-dev ncurses-static

# Remove once https://github.com/input-output-hk/cardano-node/issues/1200 is fixed
RUN apk add --no-cache elogind-dev

# Clone cardano-node
RUN git clone -q -b $tag --depth 1 https://github.com/input-output-hk/cardano-node.git

WORKDIR /cardano-node

# Build statically linked binaries
RUN cabal new-update
RUN cabal new-build --ghc-option=-optl=-static --ghc-option=-split-sections --flags="-systemd" cardano-node cardano-cli
RUN cp ./dist-newstyle/build/x86_64-linux/ghc-*/cardano-node-*/x/cardano-node/build/cardano-node/cardano-node /usr/local/bin/
RUN cp ./dist-newstyle/build/x86_64-linux/ghc-*/cardano-cli-*/x/cardano-cli/build/cardano-cli/cardano-cli /usr/local/bin/

# Remove debug symbols to optimize the binaries size
RUN strip -s /usr/local/bin/cardano-node
RUN strip -s /usr/local/bin/cardano-cli
