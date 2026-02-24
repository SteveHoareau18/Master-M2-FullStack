kubectl apply -f k8s/namespaces/
kubectl apply -f k8s/configs/secrets/ 
kubectl apply -f k8s/configs/configmaps/
kubectl apply -f k8s/statefulsets/ 
kubectl wait --for=condition=ready pod -l app=postgres -n cloudshop-prod --timeout=120s
kubectl apply -f k8s/deployments/
kubectl apply -f k8s/services/
kubectl apply -f k8s/ingress/
kubectl get pods -n cloudshop-prod
kubectl apply -f k8s/ingress/argocd-ingress.yaml
kubectl apply -f argocd/apps/infrastructure.yaml
kubectl apply -f argocd/apps/database.yaml
kubectl apply -f argocd/apps/backend.yaml
kubectl apply -f argocd/apps/frontend.yaml
kubectl apply -f monitoring/servicemonitors/