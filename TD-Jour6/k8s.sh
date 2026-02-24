kubectl apply -f k8s/namespaces/
kubectl apply -f k8s/configs/secrets/ 
kubectl apply -f k8s/configs/configmaps/
kubectl apply -f k8s/statefulsets/ 
kubectl wait --for=condition=ready pod -l app=postgres -n cloudshop-prod --timeout=120s
kubectl apply -f k8s/deployments/
kubectl apply -f k8s/services/
kubectl apply -f k8s/ingress/
kubectl get pods -n cloudshop-prod