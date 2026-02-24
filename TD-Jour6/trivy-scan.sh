echo "Scanning frontend..."
docker run -v /var/run/docker.sock:/var/run/docker.sock -v $HOME/Library/Caches:/root/.cache/ aquasec/trivy:0.69.1 image \
  --skip-dirs /root/.npm/_cacache \
  --format json \
  td-jour6-cloudshop-frontend:latest \
  | jq '[.Results[].Vulnerabilities[]?.Severity] | group_by(.) | map({Severity: .[0], Count: length})'

echo "Scanning api-gateway..."
docker run -v /var/run/docker.sock:/var/run/docker.sock -v $HOME/Library/Caches:/root/.cache/ aquasec/trivy:0.69.1 image \
  --format json \
  td-jour6-cloudshop-api-gateway:latest \
  | jq '[.Results[].Vulnerabilities[]?.Severity] | group_by(.) | map({Severity: .[0], Count: length})'

echo "Scanning orders-api..."
docker run -v /var/run/docker.sock:/var/run/docker.sock -v $HOME/Library/Caches:/root/.cache/ aquasec/trivy:0.69.1 image \
  --format json \
  td-jour6-cloudshop-orders-api:latest \
  | jq '[.Results[].Vulnerabilities[]?.Severity] | group_by(.) | map({Severity: .[0], Count: length})'

echo "Scanning products-api..."
docker run -v /var/run/docker.sock:/var/run/docker.sock -v $HOME/Library/Caches:/root/.cache/ aquasec/trivy:0.69.1 image \
  --format json \
  td-jour6-cloudshop-products-api:latest \
  | jq '[.Results[].Vulnerabilities[]?.Severity] | group_by(.) | map({Severity: .[0], Count: length})'

echo "Scanning auth-service..."
docker run -v /var/run/docker.sock:/var/run/docker.sock -v $HOME/Library/Caches:/root/.cache/ aquasec/trivy:0.69.1 image \
  --format json \
  td-jour6-cloudshop-auth-service:latest \
  | jq '[.Results[].Vulnerabilities[]?.Severity] | group_by(.) | map({Severity: .[0], Count: length})'

echo "Scanning postgres..."
docker run -v /var/run/docker.sock:/var/run/docker.sock -v $HOME/Library/Caches:/root/.cache/ aquasec/trivy:0.69.1 image \
  --format json \
  postgres:17-alpine \
  | jq '[.Results[].Vulnerabilities[]?.Severity] | group_by(.) | map({Severity: .[0], Count: length})'