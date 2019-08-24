FROM ubuntu:18.04

ENV GCLOUD_VERSION=259.0.0 \
    PATH=$PATH:/google-cloud-sdk/bin \
    DOCKER_VERSION=19.03.1 \
    HELM_VERSION=2.14.3 \
    KUSTOMIZE_VERSION=3.1.0 \
    NVM_VERSION=v0.34.0 \
    NVM_DIR=/nvm \
    JAVA_HOME=/usr/lib/jvm/adoptopenjdk-11-hotspot-amd64 \
    JAVA11_HOME=/usr/lib/jvm/adoptopenjdk-11-hotspot-amd64

RUN apt-get update \
  && apt-get install -y curl git gnupg2 jq python python-openssl software-properties-common unzip wget zip \
  && rm -rf /var/lib/apt/lists/* \
  && mkdir -p $NVM_DIR && curl -o- https://raw.githubusercontent.com/creationix/nvm/${NVM_VERSION}/install.sh | bash

RUN wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | apt-key add - \
  && add-apt-repository --yes https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/ \
  && apt-get update \
  && apt-get install -y adoptopenjdk-11-hotspot \
  && rm -rf /var/lib/apt/lists/*

RUN echo "----- Install Docker client" \
  && curl -fsSLO https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_VERSION}.tgz \
  && tar xzvf docker-${DOCKER_VERSION}.tgz --strip 1 -C /usr/local/bin/ docker/docker \
  && rm docker-${DOCKER_VERSION}.tgz \
  && docker --version \
  && echo "----- Install kustomize" \
  && curl -fsSL https://github.com/kubernetes-sigs/kustomize/releases/download/v${KUSTOMIZE_VERSION}/kustomize_${KUSTOMIZE_VERSION}_linux_amd64 > /usr/local/bin/kustomize \
  && chmod +x /usr/local/bin/kustomize \
  && kustomize version \
  && echo "----- Install Helm" \
  && curl -fsSLO https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz \
  && tar xzvf helm-v${HELM_VERSION}-linux-amd64.tar.gz --strip 1 -C /usr/local/bin linux-amd64/helm \
  && rm helm-v2.14.3-linux-amd64.tar.gz \
  # && helm version \
  && echo "----- Install gcloud (with kubectl)" \
  && curl -SsL https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-$GCLOUD_VERSION-linux-x86_64.tar.gz -o - | tar -zxf - \
  && /google-cloud-sdk/install.sh --additional-components kubectl gsutil \
  && gcloud version

COPY nvm.sh /usr/local/bin/
