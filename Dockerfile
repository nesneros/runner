FROM ubuntu:18.04

ENV GCLOUD_VERSION=251.0.0 \
    PATH=$PATH:/google-cloud-sdk/bin

RUN apt-get update && apt-get install -y curl emacs python unzip zip && rm -rf /var/lib/apt/lists/* \
  && curl -SsL https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-$GCLOUD_VERSION-linux-x86_64.tar.gz -o - | tar -zxf - \
  && /google-cloud-sdk/install.sh --additional-components kubectl

# COPY /rclone /usr/bin/

#RUN echo "deb http://ppa.launchpad.net/alessandro-strada/ppa/ubuntu bionic main" > /etc/apt/sources.list.d/alessandro-strada.list
#RUN apt-get update
#RUN apt-get install -y google-drive-ocamlfuse

ENV PATH=$PATH:/miabin

COPY /miabin/ /miabin/

ENTRYPOINT [ "/miabin/entrypoint.sh" ]
