```shell
export VAULT_K8S_NAMESPACE="vault-system" \
export VAULT_HELM_RELEASE_NAME="vault" \
export VAULT_SERVICE_NAME="vault-internal" \
export K8S_CLUSTER_NAME="cluster.local" \
export WORKDIR=~/Workspace/vrsf-homelab/kubernetes/.local-data/vault
```

```shell
openssl genrsa -out ${WORKDIR}/vault.key 2048

cat > ${WORKDIR}/vault-csr.conf <<EOF
[req]
default_bits = 2048
prompt = no
encrypt_key = yes
default_md = sha256
distinguished_name = kubelet_serving
req_extensions = v3_req
[ kubelet_serving ]
O = system:nodes
CN = system:node:*.${VAULT_K8S_NAMESPACE}.svc.${K8S_CLUSTER_NAME}
[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth, clientAuth
subjectAltName = @alt_names
[alt_names]
DNS.1 = *.${VAULT_SERVICE_NAME}
DNS.2 = *.${VAULT_SERVICE_NAME}.${VAULT_K8S_NAMESPACE}.svc.${K8S_CLUSTER_NAME}
DNS.3 = *.${VAULT_K8S_NAMESPACE}
DNS.4 = *.${VAULT_SERVICE_NAME}.svc
DNS.5 = vault.vrsf.in
IP.1 = 127.0.0.1
EOF

openssl req -new -key ${WORKDIR}/vault.key -out ${WORKDIR}/vault.csr -config ${WORKDIR}/vault-csr.conf

cat > ${WORKDIR}/csr.yaml <<EOF
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
   name: vault.svc
spec:
   signerName: kubernetes.io/kubelet-serving
   expirationSeconds: 8640000
   request: $(cat ${WORKDIR}/vault.csr|base64|tr -d '\n')
   usages:
   - digital signature
   - key encipherment
   - server auth
EOF

kubectl create -f ${WORKDIR}/csr.yaml

kubectl certificate approve vault.svc

kubectl get csr vault.svc -o jsonpath='{.status.certificate}' | openssl base64 -d -A -out ${WORKDIR}/vault.crt

kubectl config view --raw --minify --flatten -o jsonpath='{.clusters[].cluster.certificate-authority-data}' | base64 -d > ${WORKDIR}/vault.ca

kubectl create namespace $VAULT_K8S_NAMESPACE

kubectl create secret generic vault-ha-tls -n $VAULT_K8S_NAMESPACE --from-file=vault.key=${WORKDIR}/vault.key --from-file=vault.crt=${WORKDIR}/vault.crt --from-file=vault.ca=${WORKDIR}/vault.ca
```

Setup cluster

```shell
kustomize build --enable-helm --enable-alpha-plugins --enable-exec . | kubectl apply -f -

kubectl exec -n $VAULT_K8S_NAMESPACE vault-0 -- vault operator init -key-shares=1 -key-threshold=1 -format=json > ${WORKDIR}/cluster-keys.json

VAULT_UNSEAL_KEY=$(jq -r ".unseal_keys_b64[]" ${WORKDIR}/cluster-keys.json)

kubectl exec -n $VAULT_K8S_NAMESPACE vault-0 -- vault operator unseal $VAULT_UNSEAL_KEY
```
