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

COPY --chown=$MAMBA_USER:$MAMBA_USER conda-lock.yml ./

USER root
RUN apt-get update && apt-get install lldb -y
USER $MAMBA_USER

# # The following is where the segfault occurs.
# # I'm commenting it out in order to run lldb:
# RUN micromamba install --name base --yes --file ./conda-lock.yml
