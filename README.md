# Kyverno WoodpeckerCI Plugin

[![pulls](https://img.shields.io/docker/pulls/kokuwaio/kyverno)](https://hub.docker.com/r/kokuwaio/kyverno)
[![size](https://img.shields.io/docker/image-size/kokuwaio/kyverno)](https://hub.docker.com/r/kokuwaio/kyverno)
[![dockerfile](https://img.shields.io/badge/source-Dockerfile%20-blue)](https://git.kokuwa.io/woodpecker/kyverno/src/branch/main/Dockerfile)
[![license](https://img.shields.io/badge/License-EUPL%201.2-blue)](https://git.kokuwa.io/woodpecker/kyverno/src/branch/main/LICENSE)
[![prs](https://img.shields.io/gitea/pull-requests/open/woodpecker/kyverno?gitea_url=https%3A%2F%2Fgit.kokuwa.io)](https://git.kokuwa.io/woodpecker/kyverno/pulls)
[![issues](https://img.shields.io/gitea/issues/open/woodpecker/kyverno?gitea_url=https%3A%2F%2Fgit.kokuwa.io)](https://git.kokuwa.io/woodpecker/kyverno/issues)

A [WoodpeckerCI](https://woodpecker-ci.org) plugin for [kyverno](https://github.com/kyverno/kyverno) and [kubectl](https://kubernetes.io/docs/reference/kubectl/) to lint kubernetes manifests.
Also usable with Gitlab, Github or locally, see examples for usage.

## Features

- ...

## Alternatives

| Image                                                                                        | Comment                           | amd64 | arm64 |
| -------------------------------------------------------------------------------------------- | --------------------------------- |:-----:|:-----:|
| [kokuwaio/kyverno](https://hub.docker.com/r/kokuwaio/kyverno)                                | Woodpecker plugin                 | [![size](https://img.shields.io/docker/image-size/kokuwaio/kyverno?arch=amd64&label=)](https://hub.docker.com/r/kokuwaio/kyverno) | [![size](https://img.shields.io/docker/image-size/kokuwaio/kyverno?arch=arm64&label=)](https://hub.docker.com/r/kokuwaio/kyverno) |
| [ghcr.io/kyverno/kyverno-cli](https://ghcr.io/kyverno/kyverno-cli)                           | not a Woodpecker plugin, official | [![size](https://img.shields.io/docker/image-size/kokuwaio/markdownlint?arch=amd64&label=)](https://hub.docker.com/r/ghcr.io/kyverno/kyverno-cli) | [![size](https://img.shields.io/docker/image-size/ghcr.io/kyverno/kyverno-cli?arch=arm64&label=)](https://hub.docker.com/r/ghcr.io/kyverno/kyverno-cli) |
