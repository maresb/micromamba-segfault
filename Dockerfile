FROM mambaorg/micromamba:0.25.1
# COPY --chown=$MAMBA_USER:$MAMBA_USER dev-conda-environment.yaml ./
# RUN micromamba install --name base --yes --file ./dev-conda-environment.yaml
COPY --chown=$MAMBA_USER:$MAMBA_USER dev-conda-lock.yml ./
RUN micromamba install --name base --yes --file ./dev-conda-lock.yml
COPY --chown=$MAMBA_USER:$MAMBA_USER conda-lock.yml ./
RUN micromamba install --name base --yes --file ./conda-lock.yml
