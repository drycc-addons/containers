ARG CODENAME
FROM registry.drycc.cc/drycc/base:${CODENAME}

ARG TARGETARCH

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install-packages curl procps
RUN apt-get update && apt-get upgrade -y && \
    apt-get clean && rm -rf /var/lib/apt/lists /var/cache/apt/archives

ENV HOME="/opt/drycc" \
    OS_FLAVOUR="debian-12" \
    OS_NAME="linux"

USER 1001

CMD [ "/bin/bash" ]