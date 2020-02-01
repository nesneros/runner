FROM ubuntu:18.04

ENV GCLOUD_VERSION=278.0.0 \
  KUBECTL_VERSION=1.16.5 \
  JSONNET_VERSION=0.14.0 \
  KUBECFG_VERSION=0.14.0 \
  PATH=$PATH:/google-cloud-sdk/bin \
  DOCKER_VERSION=19.03.2 \
  HELM_VERSION=3.0.3 \
  KUSTOMIZE_VERSION=3.2.0 \
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
  && rm helm-v${HELM_VERSION}-linux-amd64.tar.gz \
  && helm version \
  && echo "----- Install gcloud - with gsutil" \
  && curl -SsL https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-$GCLOUD_VERSION-linux-x86_64.tar.gz -o - | tar -zxf - \
  && /google-cloud-sdk/install.sh --additional-components gsutil \
  && gcloud version \
  && echo "----- Install Jsonnet" \
  && curl -fsSLO https://github.com/google/jsonnet/releases/download/v${JSONNET_VERSION}/jsonnet-bin-v${JSONNET_VERSION}-linux.tar.gz \
  && tar xzvf jsonnet-bin-v${JSONNET_VERSION}-linux.tar.gz -C /usr/local/bin/ jsonnet \
  && rm jsonnet-bin-v${JSONNET_VERSION}-linux.tar.gz \
  && jsonnet -v \
  && curl -fsSLo /usr/local/bin/kubecfg https://github.com/bitnami/kubecfg/releases/download/v${KUBECFG_VERSION}/kubecfg-linux-amd64 \
  && chmod +x /usr/local/bin/kubecfg \
  && kubecfg version
  
RUN curl -fsSL0o /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl \
  && chmod +x /usr/local/bin/kubectl \
  && kubectl version --client=true

COPY nvm.sh /usr/local/bin/
