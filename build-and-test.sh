#!/bin/bash

set -euo pipefail

micromamba install --name micromamba-dev --file ./micromamba/environment-dev.yml
micromamba install --name=micromamba-dev --file ./libmamba/environment-static-dev.yml

mkdir -p /tmp/mamba/build
cd /tmp/mamba/build
cmake .. \
    -DBUILD_LIBMAMBA=ON \
    -DBUILD_STATIC_DEPS=ON \
    -DBUILD_MICROMAMBA=ON \
    -DMICROMAMBA_LINKAGE=FULL_STATIC \
    -DCMAKE_CXX_COMPILER_LAUNCHER=sccache \
    -DCMAKE_C_COMPILER_LAUNCHER=sccache \
;
make

set +e
micromamba/micromamba install --name base --yes --file /tmp/conda-lock.yml
status=$?
if [ "$status" == 139 ]; then
    echo "Bad commit $(git rev-parse --short HEAD): SEGFAULT"
    exit 1
elif [ "$status" == 0 ]; then
    echo "Good commit $(git rev-parse --short HEAD): NO SEGFAULT"
    exit 0
else
    echo "Unknown error"
    exit "$status"
fi
