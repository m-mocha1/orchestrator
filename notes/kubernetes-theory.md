# what i need to know for this project.
- kubernetes is like a smart docker-compose + autoscaler + load balancer for many machines.
-key words
1. Cluser : a group of machines managed by kubernetes.
2. Node : one machine in the cluster(VM, server).

- in this project we have 2 vm
 1. master (control plane) decide where to run things.
 2. agent (worker) runs your container

- we are using K3s which is a lightweight kubernetes distribution (same but lighter and faster)

- Command-line tool: 
 * kubectl: CLI to talk to the cluster.
```bash
    # see machines
    kubectl get nodes 
    
    # see running containers in kubernetes
    kubectl get pods
```


# Pod, deployment, StatefulSet
### Pod 
 * smallest unit in kubernetes 
 * usually: 1 container = 1 pod (a pod running inv-app and another one for bil-app, etc)
 * pods die and recreated all happens automaticly
### Deployment 
 * keep n repicas of this pod running if a pod dies deplyment create it again.
 * used for inv-app and api-gateway-app deployment and auto scaling
### StatefulSet
* keep stable storage used for databases inv-db and bil-db and the billing-app
* works well with something called PVC to store DB files.
### Service (network inside the cluster)
- Pods get random IPs; they change if pods restart. To reach an app, you create a Service:
* Service (ClusterIP):
* Stable DNS name inside the cluster.
- Example:
* Service name: inventory-app  Other apps can call: http://inventory-app:8080
- You will have Services for:
1. inventory-app (port 8080).
2. billing-app (port 8080).
3. api-gateway-app (port 3000).
4. inventory-database (port 5432).
5. billing-database (port 5432).
6. rabbitmq (port 5672).

# Ingress (entry from outside world)
* Inside cluster, Services are fine. To expose HTTP to the outside (your browser, Postman):

*  Ingress:Takes incoming HTTP from outside.
* Routes to a Service.
* Example: /api/ → api-gateway-app Service on port 3000.

In K3s, Traefik is usually already there as an Ingress controller, so you just define an Ingress YAML.

# Volumes
* DB data must not disappear when pod restarts. You use:
PersistentVolume (PV): actual disk.
* PersistentVolumeClaim (PVC): “I need a disk of size X” request.
* The StatefulSet of PostgreSQL uses PVC so data persists.

# HorizontalPodAutoscaler (HPA)
* For inventory-app and api-gateway-app:
* HPA automatically changes the number of pod replicas based on CPU usage.

* Config: 
 1. minReplicas: 1
 2. maxReplicas: 3
 3. target CPU: 60%
* So when CPU > 60%, it adds pods up to 3; when low, it scales down to 1.

