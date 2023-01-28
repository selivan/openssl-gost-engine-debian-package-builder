ARG BASE_IMAGE="ubuntu:focal"

FROM ${BASE_IMAGE}

ARG GOST_ENGINE_GIT_BRANCH="openssl_1_1_1"
ARG GOST_ENGINE_GIT_REPO=https://github.com/gost-engine/engine

ENV GOST_ENGINE_GIT_BRANCH=${GOST_ENGINE_GIT_BRANCH}
ENV GOST_ENGINE_GIT_REPO=${GOST_ENGINE_GIT_REPO}

# cmake in dist repositories may be too old
# get fresh one from pip - strangely, it's the most simple way
RUN apt update && \
    apt dist-upgrade --yes && \
    DEBIAN_FRONTEND=noninteractive apt install --yes -o DPkg::Options::=--force-confdef git openssl libssl-dev checkinstall python3-minimal python3-pip && \
    pip install cmake

VOLUME [ "/opt" ]

COPY build.sh /root/

RUN chmod a+rx /root/build.sh 

ENTRYPOINT ["/root/build.sh"]
