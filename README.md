# Kyverno WoodpeckerCI Plugin

[![pulls](https://img.shields.io/docker/pulls/kokuwaio/kyverno)](https://hub.docker.com/r/kokuwaio/kyverno)
[![size](https://img.shields.io/docker/image-size/kokuwaio/kyverno)](https://hub.docker.com/r/kokuwaio/kyverno)
[![dockerfile](https://img.shields.io/badge/source-Dockerfile%20-blue)](https://git.kokuwa.io/woodpecker/kyverno/src/branch/main/Dockerfile)
[![license](https://img.shields.io/badge/License-EUPL%201.2-blue)](https://git.kokuwa.io/woodpecker/kyverno/src/branch/main/LICENSE)
[![prs](https://img.shields.io/gitea/pull-requests/open/woodpecker/kyverno?gitea_url=https%3A%2F%2Fgit.kokuwa.io)](https://git.kokuwa.io/woodpecker/kyverno/pulls)
[![issues](https://img.shields.io/gitea/issues/open/woodpecker/kyverno?gitea_url=https%3A%2F%2Fgit.kokuwa.io)](https://git.kokuwa.io/woodpecker/kyverno/issues)

A [WoodpeckerCI](https://woodpecker-ci.org) plugin for [kyverno](https://github.com/kyverno/kyverno) and [kustomize](https://kustomize.io/) to lint kubernetes manifests.
Also usable with Gitlab, Github or locally, see examples for usage.

## Features

- runs kustomize if `entrypoint.sh` is found and checks for occurances of `<patched>`
- can use policies from directory, see setting `policies`
- runnable with local docker daemon

## Example

Woodpecker:

```yaml
steps:
  kyverno:
    depends_on: []
    image: kokuwaio/kyverno:v1.16.3
    settings:
      manifests: kustomize
      policy: policies
```

Gitlab: (using script is needed because of <https://gitlab.com/gitlab-org/gitlab/-/issues/19717>)

```yaml
kyverno:
  needs: []
  stage: lint
  image:
    name: kokuwaio/kyverno:v1.16.3
    entrypoint: [""]
  script: [/usr/local/bin/entrypoint.sh]
  variables:
    PLUGIN_MANIFESTS: kustomize
    PLUGIN_POLICY: policies
```

CLI:

```bash
docker run --rm --volume=$(pwd):$(pwd):rw --workdir=$(pwd) kokuwaio/kyverno:v1.16.3
```

## Settings

| Settings Name      | Environment             | Default | Description                                   |
| ------------------ | ----------------------- | ------- | --------------------------------------------- |
| `manifests`        | PLUGIN_MANIFESTS        | `$PWD`  | Directory to search for Kubernetes manifests. |
| `policy`           | PLUGIN_POLICY           | `none`  | Directory/Git to search for policies to use.  |
| `warn-no-pass`     | PLUGIN_WARN_NO_PASS     | `true`  | Warn if no resources where checked.           |
| `table`            | PLUGIN_TABLE            | `true`  | Display violations as table.                  |
| `detailed-results` | PLUGIN_DETAILED_RESULTS | `true`  | Display violations with detailed results.     |

## Alternatives

| Image                                                               | Comment                           |                                                                       amd64                                                                       |                                                                          arm64                                                                          |
| ------------------------------------------------------------------- | --------------------------------- | :-----------------------------------------------------------------------------------------------------------------------------------------------: | :-----------------------------------------------------------------------------------------------------------------------------------------------------: |
| [kokuwaio/kyverno](https://hub.docker.com/r/kokuwaio/kyverno)       | Woodpecker plugin                 | [![size](https://img.shields.io/docker/image-size/kokuwaio/kyverno?arch=amd64&label=)](https://hub.docker.com/r/kokuwaio/kyverno)                 | [![size](https://img.shields.io/docker/image-size/kokuwaio/kyverno?arch=arm64&label=)](https://hub.docker.com/r/kokuwaio/kyverno)                       |
| [ghcr.io/kyverno/kyverno-cli](https://ghcr.io/kyverno/kyverno-cli)  | not a Woodpecker plugin, official | [![size](https://img.shields.io/docker/image-size/kokuwaio/markdownlint?arch=amd64&label=)](https://hub.docker.com/r/ghcr.io/kyverno/kyverno-cli) | [![size](https://img.shields.io/docker/image-size/ghcr.io/kyverno/kyverno-cli?arch=arm64&label=)](https://hub.docker.com/r/ghcr.io/kyverno/kyverno-cli) |
| [bitnami/kyverno-cli](https://hub.docker.com/r/bitnami/kyverno-cli) | not a Woodpecker plugin           | [![size](https://img.shields.io/docker/image-size/bitnami/kyverno-cli?arch=amd64&label=)](https://hub.docker.com/r/bitnami/kyverno-cli)           | [![size](https://img.shields.io/docker/image-size/bitnami/kyverno-cli?arch=arm64&label=)](https://hub.docker.com/r/bitnami/kyverno-cli)                 |
| [nirmata/kyverno-cli](https://hub.docker.com/r/nirmata/kyverno-cli) | not a Woodpecker plugin, outdated | [![size](https://img.shields.io/docker/image-size/nirmata/kyverno-cli?arch=amd64&label=)](https://hub.docker.com/r/nirmata/kyverno-cli)           | [![size](https://img.shields.io/docker/image-size/nirmata/kyverno-cli?arch=arm64&label=)](https://hub.docker.com/r/nirmata/kyverno-cli)                 |
| [gbaeke/kyverno-cli](https://hub.docker.com/r/gbaeke/kyverno-cli)   | not a Woodpecker plugin, outdated | [![size](https://img.shields.io/docker/image-size/gbaeke/kyverno-cli?arch=amd64&label=)](https://hub.docker.com/r/gbaeke/kyverno-cli)             | [![size](https://img.shields.io/docker/image-size/gbaeke/kyverno-cli?arch=arm64&label=)](https://hub.docker.com/r/gbaeke/kyverno-cli)                   |
