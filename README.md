## Description

Docker image to easily build Ubuntu/Debian package for [OpenSSL GOST engine](https://github.com/gost-engine/engine).

## Arguments

* `BASE_IMAGE`    distributive version to build the package for, like:  `ubuntu:20.04`, `ubuntu:24.04`
* `GOST_ENGINE_GIT_BRANCH`    choose git branch accorging to openssl version in the distributive, for example: `openssl_1_1_1` for OpenSSL v1.1.1. See the link above
* `GOST_ENGINE_GIT_REPO`  git repo of GOST engine for OpenSSL
* `CMAKE_REQUIRED_VERSION` set specific cmake version for build. If not set, script will try to determine it automatically
* `INSTALL_PREFIX`  install prefix for binaries like `gostsum`

## Usage

```shell
docker build --tag=openssl-gost-engine-builder \
--build-arg BASE_IMAGE="ubuntu:24.04" \
--build-arg GOST_ENGINE_GIT_BRANCH="master" \
.

docker run --rm -it -v "$(readlink -f .)":/opt openssl-gost-engine-builder

# Result:
# openssl-gost-engine_2024-03-22-git-ede3886-1_amd64.deb
```

Don't forget to configure OpenSSL to use GOST engine: [how-to](https://github.com/gost-engine/engine/blob/master/INSTALL.md#how-to-configure).

## Example OpenSSL configuration for GOST engine

```bash
cat > /etc/ssl/openssl-gost.cnf <<EOF
HOME                    = .
openssl_conf = openssl_def
[openssl_def]
engines = engine_section
[engine_section]
gost = gost_section
[gost_section]
engine_id = gost
dynamic_path = /usr/lib/x86_64-linux-gnu/engines-3/gost.so
default_algorithms = ALL
CRYPT_PARAMS = id-Gost28147-89-CryptoPro-A-ParamSet
EOF

OPENSSL_CONF=/etc/ssl/openssl-gost.cnf openssl ciphers | tr ':' '\n' | grep -i gost
# Result:
# GOST2012-MAGMA-MAGMAOMAC
# GOST2012-KUZNYECHIK-KUZNYECHIKOMAC
# LEGACY-GOST2012-GOST8912-GOST8912
# IANA-GOST2012-GOST8912-GOST8912
# GOST2001-GOST89-GOST89
```

## Docs

* https://www.altlinux.org/OSS-GOST-Crypto (in Russian)
