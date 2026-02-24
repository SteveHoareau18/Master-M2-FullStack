#!/bin/bash
set -e

echo "Loading images into Kind cluster..."

echo "Loading frontend image..."
kind load docker-image --name cloudshop td-jour6-cloudshop-frontend:latest

echo "Loading api-gateway image..."
kind load docker-image --name cloudshop td-jour6-cloudshop-api-gateway:latest

echo "Loading auth-service image..."
kind load docker-image --name cloudshop td-jour6-cloudshop-auth-service:latest

echo "Loading orders-api image..."
kind load docker-image --name cloudshop td-jour6-cloudshop-orders-api:latest

echo "Loading products-api image..."
kind load docker-image --name cloudshop td-jour6-cloudshop-products-api:latest

echo "Loading postgres image (public image, skipping if it fails)..."
kind load docker-image --name cloudshop postgres:15-alpine 2>/dev/null || echo "  ⚠ postgres:15-alpine pre-load failed (multi-platform issue). The kind node will pull it directly."

echo "All images loaded successfully!"