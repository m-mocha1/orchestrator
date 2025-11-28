5. Summary of useful commands for you
# list pods
```bash
kubectl get pods -n movie-platform
```
# gateway logs
```bash
kubectl logs -n movie-platform deploy/api-gateway-app --tail=50 -f
```
# inventory API logs
```bash
kubectl logs -n movie-platform deploy/inventory-app --tail=50 -f
```
# inventory DB logs (adjust pod name)
```bash
kubectl logs -n movie-platform inventory-db-0 --tail=50 -f
```
# to check the Image v 
```bash
sudo kubectl describe deploy api-gateway-app -n movie-platform | grep -i image
```
# to stop a pod (change billing-app to pod name)
```bash
sudo kubectl scale statefulset billing-app -n movie-platform --replicas=1
```
# to run it again (change billing-app to pod name)
```bash
sudo kubectl scale statefulset billing-app -n movie-platform --replicas=1
```
# to check running pods (change billing-app to pod name)
```bash
sudo kubectl get pods -n movie-platform -l app=billing-app
```

# to expose rabbitMQ 
```bash 
sudo kubectl port-forward -n movie-platform svc/rabbitmq \
  --address 0.0.0.0 15672:15672
```
- on mac go to 
http://192.168.56.10:15672