cd /vagrant/vagrant/Manifests

# Namespace
sudo kubectl apply -f namespace.yaml

# DBs
sudo kubectl apply -f inventory-db-secret.yaml
sudo kubectl apply -f inventory-db-statefulset.yaml
sudo kubectl apply -f billing-db-secret.yaml
sudo kubectl apply -f billing-db-statefulset.yaml

# RabbitMQ
sudo kubectl apply -f rabbitmq-secret.yaml
sudo kubectl apply -f rabbitmq-deployment.yaml

# Apps
sudo kubectl apply -f inventory-app.yaml
sudo kubectl apply -f billing-app.yaml
sudo kubectl apply -f api-gateway-app.yaml
