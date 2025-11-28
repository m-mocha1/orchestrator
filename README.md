# Movie Platform – Kubernetes Microservices on K3s

This project deploys a small microservices architecture on a **K3s** cluster running inside **Vagrant** VMs.

Services:

- **inventory-db** – PostgreSQL database for movies (StatefulSet + PVC).
- **billing-db** – PostgreSQL database for orders (StatefulSet + PVC).
- **inventory-app** – Node.js API (GET/POST `/api/movies`) backed by `inventory-db`.
- **billing-app** – Node.js worker that consumes messages from RabbitMQ and inserts into `orders` in `billing-db` (StatefulSet).
- **rabbitmq** – RabbitMQ broker with management UI.
- **api-gateway-app** – Node.js gateway that:
  - Exposes `/api/movies` (proxy to inventory-app + sends a message to RabbitMQ).
  - Exposes `/api/billing` (publishes orders to RabbitMQ).
  - Is reachable from the host via NodePort.

`Scripts/orchestrator.sh` automates cluster creation and management.

---

## 1. Architecture Overview

### 1.1 Logical Architecture

```text
          +-----------------------------+
          |        api-gateway-app      |
          |  Node.js + http-proxy      |
          |  - /api/movies             |
          |  - /api/billing            |
          +--------------+-------------+
                         |
              HTTP (ClusterIP Services)
                         |
     +-------------------+-------------------+
     |                                       |
+----v----------------+            +---------v---------+
|    inventory-app    |            |    billing-app    |
|  (Deployment + HPA) |            |   (StatefulSet)   |
|  - GET/POST /api/movies         |  - consumes queue  |
+----+-----------------+          +---------+----------+
     |                                       |
 HTTP|                                       |RabbitMQ
     |                      +----------------v-----------+
     |                      |         rabbitmq           |
     |                      |  - billing-queue (durable) |
     |                      +----------------------------+
     |                                  |
     |                                  |
+----v-------------------+    +---------v----------------+
|     inventory-db       |    |       billing-db         |
| PostgreSQL (StatefulSet|    | PostgreSQL (StatefulSet) |
| + PVC)                 |    | + PVC)                   |
+------------------------+    +-------------------------+


1.2 K3s Cluster & Networking

Vagrant VMs:

k3s-master – control-plane node – 192.168.56.10

k3s-agent1 – worker node – 192.168.56.11

K3s cluster uses the private network interface (enp0s9) for pod networking (flannel).

2. Prerequisites

On your host machine (Mac):

VirtualBox

Vagrant

kubectl (optional but useful on the host; required inside the master VM)

A Docker Hub account (images are pushed as admary/<image-name> in this project)

3. Project Structure

```text
.
├── Manifests/          # All Kubernetes YAML manifests
│   ├── namespace.yaml
│   ├── inventory-db-secret.yaml
│   ├── inventory-db-statefulset.yaml
│   ├── billing-db-secret.yaml
│   ├── billing-db-statefulset.yaml
│   ├── rabbitmq-secret.yaml
│   ├── rabbitmq-deployment.yaml
│   ├── inventory-app.yaml
│   ├── billing-app.yaml
│   └── api-gateway-app.yaml
├── Scripts/
│   └── orchestrator.sh # create/start/stop the whole cluster
├── Dockerfiles/        # (optional) Dockerfiles for each service
├── Vagrantfile
├── k3s.yaml            # kubeconfig copied from master
└── README.md

```

inside the VMs this project is mounted at /vagrant (and /vagrant/vagrant in our setup).

4. Docker Images

Images are stored on Docker Hub under the user admary:

admary/inventory-app:latest

admary/billing-app:latest

admary/api-gateway-app:latest

If you want to rebuild them from source:
```bash
# inventory-app
cd inventory-app
docker build -t admary/inventory-app:latest .
docker push admary/inventory-app:latest

# billing-app
cd billing-app
docker build -t admary/billing-app:latest .
docker push admary/billing-app:latest

# api-gateway-app
cd api-gateway-app
docker build -t admary/api-gateway-app:latest .
docker push admary/api-gateway-app:latest
```