FROM golang:1.22.1-bookworm

# We need both Golang and Python
RUN apt-get update && \
    apt-get install unzip python3-pip -y --no-install-recommends && \
    apt-get clean

# https://github.com/pre-commit/pre-commit/releases
ENV PRECOMMIT_VERSION="3.6.2"
RUN pip install --break-system-packages pre-commit==${PRECOMMIT_VERSION}

# https://github.com/bridgecrewio/checkov/releases
ENV CHECKOV_VERSION="3.2.39"
RUN pip install --break-system-packages checkov==${CHECKOV_VERSION}

WORKDIR /usr/bin

# https://github.com/kubernetes-sigs/kustomize/releases
# https://github.com/kbst/terraform-provider-kustomization/releases
ENV KUSTOMIZE_VERSION="5.2.1"
RUN wget -q https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${KUSTOMIZE_VERSION}/kustomize_v${KUSTOMIZE_VERSION}_linux_amd64.tar.gz && \
    tar xzf kustomize_v${KUSTOMIZE_VERSION}_linux_amd64.tar.gz && \
    rm kustomize_v${KUSTOMIZE_VERSION}_linux_amd64.tar.gz

# https://github.com/coreos/butane/releases
ENV BUTANE_VERSION="0.20.0"
RUN wget -q https://github.com/coreos/butane/releases/download/v${BUTANE_VERSION}/butane-x86_64-unknown-linux-gnu && \
    mv butane-x86_64-unknown-linux-gnu butane && \
    chmod a+x butane

# https://github.com/tenable/terrascan/releases
ENV TERRASCAN_VERSION="1.19.1"
RUN wget -q https://github.com/tenable/terrascan/releases/download/v${TERRASCAN_VERSION}/terrascan_${TERRASCAN_VERSION}_Linux_x86_64.tar.gz && \
    tar xzf terrascan_${TERRASCAN_VERSION}_Linux_x86_64.tar.gz && \
    rm terrascan_${TERRASCAN_VERSION}_Linux_x86_64.tar.gz

# https://github.com/hashicorp/terraform/releases
ENV TF_VERSION="1.7.5"
RUN wget -q https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip && \
    unzip terraform_${TF_VERSION}_linux_amd64.zip && \
    rm terraform_${TF_VERSION}_linux_amd64.zip

# https://github.com/terraform-linters/tflint/releases
ENV TFLINT_VERSION="0.50.3"
RUN wget -q https://github.com/terraform-linters/tflint/releases/download/v${TFLINT_VERSION}/tflint_linux_amd64.zip && \
    unzip tflint_linux_amd64.zip && \
    rm tflint_linux_amd64.zip

# https://github.com/aquasecurity/trivy/releases
ENV TRIVY_VERSION="0.49.1"
RUN wget -q https://github.com/aquasecurity/trivy/releases/download/v${TRIVY_VERSION}/trivy_${TRIVY_VERSION}_Linux-64bit.tar.gz && \
    tar xzf trivy_${TRIVY_VERSION}_Linux-64bit.tar.gz && \
    rm trivy_${TRIVY_VERSION}_Linux-64bit.tar.gz

HEALTHCHECK NONE
