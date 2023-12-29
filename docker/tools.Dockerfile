FROM golang:1.21.4-bookworm

# We need both Golang and Python
RUN apt-get update && \
    apt-get install unzip python3-pip -y --no-install-recommends && \
    apt-get clean

ENV PRECOMMIT_VERSION="3.6.0"
RUN pip install --break-system-packages pre-commit==${PRECOMMIT_VERSION}

ENV CHECKOV_VERSION="3.1.50"
RUN pip install --break-system-packages checkov==${CHECKOV_VERSION}

WORKDIR /usr/bin

ENV BUTANE_VERSION="0.19.0"
RUN wget -q https://github.com/coreos/butane/releases/download/v${BUTANE_VERSION}/butane-x86_64-unknown-linux-gnu && \
    mv butane-x86_64-unknown-linux-gnu butane && \
    chmod a+x butane

ENV TERRASCAN_VERSION="1.18.11"
RUN wget -q https://github.com/tenable/terrascan/releases/download/v${TERRASCAN_VERSION}/terrascan_${TERRASCAN_VERSION}_Linux_x86_64.tar.gz && \
    tar xzf terrascan_${TERRASCAN_VERSION}_Linux_x86_64.tar.gz && \
    rm terrascan_${TERRASCAN_VERSION}_Linux_x86_64.tar.gz

ENV TF_VERSION="1.6.6"
RUN wget -q https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip && \
    unzip terraform_${TF_VERSION}_linux_amd64.zip && \
    rm terraform_${TF_VERSION}_linux_amd64.zip

ENV TFLINT_VERSION="0.49.0"
RUN wget -q https://github.com/terraform-linters/tflint/releases/download/v${TFLINT_VERSION}/tflint_linux_amd64.zip && \
    unzip tflint_linux_amd64.zip && \
    rm tflint_linux_amd64.zip

ENV TRIVY_VERSION="0.48.1"
RUN wget -q https://github.com/aquasecurity/trivy/releases/download/v${TRIVY_VERSION}/trivy_${TRIVY_VERSION}_Linux-64bit.tar.gz && \
    tar xzf trivy_${TRIVY_VERSION}_Linux-64bit.tar.gz && \
    rm trivy_${TRIVY_VERSION}_Linux-64bit.tar.gz

HEALTHCHECK NONE
