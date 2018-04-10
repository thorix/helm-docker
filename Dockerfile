FROM alpine:latest
ARG HELM_VERSION

MAINTAINER Ryan W <ryanw@thorix.net>

RUN echo "Helm Version: ${HELM_VERSION}"

WORKDIR /

# Helm plugins require git
# helm-diff requires bash, curl
# Enable SSL
RUN apk --update add ca-certificates wget python curl tar bash git \
 && rm -rf /var/cache/apk/*

# Install gcloud and kubectl
# kubectl will be available at /google-cloud-sdk/bin/kubectl
# This is added to $PATH
ENV HOME /
ENV PATH /google-cloud-sdk/bin:$PATH
ENV CLOUDSDK_PYTHON_SITEPACKAGES 1
RUN wget https://dl.google.com/dl/cloudsdk/channels/rapid/google-cloud-sdk.zip && unzip google-cloud-sdk.zip && rm google-cloud-sdk.zip
RUN google-cloud-sdk/install.sh --usage-reporting=true --path-update=true --bash-completion=true --rc-path=/.bashrc --additional-components app kubectl alpha beta
# Disable updater check for the whole installation.
# Users won't be bugged with notifications to update to the latest version of gcloud.
RUN google-cloud-sdk/bin/gcloud config set --installation component_manager/disable_update_check true

# Install Helm
ENV FILENAME helm-${HELM_VERSION}-linux-amd64.tar.gz
ENV HELM_URL https://storage.googleapis.com/kubernetes-helm/${FILENAME}

RUN curl -o /tmp/$FILENAME ${HELM_URL} \
  && tar -zxvf /tmp/${FILENAME} -C /tmp \
  && mv /tmp/linux-amd64/helm /bin/helm

# Install Helm plugins
# Plugin is downloaded to /tmp, which must exist
RUN helm init --client-only \
 && helm plugin install https://github.com/databus23/helm-diff \
 && rm -rf /tmp
