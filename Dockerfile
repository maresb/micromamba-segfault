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
RUN apt-get update && apt-get install lldb git -y
USER $MAMBA_USER

RUN git clone https://github.com/mamba-org/mamba.git
WORKDIR /tmp/mamba
RUN micromamba create --name micromamba-dev --file ./micromamba/environment-dev.yml
RUN micromamba install --name=micromamba-dev --file ./libmamba/environment-static-dev.yml

ENV ENV_NAME=micromamba-dev
ARG MAMBA_DOCKERFILE_ACTIVATE=1 

USER root
RUN apt-get update && apt-get install build-essential -y
USER $MAMBA_USER


RUN : \
&& mkdir -p build \
&& cd build \
&& cmake .. \
    -DBUILD_LIBMAMBA=ON \
    -DBUILD_STATIC_DEPS=ON \
    -DBUILD_MICROMAMBA=ON \
    -DMICROMAMBA_LINKAGE=FULL_STATIC \
;
RUN cd build && make

RUN echo; echo; echo; echo; echo CHECKING OUT micromamba-0.25.1; echo; echo; echo; echo;
# # Works:
# RUN build/micromamba/micromamba install --name base --yes --file ./conda-lock.yml

RUN git checkout micromamba-0.25.1
RUN micromamba install --name micromamba-dev --file ./micromamba/environment-dev.yml
RUN micromamba install --name=micromamba-dev --file ./libmamba/environment-static-dev.yml
RUN : \
&& mkdir -p build \
&& cd build \
&& cmake .. \
    -DBUILD_LIBMAMBA=ON \
    -DBUILD_STATIC_DEPS=ON \
    -DBUILD_MICROMAMBA=ON \
    -DMICROMAMBA_LINKAGE=FULL_STATIC \
;
RUN cd build && make

RUN cd .. && micromamba install --name base --yes --file ./conda-lock.yml
