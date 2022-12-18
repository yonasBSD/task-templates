# hadolint ignore=DL3006
ARG IMAGE_FROM_SHA
# hadolint ignore=DL3007
FROM jfxs/ci-toolkit:latest as ci-toolkit

# hadolint ignore=DL3006
FROM ${IMAGE_FROM_SHA}

ARG IMAGE_FROM_SHA
ARG ALPINE_VERSION
ARG BUILD_DATE
ARG VCS_REF="DEV"

ENV container docker

LABEL maintainer="FX Soubirou <soubirou@yahoo.fr>" \
    org.opencontainers.image.title="alpine-cntlm" \
    org.opencontainers.image.description="A lightweight automatically updated alpine cntlm image" \
    org.opencontainers.image.authors="FX Soubirou <soubirou@yahoo.fr>" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.version="${ALPINE_VERSION}" \
    org.opencontainers.image.url="https://hub.docker.com/r/jfxs/alpine-cntlm" \
    org.opencontainers.image.source="https://gitlab.com/op_so/docker/alpine-cntlm" \
    org.opencontainers.image.revision=${VCS_REF} \
    org.opencontainers.image.created=${BUILD_DATE}

COPY files/start.sh /usr/local/bin/
COPY --from=ci-toolkit /usr/local/bin/get-local-versions.sh /usr/local/bin/get-local-versions.sh

# hadolint ignore=DL3018
RUN apk --no-cache add cntlm \
    && chmod 755 /usr/local/bin/start.sh \
    && chmod 755 /usr/local/bin/get-local-versions.sh \
    && /usr/local/bin/get-local-versions.sh -f ${IMAGE_FROM_SHA} -a cntlm

USER 10010
EXPOSE 3128

ENTRYPOINT ["/usr/local/bin/start.sh"]
