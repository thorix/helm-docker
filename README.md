# helm-docker

[![Docker Pulls](https://img.shields.io/docker/pulls/thorix/helm.svg?style=flat-square)](https://hub.docker.com/r/thorix/helm/)

Docker images are automatically built on [Docker
Hub](https://hub.docker.com/r/thorix/helm/):

- `latest` always corresponds with the latest build from master
- Docker `tag` always correspond with git `tag`

## Usage

`helm`, `gcloud` and `kubectl` are all available.

The image also includes the `helm diff` Helm Plugin.

## Docker

```bash
VERSION=2.9.0; docker build --build-arg HELM_VERSION=v$VERSION . -t $VERSION
```

## Release procedure

1. Bump `VERSION` in the [Dockerfile](Dockerfile)
1. Commit and create tag matching the version:

```bash
export $VERSION
git tag -a $VERSION
git push origin --tags
```

2. Delete a tag
```bash
export $VERSION
git tag -d $VERSION
git push origin :refs/tags/$VERSION
```
