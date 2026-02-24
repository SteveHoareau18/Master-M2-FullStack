Exécuter en DEV
```bash
bash build.sh
docker compose --env-file .env -f dev.docker-compose.yml up -d --build
```

Scan des vulnérabilités des images
```bash
bash trivy-scan.sh
```