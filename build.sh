#!/bin/bash

set -x

cd /root

# DEBUG


git clone -b "$GOST_ENGINE_GIT_BRANCH" "$GOST_ENGINE_GIT_REPO" engine
cd engine
git submodule update --init

GOST_ENGINE_GIT_COMMIT_HASH_SHORT="$(git log -1 --format=%h)"
GOST_ENGINE_GIT_COMMIT_DATE="$(git log -1 --format=%cd --date=format:%F)"
PKG_VERSION="${GOST_ENGINE_GIT_COMMIT_DATE}-${GOST_ENGINE_GIT_COMMIT_HASH_SHORT}"

LIBSSL_PACKAGE="$(apt-cache depends openssl | grep libssl | tr -s ' ' | cut -d' ' -f3)"

mkdir build
cd build

# xargs to remove quotes while keeping spaces if necessary
OPENSSL_ENGINES_DIR="$(openssl version -e | cut -d' ' -f2 | xargs echo)"

cmake -DCMAKE_BUILD_TYPE=Release -DOPENSSL_ENGINES_DIR="${OPENSSL_ENGINES_DIR}" ..
cmake --build . --config Release

# chechinstall fails to include lib symlink automatically
# checkinstall additional file list - should be used without heading /
echo "${OPENSSL_ENGINES_DIR}/gost.so" | sed 's/^\///' > checkinstall_include_files.txt

checkinstall \
--include=checkinstall_include_files.txt \
--pkgname=openssl-gost-engine \
--pkgversion="${PKG_VERSION}" \
--requires="${LIBSSL_PACKAGE}" \
--install=no \
--default \

# copy the package to the external volume
cp -f *.deb /opt
