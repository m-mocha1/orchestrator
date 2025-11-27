# Orchestrator Script Usage

This document explains how to use the `orchestrator.sh` script to manage your Kubernetes microservices cluster deployed with K3s through Vagrant.

## Available Commands

### 1. Create the Cluster

```
./Scripts/orchestrator.sh create
```

This will:
- Start the required VMs (`k3s-master` and `k3s-agent1`)
- Apply all Kubernetes manifests automatically:
  - Namespace
  - Database secrets and StatefulSets
  - RabbitMQ secret and Deployment
  - Application Deployments, Services, and HPAs
- Show running pods in the `movie-platform` namespace.

### 2. Start the Cluster

```
./Scripts/orchestrator.sh start
```

This will:
- Start the VMs if they are halted
- Show cluster health: nodes and pods

### 3. Stop the Cluster

```
./Scripts/orchestrator.sh stop
```

This will:
- Halt both VMs cleanly

---

## Notes

- Ensure your manifests are in the correct synced folder path that the script expects (`/vagrant/vagrant/Manifests` inside the VM).
- You may modify this path inside the script depending on your project structure.
- Table creation is **not automated**, but the required SQL is documented in your main README.

