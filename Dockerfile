FROM codercom/code-server:4.96.4-39

ARG ARGOCD_CLI_VERSION=v2.14.2
ARG DEVSPACE_VERSION=v6.3.14
ARG KUBECTL_VERSION=v1.32.1
ARG KBCLI_VERSION=v0.9.2
ARG TASKFILE_VERSION=v3.41.0
ARG GHORG_VERSION=1.11.0
ARG PHP_VERSION=8.3.2
ARG COMPOSER_VERSION=2.7.4
ARG HELM_VERSION=3.17.0

USER root

RUN yum install -y nodejs18 parallel mysql jq yq zsh nu rubygem-mustache && \
    yum clean all

RUN curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl" \
    && chmod +x kubectl \
    && mv kubectl /usr/local/bin/

RUN curl -LO "https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz" \
    && tar -zxvf helm-v${HELM_VERSION}-linux-amd64.tar.gz \
    && chmod +x linux-amd64/helm \
    && mv linux-amd64/helm /usr/local/bin/helm \
    && rm -Rf linux-amd64

RUN curl -LO "https://github.com/apecloud/kbcli/releases/download/${KBCLI_VERSION}/kbcli-linux-amd64-v0.9.2.tar.gz" \
    && tar xvfz kbcli-linux-amd64-${KBCLI_VERSION}.tar.gz \
    && chmod +x linux-amd64/kbcli \
    && mv linux-amd64/kbcli /usr/local/bin/ \
    && rm -Rf linux-amd64

RUN curl -L -o devspace "https://github.com/devspace-sh/devspace/releases/download/${DEVSPACE_VERSION}/devspace-linux-amd64" && sudo install -c -m 0755 devspace /usr/local/bin


RUN sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d ${TASKFILE_VERSION} \
    && mv ./bin/task /usr/local/bin

RUN curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash \
    && mv kustomize /usr/local/bin

RUN curl -LO "https://github.com/gabrie30/ghorg/releases/download/v${GHORG_VERSION}/ghorg_${GHORG_VERSION}_Linux_x86_64.tar.gz" \
    && tar xvfz ghorg_${GHORG_VERSION}_Linux_x86_64.tar.gz \
    && chmod +x ghorg \
    && mv ghorg /usr/local/bin

RUN dnf install -y dnf-plugins-core && \
    dnf install -y \
        php \
        php-cli \
        php-mbstring \
        php-xml \
        php-curl \
        php-json \
        php-zip \
        curl unzip git \
        php-gd \
        java-11-openjdk && \
    dnf clean all

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --version=${COMPOSER_VERSION}

# Change shell to zsh
RUN chsh -s /usr/bin/zsh coder

RUN curl -sfL https://direnv.net/install.sh | bash

RUN wget https://github.com/argoproj/argo-cd/releases/download/${ARGOCD_CLI_VERSION}/argocd-linux-amd64 -O /usr/bin/argocd && chmod +x /usr/bin/argocd 

USER coder

