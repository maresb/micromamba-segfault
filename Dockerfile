FROM mambaorg/micromamba:0.25.1

# # If we go back to v0.24.0 the segfault no longer occurs.
# ARG MAMBA_DOCKERFILE_ACTIVATE=1 
# RUN micromamba install --name base --channel=conda-forge --yes micromamba=0.24.0
# RUN micromamba --version

# # As an alternative to the pair of lines below, the segfault also occurs
# # when the first install command uses the unlocked environment.
# COPY --chown=$MAMBA_USER:$MAMBA_USER dev-conda-environment.yaml ./
# RUN micromamba install --name base --yes --file ./dev-conda-environment.yaml

COPY --chown=$MAMBA_USER:$MAMBA_USER dev-conda-lock.yml ./
RUN micromamba install --name base --yes --file ./dev-conda-lock.yml

# COPY --chown=$MAMBA_USER:$MAMBA_USER conda-lock.yml micromamba ./

USER root
RUN apt-get update && apt-get install lldb git build-essential -y
USER $MAMBA_USER

RUN git clone https://github.com/mamba-org/mamba.git
WORKDIR /tmp/mamba
RUN micromamba create --name micromamba-dev --file ./micromamba/environment-dev.yml
RUN micromamba install --name=micromamba-dev --file ./libmamba/environment-static-dev.yml
RUN micromamba install --name=micromamba-dev -c conda-forge -y sccache

ENV ENV_NAME=micromamba-dev
ARG MAMBA_DOCKERFILE_ACTIVATE=1 

COPY --chown=$MAMBA_USER:$MAMBA_USER conda-lock.yml build-and-test.sh /tmp/

RUN git bisect start 5c8672e f2ac46b && git bisect run /tmp/build-and-test.sh

RUN ../build-and-test.sh

# RUN sed -i 's/set(CMAKE_BUILD_TYPE Release)/set(CMAKE_BUILD_TYPE Debug)/' CMakeLists.txt
# RUN pwd && grep CMAKE_BUILD_TYPE CMakeLists.txt
