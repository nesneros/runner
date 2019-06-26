FROM ubuntu:18.04

ENV GCLOUD_VERSION=251.0.0 \
    PATH=$PATH:/google-cloud-sdk/bin \
    DOCKERVERSION=18.03.6-ce

RUN apt-get update \
  && apt-get install -y curl gnupg2 jq python software-properties-common unzip wget zip \
  && rm -rf /var/lib/apt/lists/* \
  && curl -fsSLO https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKERVERSION}.tgz \
  && tar xzvf docker-${DOCKERVERSION}.tgz --strip 1 -C /usr/local/bin docker/docker \
  && chmod +x /usr/local/bin docker/docker \
  && rm docker-${DOCKERVERSION}.tgz \
  && curl -SsL https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-$GCLOUD_VERSION-linux-x86_64.tar.gz -o - | tar -zxf - \
  && /google-cloud-sdk/install.sh --additional-components kubectl


RUN wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | apt-key add - \
    && add-apt-repository --yes https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/ \
    && apt-get update \
    && apt-get install -y adoptopenjdk-11-hotspot \
    && rm -rf /var/lib/apt/lists/*
