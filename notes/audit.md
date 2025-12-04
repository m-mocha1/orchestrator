# 1. How do Pods communicate across nodes?

- pods comunicate across nodes using the k3s network model 
which give each pod an ip and all the pods are reachable from all nodes 
thers no NAT(allow local devices to share 1 ip to access the internet) between pods 

# What is container orchestration, and what are its benefits?
- is an autamted management of many containers 
- benefits 
1. auto deploy
2. auto restart and heeling 
3. load balancing
4. networking between services 
5. persistent storage and secrets mangment

# 3. What is Kubernetes, and what is its main role?
 - automaticlly manage ,run ,scale, heal containerized apps across multiple machines.

 # 4. What is K3s, and what is its main role?
- k3s is a lighweight k dist created to provide full kubernetes expereince with low resource usage and simple installation.

# 5. What is Infrastructure as Code (IaC)? What are its advantages? 
Infrastructure as Code means defining servers, networks, clusters, databases, etc. using code files instead of doing it manually.
1. Repeatable and consistent environment setup
2. Automation → less human error
3. Easy to rebuild an entire environment
4. Faster deployments
5. Better collaboration between teams

# 6. Explain what a K8s manifest is.
A Kubernetes manifest is a YAML file that describes what should the  Kubernetes object look like. 

Example :Deployment, pvc , secret , namesapce

Kubernetes reads the file and creates/updates resources to match what the manifest says.

# 7. Explain each K8s manifest (main ones).
- Namespace : group to organize and isoloate
- Deployment : handle repiclas rolling update and self-healing


# 8. What is a StatefulSet in K8s?
- manages stateful apps like databases it uses ordered startUP and Shutdown and stable storage pre pod.

# 9. What is a Deployment in K8s?
Deployment manages stateless applications.
1. replicas(scaling)
2. roliing updates 
3. auto-restart if pod failed 

#  10. What is the difference between Deployment and StatefulSet?
  | Feature      | Deployment                       | StatefulSet                                       |
| ------------ | -------------------------------- | ------------------------------------------------- |
| Use case     | Stateless apps (APIs, frontends) | Stateful apps (DBs, queues)                       |
| Pod identity | All pods identical               | Each pod has a fixed identity (pod-0, pod-1)      |
| Storage      | Volumes NOT tied to pod identity | Each pod gets its own persistent volume           |
| Network name | Random                           | Predictable DNS: `pod-0.service`, `pod-1.service` |
| Scaling      | Simple                           | Ordered, careful scaling                          |

# 11. What is scaling, and why do we use it?
it means increasing and decreasing the number of running pods.
1. handle more traffic
2. reduce cost 
3. improve reliabilty(multiple replicas)

# 12. What is a load balancer, and what is its role?
A load balancer distributes incoming traffic across multiple pods or servers.
u know the rest

# 13. Why don’t we put the database as a Deployment?
- Because a Deployment is stateless, but a database is stateful.

# 14. all k8s components 


```pgsql
KUBERNETES
│
├── CONTROL PLANE (Master)
│   │
│   ├── kube-apiserver
│   │     └── Entry point, validates manifests, exposes API
│   │
│   ├── etcd
│   │     └── Key-value store for cluster state
│   │
│   ├── kube-scheduler
│   │     └── Places Pods on nodes based on resources & rules
│   │
│   ├── kube-controller-manager
│   │     ├── Deployment Controller
│   │     ├── Node Controller
│   │     ├── Job/CronJob Controller Runs a task once and completes.
│   │     └── Replication Controller
│   │
│   └── cloud-controller-manager (optional)
│         └── Integrates with cloud load balancers, volumes, routing
│
├── WORKER NODE
│   │
│   ├── kubelet
│   │     └── Runs containers, reports status to API server
│   │
│   ├── kube-proxy
│   │     └── Handles Service networking + load balancing
│   │
│   └── Container Runtime this is what pull the docker image and run them and mange them 
│         ├── containerd
│         ├── CRI-O
│         └── Docker (deprecated)
│
├── NETWORKING
│   │   without cni plugin pods have not network
│   ├── CNI Plugin assign ip to pods and create routes so pods across nodes can commuincate 
│   │     ├── Flannel 
│   │     ├── Calico
│   │     ├── Cilium
│   │     └── Weave
│   │
│   └── CoreDNS
│         └── Internal DNS for Services & Pods
│
├── STORAGE
│   │
│   ├── PV (PersistentVolume) real storage(disk)
│   ├── PVC (PersistentVolumeClaim) a request for storage from a pod
│   └── StorageClass define how PVs are created dynamicly
│
├── WORKLOADS (API Objects)
│   │
│   ├── Pod
│   │     └── Smallest compute unit; holds containers
│   │
│   ├── Deployment
│   │     └── For stateless apps; scaling, rolling updates
│   │
│   ├── StatefulSet
│   │     └── For databases; stable ID + storage
│   │
│   ├── DaemonSet
│   │     └── Runs one pod on every node (e.g., log agent)
│   │
│   ├── Job
│   │     └── Run once
│   │
│   └── CronJob
│         └── Scheduled tasks
│
├── NETWORK API OBJECTS
│   │
│   ├── Service
│   │     ├── ClusterIP
│   │     ├── NodePort
│   │     ├── LoadBalancer
│   │     └── Headless
│   │
│   └── Ingress Roles expose wep apps, handels routing
│         └── HTTP routing, domains, SSL(SSL (Secure Sockets Layer) is a security protocol    |that establishes an encrypted link between a web server and a browser)
|  
│
└── CONFIGURATION RESOURCES
    │
    ├── ConfigMap
    │     └── App configuration (non-secret)
    │
    ├── Secret
    │     └── Passwords, tokens, certificates
    │
    └── Namespace
          └── Logical grouping + isolation

```

## kube-api-server :
1. entery poing for all comands kubectl 
2. validate YAML manifests 
3. store cluster state in etcd 
4. exposes k8s API (is accessible over the network to users can read, update, deleting)

## etcd
- the database of k8s sotore all cluster dataand deployment, secrets, nodes, events
- if etc dies the cluster loses it's configs state

## kube-scheduler
- decide where pods run 
- assigns Pods to worker nodes based on resourse needs 

## kube-controller-manager
- Runs different controllers that ensure cluster state matches the desired state
- Automatically fixes the cluster when something changes or breaks.
### 1.Deployment controller
- Ensures the correct number of Pods are running.
### 2. Node controller
- Watches node health, marks nodes as “NotReady”.
### 3. Replication controller
- Ensures replica counts.
### 4. Endpoint controller
- Manages endpoints for Services.
### 5. Job/CronJob controller
- Manages scheduled tasks.
# extra 
-  Metrics Server
Collects CPU/memory metrics for autoscaling.

* DNS (CoreDNS)
Internal DNS service:
Resolves service-name.namespace.svc.cluster.local

- Dashboard
Optional web UI.

