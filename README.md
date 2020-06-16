# Cardano Linux Binaries

Linux 64-bit binaries of
[`cardano-node`](https://github.com/input-output-hk/cardano-node)
and `cardano-cli` statically linked to [`musl`](https://musl.libc.org/)
libc to be able to run on any x86-64 Linux distribution, without any
dependency.

The current [configuration from IOHK](https://hydra.iohk.io/job/Cardano/cardano-node/cardano-deployment/latest-finished/download/1)
is bundled too to offer a ready to run edge node that can be converted to a relay
or block producer node with the appropriate configuration.

## Install
```bash
mkdir cardano
cd cardano

curl -L https:/github.com/smaug-group/cardano-linux-binaries/releases/latest/download/cardano.tar.gz | tar xz
```

See [Releases](https://github.com/smaug-group/cardano-linux-binaries/releases) for previous releases.

## Run node
```bash
./run
```
The node will run on port 3000.

For more information, see
[Shelley Testnet](https://testnets.cardano.org/en/shelley/get-started/configuring-a-node-using-yaml/),  [Links](https://testnets.cardano.org/en/shelley/resources/links/) and [Tutorials](https://github.com/input-output-hk/cardano-tutorials).

## Run CLI
```bash
export CARDANO_NODE_SOCKET_PATH=`pwd`/socket
bin/cardano-cli
```
To enable bash auto-completion:
```bash
source <(bin/cardano-cli --bash-completion-script cardano-cli)
```

## Notes
* `LiveView` and logs are enabled by default in the node config.
* `cardano-node` is currently built without specific `systemd` support.
* Binaries are built and released automatically by a Travis-CI job on new tags.
Check the tag Travis-CI log to verify the build and the binaries SHA1 computed
at the end.
* Binaries are built using Docker and Alpine Linux, you can also copy the
`Dockerfile` and rebuild yourself the statically linked binaries.
