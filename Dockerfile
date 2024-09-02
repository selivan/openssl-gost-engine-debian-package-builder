ARG BASE_IMAGE="ubuntu:24.04"

FROM ${BASE_IMAGE}

ARG GOST_ENGINE_GIT_BRANCH="master"
ARG GOST_ENGINE_GIT_REPO="https://github.com/gost-engine/engine"
ARG CMAKE_REQUIRED_VERSION
ARG INSTALL_PREFIX=/usr/local

ENV GOST_ENGINE_GIT_BRANCH=${GOST_ENGINE_GIT_BRANCH}
ENV GOST_ENGINE_GIT_REPO=${GOST_ENGINE_GIT_REPO}
ENV CMAKE_REQUIRED_VERSION="${CMAKE_REQUIRED_VERSION}"
ENV INSTALL_PREFIX=${INSTALL_PREFIX}

# cmake in dist repositories may be too old
# get fresh one from pip - strangely, it's the most simple way
RUN apt update && \
    apt dist-upgrade --yes && \
    DEBIAN_FRONTEND=noninteractive TZ='Etc/UTC' apt install --yes -o DPkg::Options::=--force-confdef git openssl libssl-dev libc6-dev libtest2-suite-perl checkinstall python3-minimal python3-pip

VOLUME [ "/opt" ]

COPY build.sh /root/

RUN chmod a+rx /root/build.sh

ENTRYPOINT ["/root/build.sh"]
