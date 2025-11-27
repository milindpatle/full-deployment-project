# NodeJS Monitoring Project (CI/CD + GitOps)

## Overview
This repo demonstrates a complete CI/CD + GitOps pipeline:
- Terraform creates infra (VPCs, EKS, Jenkins)
- Developer pushes code to GitHub
- Jenkins builds Docker image, pushes to ECR and updates manifests
- ArgoCD watches manifests and auto-deploys to EKS
- Prometheus + Grafana provide monitoring

## Replace placeholders
Before using, replace:
- `<AWS_ACCOUNT_ID>` with your AWS account id
- `<AWS_REGION>` with your region (e.g. ap-south-1)
- `<GITHUB_ORG>` with your GitHub org/user
- `<GIT_BRANCH>` with branch name (e.g. main)

## Quick local build test (app)
```bash
cd app
docker build -t nodejs-monitoring-app:local .
docker run -e APP_VERSION="local" -p 5000:5000 nodejs-monitoring-app:local
curl http://localhost:5000
