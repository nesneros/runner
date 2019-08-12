FROM ubuntu:18.04

ENV GCLOUD_VERSION=257.0.0 \
    PATH=$PATH:/google-cloud-sdk/bin \
    DOCKER_VERSION=19.03.1 \
    HELM_VERSION=2.14.3 \
    NVM_VERSION=v0.34.0 \
    NVM_DIR=/nvm \
    JAVA_HOME=/usr/lib/jvm/adoptopenjdk-11-hotspot-amd64 \
    JAVA11_HOME=/usr/lib/jvm/adoptopenjdk-11-hotspot-amd64

RUN apt-get update \
  && apt-get install -y curl git gnupg2 jq python python-openssl software-properties-common unzip wget zip \
  && rm -rf /var/lib/apt/lists/* \
  && mkdir -p $NVM_DIR && curl -o- https://raw.githubusercontent.com/creationix/nvm/${NVM_VERSION}/install.sh | bash

COPY nvm.sh /usr/local/bin/

RUN curl -fsSLO https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz \
  && tar xzvf helm-v${HELM_VERSION}-linux-amd64.tar.gz --strip 1 -C /usr/local/bin linux-amd64/helm \
  && rm helm-v2.14.3-linux-amd64.tar.gz

RUN curl -fsSLO https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_VERSION}.tgz \
  && tar xzvf docker-${DOCKER_VERSION}.tgz --strip 1 -C /usr/local/bin/ docker/docker \
  && rm docker-${DOCKER_VERSION}.tgz \
  && curl -SsL https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-$GCLOUD_VERSION-linux-x86_64.tar.gz -o - | tar -zxf - \
  && /google-cloud-sdk/install.sh --additional-components kubectl \
  && docker --version

RUN wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | apt-key add - \
    && add-apt-repository --yes https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/ \
    && apt-get update \
    && apt-get install -y adoptopenjdk-11-hotspot \
    && rm -rf /var/lib/apt/lists/*
