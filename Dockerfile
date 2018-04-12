FROM alpine:latest

MAINTAINER Ryan W <ryanw@thorix.net>

ARG HELM_VERSION
ENV HOME /
ENV PATH /google-cloud-sdk/bin:$PATH
ENV CLOUDSDK_PYTHON_SITEPACKAGES 1

ENV FILENAME helm-${HELM_VERSION}-linux-amd64.tar.gz

RUN echo "Helm Version: ${HELM_VERSION}"

WORKDIR /

# Helm plugins require git
# helm-diff requires bash, curl
RUN apk --update --no-cache add ca-certificates python curl tar bash git

# Install gcloud and kubectl
# kubectl will be available at /google-cloud-sdk/bin/kubectl
# This is added to $PATH
# Disable updater check for the whole installation.
# Users won't be bugged with notifications to update to the latest version of gcloud.
RUN curl -SL https://dl.google.com/dl/cloudsdk/channels/rapid/google-cloud-sdk.tar.gz | tar -zx \
    && google-cloud-sdk/install.sh --usage-reporting=true --path-update=true --bash-completion=true --rc-path=/.bashrc --additional-components app kubectl alpha beta \
    && google-cloud-sdk/bin/gcloud config set --installation component_manager/disable_update_check true

# get Helm
RUN curl -SL http://storage.googleapis.com/kubernetes-helm/${FILENAME} | tar zx -C /tmp \
    && mv /tmp/linux-amd64/helm /bin/helm \
    && rm -rf /tmp

# Install Helm plugins
# Plugin is downloaded to /tmp, which must exist
#RUN helm init --client-only \
# && helm plugin install https://github.com/databus23/helm-diff \
# && rm -rf /tmp

VOLUME ["/.helm", "/.kube"]

ENTRYPOINT ["/bin/helm"]

