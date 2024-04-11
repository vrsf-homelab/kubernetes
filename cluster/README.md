# VRS-Factory K8s Cluster

## Cluster setup

TODO

## Core services

### MetalLB

```bash
kubectl apply -f ./metallb/helm.release.yml
kubectl apply -f ./metallb/ip-address-pool.yml
kubectl apply -f ./metallb/l2-advertisement.yml
```

### ArgoCD

```bash
kubectl apply -f ./argocd/helm.release.yml
```

### cert-manager

```bash
kubectl apply -f ./cert-manager/secret.yml
kubectl apply -f ./cert-manager/helm.release.yml
kubectl apply -f ./cert-manager/cluster-issuer.yml
```
