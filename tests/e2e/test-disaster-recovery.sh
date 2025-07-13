#!/bin/bash

set -e

echo "🧪 Testing full disaster recovery..."

# Create test environment
kubectl create namespace e2e-disaster-recovery || true

# Deploy test applications
kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: test-app
  namespace: e2e-disaster-recovery
spec:
  replicas: 1
  selector:
    matchLabels:
      app: test-app
  template:
    metadata:
      labels:
        app: test-app
    spec:
      containers:
      - name: test-app
        image: nginx:latest
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: test-app-service
  namespace: e2e-disaster-recovery
spec:
  selector:
    app: test-app
  ports:
  - port: 80
    targetPort: 80
