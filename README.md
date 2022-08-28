The files `dev-conda-lock.yml` and `conda-lock.yml` were generated with:

```bash
conda-lock -f dev-conda-environment.yaml -p linux-64 --lockfile dev-conda-lock.yml
conda-lock
```

Use the following commands to get the backtrace (unfortunately without debug symbols)

```bash
docker build -t micromamba-segfault .
docker run --rm -it --cap-add=SYS_PTRACE --security-opt seccomp=unconfined micromamba-segfault bash
lldb /tmp/mamba/build/micromamba/micromamba
process launch -- install --name base --yes --file /tmp/conda-lock.yml
bt all
```
