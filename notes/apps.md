5. Summary of useful commands for you
# list pods
kubectl get pods -n movie-platform

# gateway logs
kubectl logs -n movie-platform deploy/api-gateway-app --tail=50 -f

# inventory API logs
kubectl logs -n movie-platform deploy/inventory-app --tail=50 -f

# inventory DB logs (adjust pod name)
kubectl logs -n movie-platform inventory-db-0 --tail=50 -f

# to check the Image v 
sudo kubectl describe deploy api-gateway-app -n movie-platform | grep -i image