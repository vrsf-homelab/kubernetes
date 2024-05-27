ARG ARGOCD_VERSION=v2.11.2
ARG KSOPS_VERSION=v4.3.1

FROM quay.io/viaductoss/ksops:${KSOPS_VERSION} as ksops-builder

FROM quay.io/argoproj/argocd:${ARGOCD_VERSION}

ENV SOPS_VERSION=3.8.1 \
    VALS_VERSION=0.37.0 \
    KUBECTL_VERSION=1.30.0 \
    HELM_SECRETS_VERSION=4.6.0

ENV HELM_SECRETS_BACKEND="sops" \
    HELM_SECRETS_HELM_PATH=/usr/local/bin/helm \
    HELM_PLUGINS="/home/argocd/.local/share/helm/plugins/" \
    HELM_SECRETS_VALUES_ALLOW_SYMLINKS=false \
    HELM_SECRETS_VALUES_ALLOW_ABSOLUTE_PATH=false \
    HELM_SECRETS_VALUES_ALLOW_PATH_TRAVERSAL=false \
    HELM_SECRETS_WRAPPER_ENABLED=false

USER root

# Install requirements
RUN apt-get update \
    && apt-get install --no-install-recommends -y curl gnupg

# Install SOPS
RUN curl -LO https://github.com/getsops/sops/releases/download/v${SOPS_VERSION}/sops-v${SOPS_VERSION}.linux.amd64 \
    && mv sops-v${SOPS_VERSION}.linux.amd64 /usr/local/bin/sops \
    && chmod +x /usr/local/bin/sops

# Install vals
RUN curl -LO https://github.com/helmfile/vals/releases/download/v${VALS_VERSION}/vals_${VALS_VERSION}_linux_amd64.tar.gz \
    && tar -xvf vals_${VALS_VERSION}_linux_amd64.tar.gz \
    && mv vals /usr/local/bin/vals \
    && chmod +x /usr/local/bin/vals

# Install kubectl
RUN curl -LO https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl \
    && mv kubectl /usr/local/bin/kubectl \
    && chmod +x /usr/local/bin/kubectl

# Prepare helm-secrets
RUN ln -sf "$(helm env HELM_PLUGINS)/helm-secrets/scripts/wrapper/helm.sh" /usr/local/sbin/helm

# Override the default kustomize executable with the Go built version
COPY --from=ksops-builder /usr/local/bin/kustomize /usr/local/bin/kustomize

# Add ksops executable to path
COPY --from=ksops-builder /usr/local/bin/ksops /usr/local/bin/ksops

# Cleanup
RUN apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

USER $ARGOCD_USER_ID

# Install helm-secrets
RUN helm plugin install --version ${HELM_SECRETS_VERSION} https://github.com/jkroepke/helm-secrets
