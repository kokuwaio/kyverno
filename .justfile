# https://just.systems/man/en/

[private]
@default:
    just --list --unsorted

# Run linter on project.
@lint:
    docker run --rm --read-only --volume=$PWD:$PWD:ro --workdir=$PWD kokuwaio/just:1.46.0
    docker run --rm --read-only --volume=$PWD:$PWD:ro --workdir=$PWD kokuwaio/yamllint:v1.38.0
    docker run --rm --read-only --volume=$PWD:$PWD:rw --workdir=$PWD kokuwaio/markdownlint:0.47.0 --fix
    docker run --rm --read-only --volume=$PWD:$PWD:ro --workdir=$PWD kokuwaio/renovate-config-validator:42
    docker run --rm --read-only --volume=$PWD:$PWD:ro --workdir=$PWD registry.kokuwa.io/kubectl:kustomize >/dev/null
    docker run --rm --read-only --volume=$PWD:$PWD:ro --workdir=$PWD woodpeckerci/woodpecker-cli lint

# Build image with local docker daemon.
@build:
    docker buildx build . --platform=linux/amd64,linux/arm64

# Inspect image layers with `dive`.
@dive TARGET="":
    dive build . --target={{ TARGET }}

# Test created image.
@test:
    docker build . --tag=kokuwaio/kyverno:dev --quiet
    docker run --rm --read-only --volume=$PWD:$PWD:rw --workdir=$PWD --env=PLUGIN_POLICY=test/policies --env=PLUGIN_MANIFESTS=test/kustomize-fail-patched     kokuwaio/kyverno:dev || true
    docker run --rm --read-only --volume=$PWD:$PWD:rw --workdir=$PWD --env=PLUGIN_POLICY=test/policies --env=PLUGIN_MANIFESTS=test/kustomize-fail-default     kokuwaio/kyverno:dev || true
    docker run --rm --read-only --volume=$PWD:$PWD:rw --workdir=$PWD --env=PLUGIN_POLICY=test/policies --env=PLUGIN_MANIFESTS=test/kustomize                  kokuwaio/kyverno:dev
    docker run --rm --read-only --volume=$PWD:$PWD:rw --workdir=$PWD --env=PLUGIN_POLICY=test/policies --env=PLUGIN_MANIFESTS=test/manifests-fail-default     kokuwaio/kyverno:dev || true
    docker run --rm --read-only --volume=$PWD:$PWD:rw --workdir=$PWD --env=PLUGIN_POLICY=test/policies --env=PLUGIN_MANIFESTS=test/manifests-fail-kube-system kokuwaio/kyverno:dev || true
    docker run --rm --read-only --volume=$PWD:$PWD:rw --workdir=$PWD --env=PLUGIN_POLICY=test/policies --env=PLUGIN_MANIFESTS=test/manifests                  kokuwaio/kyverno:dev
