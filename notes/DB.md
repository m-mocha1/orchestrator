# what we did in the project
## this project require two postgresSQL databases (statefulSets+ PVCs)
-  RabbitMQ (Deployment of StatefulSet + Service + Secret)

- Three apps : 
 1. inv-db(Deplotment + HPA) 
 2. bil-app(StatefulSet)
 3. api-gateway-app(Deployment + HBA)  
 4. DB credentials, Rabbit credentials
 5. image from Docker Hub 

## Create your first real component: inventory-database|
This is required in your project scope:
- Must be a StatefulSet
- Must have a PersistentVolumeClaim
- Must store credentials in Secrets
- Must be accessible on port 5432

# Step-by-Step
### first we created a namespace for microservices.
### why? 
- this sepreate and organize resources inside the cluster
so the names isn't confilcted with every service. 
- we applay it by

```bash
kubectl apply -f namespace.yaml
```

### Secret: inventory-db credentials
- on k3s-master
- we create the inventory-db-secret.yaml in the manifests
 1. this to store the db creditnals like
  POSTGRES_DB: inventory_db
  POSTGRES_USER: inventory_user
  POSTGRES_PASSWORD: supersecretpassword

- we applay it by
```bash
kubectl apply -f inventory-db-secret.yaml
```
 - check by 
 ```bash
 sudo kubectl get secrets -n movie-platform
 ```
 You should see inventory-db-secret


### Service + StatefulSet for inventory-db
- now we create one file that contains:
- Still in /vagrant/vagrant/Manifests:
- inventory-db-statefulset.yaml
 * Headless Service inventory-db (for the StatefulSet)
 * StatefulSet inventory-db using Postgres and a PVC
#### Explanation
* service :
clusterIP: None → headless. Required so StatefulSet can give stable DNS like inventory-db-0.inventory-db.movie-platform.svc.cluster.local.
Port 5432: DB port.

* StatefulSet:
replicas: 1 → one Postgres instance.
serviceName: inventory-db → links to the Service above.
volumeClaimTemplates → asks for a 1Gi PVC named data. K3s’s default StorageClass will create a PV on disk.
env uses the Secret.

```bash
kubectl apply -f inventory-db-statefulset.yaml
```
### to check if everything is running 
 - Check pods:

 ```bash
 sudo kubectl get pods -n movie-platform -o wide
 ```
You should see something like:
```text
NAME             READY   STATUS    RESTARTS   AGE   IP          NODE
inventory-db-0   1/1     Running   0          Xs    10.42.x.x   k3s-...
```

- Check service:
```bash 
sudo kubectl get svc -n movie-platform
```
You should see:
```text
NAME           TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)    AGE
inventory-db   ClusterIP   None         <none>        5432/TCP   Xs
```
CLUSTER-IP will be <none> because it’s headless.

- Check PVC:
```bash
sudo kubectl get pvc -n movie-platform
```
You should see
```text
NAME                   STATUS   VOLUME        CAPACITY   ACCESS MODES   STORAGECLASS   AGE
data-inventory-db-0    Bound    pvc-...      1Gi        RWO            local-path     Xs
```
- This confirms:
 StatefulSet created 
 PersistentVolumeClaim bound
 Postgres pod running with its own disk.

### how your apps will connect later 
- From any pod in movie-platform namespace, the DB host will be:
Service name: inventory-db
Port: 5432
- So later in inventory-app manifest, you’ll set:
DB_HOST=inventory-db
DB_PORT=5432
DB_USER / DB_PASSWORD / DB_NAME from Secret or ConfigMap.

# do the same for the billing-db

# Initialize databases
From k3s-master:

```bash
# temp client pod
sudo kubectl run pg-client -n movie-platform --rm -it --image=postgres:16 -- bash

# Inventory DB tables
PGPASSWORD=supersecretpassword psql -h inventory-db -U inventory_user -d inventory_db << 'SQL'
CREATE TABLE IF NOT EXISTS movies (
  id      SERIAL PRIMARY KEY,
  title   TEXT NOT NULL,
  year    INT,
  stock   INT NOT NULL DEFAULT 0
);
SQL

# Billing DB tables
PGPASSWORD=1234 psql -h billing-db -U m -d billing_db << 'SQL'
CREATE TABLE IF NOT EXISTS orders (
  id              SERIAL PRIMARY KEY,
  user_id         INT NOT NULL,
  number_of_items INT NOT NULL,
  total_amount    INT NOT NULL,
  created_at      TIMESTAMP NOT NULL DEFAULT NOW()
);
SQL
