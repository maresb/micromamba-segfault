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
micromamba/micromamba install --name base --yes --file /tmp/conda-lock.yml
