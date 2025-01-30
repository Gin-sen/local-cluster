# Ansible local setup

Prerequisites:
- Linux or WSL
- Python (dont `python3.12-venv`)

Activate virtal environment and install Ansible:
```bash
python3 -m venv .virtualenv
source .virtualenv/bin/activate
python3 -m pip install --upgrade pip
python3 -m pip install ansible
python3 -m pip install ansible-dev-tools
ansible --version
ansible-community --version
```

# Kind and Istio setup


- Please use the latest Go version.
- To use kind, you will also need to install docker.
- [Install the latest version of kind](https://kind.sigs.k8s.io/docs/user/quick-start/).
- [Increase Docker’s memory limit](https://istio.io/latest/docs/setup/platform-setup/docker/).

## Install Istio on Docker Desktop

```bash
helm repo add istio https://istio-release.storage.googleapis.com/charts
helm repo update

helm install istio-base istio/base -n istio-system --set defaultRevision=default --create-namespace
helm install istiod istio/istiod -n istio-system --wait
```

## Kubernetes dashboard

```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml
kubectl create serviceaccount -n kubernetes-dashboard admin-user
kubectl create clusterrolebinding -n kubernetes-dashboard admin-user --clusterrole cluster-admin --serviceaccount=kubernetes-dashboard:admin-user
kubectl label namespace kubernetes-dashboard istio-injection=enabled

kubectl patch deployment kubernetes-dashboard -n kubernetes-dashboard -p '{ "spec": { "template": { "metadata": { "annotations": { "proxy.istio.io/config": "{ \"holdApplicationUntilProxyStarts\": true }" } } } } }'
kubectl rollout restart deployment dashboard-metrics-scraper kubernetes-dashboard
token=$(kubectl -n kubernetes-dashboard create token admin-user)
echo $token
kubectl proxy
```

[localhost dashboard](http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy)


## Install Prometheus
https://github.com/prometheus-community/helm-charts/blob/main/charts/kube-prometheus-stack/README.md

kubectl create ns monitoring
kubectl label ns monitoring istio-injection=enabled
helm install kube-prometheus-stack prometheus-community/kube-prometheus-stack -n monitoring


## Install MetlalLB
```bash
helm repo add metallb https://metallb.github.io/metallb
helm install metallb metallb/metallb -f metallb.yaml -n metallb-system

# helm install metallb metallb/metallb -f metallb.yaml -n metallb-system

kubectl label ns metallb-system pod-security.kubernetes.io/audit=privileged
kubectl label ns metallb-system pod-security.kubernetes.io/enforce=privileged
kubectl label ns metallb-system pod-security.kubernetes.io/warn=privileged

```

## Install a shared gateway

kubectl create namespace istio-ingress
helm install istio-ingressgateway istio/gateway -n istio-ingress

