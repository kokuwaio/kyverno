# ignore pipefail because
# bash is non-default location https://github.com/tianon/docker-bash/issues/29
# hadolint only uses default locations https://github.com/hadolint/hadolint/issues/977
# hadolint global ignore=DL4006

FROM docker.io/library/bash:5.3.9@sha256:e320b40b14abc61f053286705070342c46034a549a276b798e64541457c4af92 AS yq
SHELL ["/usr/local/bin/bash", "-u", "-e", "-c"]
ARG TARGETARCH
RUN wget -q "https://github.com/mikefarah/yq/releases/download/v4.50.1/yq_linux_$TARGETARCH.tar.gz" --output-document=- | \
	tar --gz --extract --to-stdout "./yq_linux_$TARGETARCH" > /usr/local/bin/yq && chmod 555 /usr/local/bin/yq

FROM docker.io/library/bash:5.3.9@sha256:e320b40b14abc61f053286705070342c46034a549a276b798e64541457c4af92 AS kustomize
SHELL ["/usr/local/bin/bash", "-u", "-e", "-c"]
ARG TARGETARCH
RUN wget -q "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv5.7.0/kustomize_v5.7.0_linux_$TARGETARCH.tar.gz" --output-document=- | \
	tar --gz --extract --to-stdout kustomize > /usr/local/bin/kustomize && chmod 555 /usr/local/bin/kustomize

FROM docker.io/library/bash:5.3.9@sha256:e320b40b14abc61f053286705070342c46034a549a276b798e64541457c4af92 AS kyverno
SHELL ["/usr/local/bin/bash", "-u", "-e", "-c"]
ARG TARGETARCH
RUN [[ $TARGETARCH == amd64 ]] && export ARCH=x86_64; \
	[[ $TARGETARCH == arm64 ]] && export ARCH=arm64; \
	[[ -z ${ARCH:-} ]] && echo "Unknown arch: $TARGETARCH" && exit 1; \
	wget -q "https://github.com/kyverno/kyverno/releases/download/v1.16.3/kyverno-cli_v1.16.3_linux_$ARCH.tar.gz" --output-document=- | \
	tar --gz --extract --to-stdout kyverno > /usr/local/bin/kyverno && chmod 555 /usr/local/bin/kyverno

FROM docker.io/library/bash:5.3.9@sha256:e320b40b14abc61f053286705070342c46034a549a276b798e64541457c4af92
COPY --link --from=yq /usr/local/bin/yq /usr/local/bin/yq
COPY --link --from=kyverno /usr/local/bin/kyverno /usr/local/bin/kyverno
COPY --link --from=kustomize /usr/local/bin/kustomize /usr/local/bin/kustomize
COPY --link --chmod=555 entrypoint.sh /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
USER 1000:1000
