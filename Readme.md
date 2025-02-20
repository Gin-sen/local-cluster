# Kind kubernetes cluster

- 3 control planes nodes plus one load balancer for the control plane
- 4 worker nodes with one working as a gateway
- Istio (with the ingress gateway in NodePort, maybe MetalLB or the kind LB exec are the solutions)
- Kiali (need some tuning)
- Prometheus (some alerts to fix/mask)
- Grafana (need to test some dashbaords)

TODOS:
- Getting familiar with local storage
- Vault
- Jenkins
- ArgoCD ou Flux
- Grafana Tempo ou Jaeger
- Opentelemetry

## Ansible local setup

Prerequisites:

- WSL only (Linux incoming)
- Python (with `venv`)
- Docker (can't automate with WSL)
- Kubectl (can't automate with WSL)
- The latest Go version for Kind (TODO: automate ?)
- Helm (TODO: automate ?)

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

## Useful links

- [Install the latest version of kind](https://kind.sigs.k8s.io/docs/user/quick-start/).
- [Increase Docker’s memory limit](https://istio.io/latest/docs/setup/platform-setup/docker/).

## Helm setup

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add istio https://istio-release.storage.googleapis.com/charts
helm repo add kiali https://kiali.org/helm-charts
helm repo update
```

## Run the playbook

Customize your .wslconfig path in the `ansible/inventory/host_vars/localhost.yml` file:

```yaml
wslconfig_file: /mnt/c/Users/<your.user>/.wslconfig
wslconfig_tmp_file: /mnt/c/Users/<your.user>/.wslconfig.tmp
```

Then run those commands:

```bash
cd ansible
ansible-playbook site.yml
```

To delete the cluster: `kind delete clusters istio-testing`

## Urls

| Service | Url | Monitoring | Namespace |
| ------- | --- | ---------- | --------- |
| Prometheus | http://prometheus.mainframe.local | url grafana | monitoring |
| Grafana | http://grafana.mainframe.local | Monitoring | monitoring |
| Kiali | http://kiali.mainframe.local | Monitoring | istio-system |

## Hosts

```txt
# local-cluster
127.0.0.1 prometheus.mainframe.local
127.0.0.1 grafana.mainframe.local
127.0.0.1 kiali.mainframe.local
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
