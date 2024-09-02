#!/bin/bash

set -x

DEBIAN_FRONTEND=noninteractive apt dist-upgrade --yes

cd /root

git clone -b "$GOST_ENGINE_GIT_BRANCH" "$GOST_ENGINE_GIT_REPO" engine
cd engine
git submodule update --init

GOST_ENGINE_GIT_COMMIT_HASH_SHORT="$(git log -1 --format=%h)"
GOST_ENGINE_GIT_COMMIT_DATE="$(git log -1 --format=%cd --date=format:%F)"
PKG_VERSION="${GOST_ENGINE_GIT_COMMIT_DATE}-git-${GOST_ENGINE_GIT_COMMIT_HASH_SHORT}"

LIBSSL_PACKAGE="$(apt-cache depends openssl | grep libssl | tr -s ' ' | cut -d' ' -f3)"

# Try to determine required cmake version if not set
if [ -z "$CMAKE_REQUIRED_VERSION" ]; then
	CMAKE_REQUIRED_VERSION=$(cat CMakeLists.txt | grep ^cmake_minimum_required | cut -d' ' -f2)
fi

pip install --break-system-packages cmake=="$CMAKE_REQUIRED_VERSION"

# xargs to remove quotes while keeping spaces if necessary
OPENSSL_ENGINES_DIR="$(openssl version -e | cut -d' ' -f2 | xargs echo)"

mkdir build
cd build

cmake -DCMAKE_INSTALL_PREFIX="${INSTALL_PREFIX}" -DCMAKE_BUILD_TYPE=Release -DOPENSSL_ENGINES_DIR="${OPENSSL_ENGINES_DIR}" ..
cmake --build . --config Release

# chechinstall sometimes fails to include lib symlink automatically
# checkinstall additional file list - should be used without heading /
echo "${OPENSSL_ENGINES_DIR}/gost.so" | sed 's/^\///' > checkinstall_include_files.txt

checkinstall \
--include=checkinstall_include_files.txt \
--pkgname=openssl-gost-engine \
--pkgversion="${PKG_VERSION}" \
--pkgsource="${GOST_ENGINE_GIT_REPO}" \
--requires="${LIBSSL_PACKAGE}" \
--install=no \
--default \

# copy the package to the external volume
cp -f *.deb /opt
