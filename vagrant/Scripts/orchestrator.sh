#!/usr/bin/env bash

set -euo pipefail

ACTION="${1:-}"

if [ -z "$ACTION" ]; then
  echo "Usage: $0 {create|start|stop}"
  exit 1
fi

# Helper to run commands on the master VM
run_on_master() {
  vagrant ssh k3s-master -c "$1"
}

case "$ACTION" in
  create)
    echo "[orchestrator] Bringing up VMs..."
    vagrant up k3s-master
    vagrant up k3s-agent1

    echo "[orchestrator] Applying Kubernetes manifests on master..."
    # Adjust the path /vagrant/vagrant/Manifests if your synced folder path is different
    vagrant ssh k3s-master << 'EOF'
set -e
cd /vagrant/vagrant/Manifests

# Namespace
sudo kubectl apply -f namespace.yaml

# Databases
sudo kubectl apply -f inventory-db-secret.yaml
sudo kubectl apply -f inventory-db-statefulset.yaml

sudo kubectl apply -f billing-db-secret.yaml
sudo kubectl apply -f billing-db-statefulset.yaml

# RabbitMQ
sudo kubectl apply -f rabbitmq-secret.yaml
sudo kubectl apply -f rabbitmq-deployment.yaml

# Applications
sudo kubectl apply -f inventory-app.yaml
sudo kubectl apply -f billing-app.yaml
sudo kubectl apply -f api-gateway-app.yaml

echo "[master] Current pods in movie-platform namespace:"
sudo kubectl get pods -n movie-platform -o wide
EOF

    echo "cluster created"
    ;;

  start)
    echo "[orchestrator] Starting existing VMs..."
    vagrant up k3s-master
    vagrant up k3s-agent1

    echo "[orchestrator] Checking cluster status..."
    vagrant ssh k3s-master -c "sudo kubectl get nodes -o wide && sudo kubectl get pods -n movie-platform -o wide"

    echo "cluster started"
    ;;

  stop)
    echo "[orchestrator] Halting VMs..."
    vagrant halt k3s-agent1 || true
    vagrant halt k3s-master || true

    echo "cluster stopped"
    ;;

  *)
    echo "Unknown action: $ACTION"
    echo "Usage: $0 {create|start|stop}"
    exit 1
    ;;
esac
