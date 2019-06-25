FROM ubuntu:18.04

RUN apt-get update && apt-get install -y curl gnupg2 python software-properties-common unzip wget zip && rm -rf /var/lib/apt/lists/*

RUN wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | apt-key add - \
    && add-apt-repository --yes https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/ \
    && apt-get update \
    && apt-get install -y adoptopenjdk-11-hotspot \
    && rm -rf /var/lib/apt/lists/*

ENV GCLOUD_VERSION=251.0.0 \
    PATH=$PATH:/google-cloud-sdk/bin \
    GRADLE_USER_HOME=/gradle_user_home

RUN mkdir -p "$GRADLE_USER_HOME" \
  && curl -SsL https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-$GCLOUD_VERSION-linux-x86_64.tar.gz -o - | tar -zxf - \
  && /google-cloud-sdk/install.sh --additional-components kubectl

COPY /gradles/ /gradles/

RUN sh /gradles/5.4.1/gradlew --help > /dev/null
RUN sh /gradles/5.4/gradlew --help > /dev/null
