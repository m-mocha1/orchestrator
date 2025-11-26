## we well set rabbitMQ now 

- Goal: 
1. rabbitmq-secret (user/pass)
2. rabbitmq Service (5672, 15672)
3. rabbitmq Deployment (1 replica, using rabbitmq:3-management)
 
All in namespace movie-platform.

- Path we use: /vagrant/vagrant/Manifests.

## Secret: RabbitMQ credentials
- we create a file named rabbitmq-secret.yaml

- then we apply it 
```bash
sudo kubectl apply -f rabbitmq-secret.yaml
```
- then check it 
```bash
sudo kubectl get secrets -n movie-platform

```

## Service + Deployment for RabbitMQ
- we create a file called rabbitmq-deployment.yaml
that containes the service and Deployment configs

- notes :
1. Service name: rabbitmq
2. AMQP port: 5672 (for apps)
3. Management UI: 15672 (for you, if you port-forward later)
4. Env vars from rabbitmq-secret.

- apply it
```bash
sudo kubectl apply -f rabbitmq-deployment.yaml
```
- verify it 
```bash
sudo kubectl get pods -n movie-platform -o wide
``` 
- You should now see:
inventory-db-0
billing-db-0
rabbitmq-xxxxx-xxxxx

- services :
```bash
sudo kubectl get svc -n movie-platform
```
- you should see 
 1. inventory-db (headless)
 2. billing-db (headless)
 3. rabbitmq (ClusterIP, ports 5672/15672)

 