# ignore pipefail because
# bash is non-default location https://github.com/tianon/docker-bash/issues/29
# hadolint only uses default locations https://github.com/hadolint/hadolint/issues/977
# hadolint global ignore=DL4006

FROM docker.io/library/bash:5.3.3@sha256:cc444a5a327f8e42318b2772b392f8dd1a9dcb9e00d3c847cc9e419eefa20419
SHELL ["/usr/local/bin/bash", "-u", "-e", "-o", "pipefail", "-c"]

ARG TARGETARCH
RUN wget -q \
		"https://dl.k8s.io/release/v1.33.1/bin/linux/$TARGETARCH/kubectl" \
		"https://dl.k8s.io/release/v1.33.1/bin/linux/$TARGETARCH/kubectl.sha256" && \
	echo " kubectl" >> kubectl.sha256 && sha256sum -csw kubectl.sha256 && rm kubectl.sha256 && \
	mv kubectl /usr/local/bin/kubectl && chmod 555 /usr/local/bin/kubectl
RUN [[ $TARGETARCH == amd64 ]] && export ARCH=x86_64; \
	[[ $TARGETARCH == arm64 ]] && export ARCH=arm64; \
	[[ -z ${ARCH:-} ]] && echo "Unknown arch: $TARGETARCH" && exit 1; \
	wget -q "https://github.com/kyverno/kyverno/releases/download/v1.15.1/kyverno-cli_v1.15.1_linux_$ARCH.tar.gz" --output-document=- | \
	tar --gz --extract --to-stdout kyverno  > /usr/local/bin/kyverno && \
	chmod 555 /usr/local/bin/kyverno
USER 1000:1000
