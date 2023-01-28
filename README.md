Docker image to build Ubuntu/Debian package for [OpenSSL GOST engine](https://github.com/gost-engine/engine).

Build arguments:

* `BASE_IMAGE`    distributive version to build the package for, like `ubuntu:focal`
* `GOST_ENGINE_GIT_BRANCH`    choose git branch accorging to openssl version in the distributive, for example: `openssl_1_1_1` for OpenSSL v1.1.1. See the link above
* `GOST_ENGINE_GIT_REPO`  choose another OpenSSL GOST engine git repo location

```shell
docker build --tag=openssl-gost-engine-builder --build-arg BASE_IMAGE="ubuntu:focal" --build-arg GOST_ENGINE_GIT_BRANCH="openssl_1_1_1" .

docker run --rm -it -v "$(readlink -f .)":/opt openssl-gost-engine-builder

# Result:
# openssl-gost-engine_2022-05-20-739f957-1_amd64.deb
```

Don't forget to configure OpenSSL to use GOST engine: [how-to](https://github.com/gost-engine/engine/blob/master/INSTALL.md#how-to-configure).

## Docs

* https://www.altlinux.org/OSS-GOST-Crypto (in Russian)
