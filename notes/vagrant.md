- Uses 'cloudicio/ubuntu-server' as the base box for both VMs. 
- syncs your project directory to /vagrant inside both VMs.

## k3s-master:
- ip : 192.168.56.10
- installs k3s server.
- writes the node token to ```/vagrant/node-token```
- Copies kubeconfig to /vagrant/k3s.yaml (so you can later use kubectl from your host).

## k3s-agent1:
- ip 192.168.56.11
- writes for ```/vagrant/node-token```
- installs K3s agent using:
  1. K3S_URL=https://192.168.56.10:6443
  2. K3S_TOKEN=<content of node-token>
- joines the cluster 
- The shared folder /vagrant is visible to both VMs and your host, so you can pass the token and kubeconfig easily.

## how to bring the cluster up
- start master first
```bash
vagrant up k3s-master
```

- start agent
```bash
vagrant up k3s-agent1
``` 

- check cluster from master VM:
```bash
vagrant ssh k3s-master
# inside VM:
kubectl get nodes
```
