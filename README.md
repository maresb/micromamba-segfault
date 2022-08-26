The files `dev-conda-lock.yml` and `conda-lock.yml` were generated with:

```bash
conda-lock -f dev-conda-environment.yaml -p linux-64 --lockfile dev-conda-lock.yml
conda-lock
```

Run `docker build .` to see segfault (code 139).
