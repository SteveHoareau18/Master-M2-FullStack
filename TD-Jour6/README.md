Exécuter en DEV
```bash
bash build.sh
docker compose --env-file .env -f dev.docker-compose.yml up -d --build
```

Scan des vulnérabilités des images
```bash
bash trivy-scan.sh
```

Exécuter en PROD
```bash
bash build.sh
kind create cluster --config=kind-config.yaml
bash kind-load.sh
bash k8s.sh
```

Vérifier que tout est lancé
```bash
kubectl get pods -n cloudshop-prod
kubectl get ingress -n argocd
```