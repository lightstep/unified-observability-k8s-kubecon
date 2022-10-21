# FROM python:3.9.4-slim-buster
FROM ubuntu:jammy-20221003

# Install curl (required for gcloud CLI install) + envsubst
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    unzip \
    gettext-base \
  && rm -rf /var/lib/apt/lists/*

# Install gcloud (https://stackoverflow.com/a/53501128)
RUN apt-get update && apt-get install -y apt-transport-https gnupg curl lsb-release
RUN curl https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-406.0.0-darwin-x86_64.tar.gz | tar -xzv
RUN ./google-cloud-sdk/install.sh --quiet
# RUN export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)" && \
#   echo "cloud SDK repo: $CLOUD_SDK_REPO" && \
#   echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
#   curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
#   apt-get update -y && apt-get install google-cloud-sdk -y

ENV TF_VERSION="1.3.3"
RUN wget --quiet https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip \
  && unzip terraform_${TF_VERSION}_linux_amd64.zip \
  && mv terraform /usr/bin \
  && rm terraform_${TF_VERSION}_linux_amd64.zip

# Install kubectl from Docker Hub (https://www.jeffgeerling.com/blog/2018/install-kubectl-your-docker-image-easy-way)
COPY --from=lachlanevenson/k8s-kubectl:v1.25.0 /usr/local/bin/kubectl /usr/local/bin/kubectl

ENV WORKDIR="/workdir"
RUN mkdir -p ${WORKDIR}/terraform
WORKDIR ${WORKDIR}

# COPY startup.sh .
# RUN chmod 755 startup.sh

CMD ["/bin/bash"]