# DevOps Technical Assessment - LocalStack + Terraform + Python API + Github Actions

## Overview

This project demonstrates a fully reproducible local DevOps environment where:

- Infrastructure is defined using **Terraform**
- AWS services (**S3 + SQS**) are simulated using **LocalStack**
- A **FastAPI application** interacts with S3
- Everything can run locally using **Docker Compose**
- Infrastructure is validated automatically using **GitHub Actions**

---

## Architecture

Flow:

1. File or JSON is uploaded to **S3**
2. S3 triggers a notification
3. A message is sent to **SQS**
4. The API can list objects stored in S3

---

## Requirements

- Docker
- Docker Compose
- Terraform
- Python 3.10+
- AWS CLI (optional)

---

# Quick Start (Recommended)

## 1. Start LocalStack

```bash
docker run -d -p 4566:4566 localstack/localstack
```

Check:

```bash
curl http://localhost:4566/health
```

---

## 2. Deploy Infrastructure

```bash
cd Terraform

terraform init
terraform apply -auto-approve
```

---

## 3. Run API

```bash
cd ../api

pip install -r requirements.txt
python -m uvicorn app:app --reload
```

API available at:

```
http://127.0.0.1:8000/docs
```

---

## 4. Test Full Flow (IMPORTANT)

### Upload file to S3

```bash
touch fichero.txt

aws --endpoint-url=http://localhost:4566 \
  s3 cp fichero.txt s3://my-s3-object-uploads/
```

---

### Read SQS messages

```bash
aws --endpoint-url=http://localhost:4566 \
  --region eu-west-1 \
  sqs receive-message \
  --queue-url http://sqs.eu-west-1.localhost.localstack.cloud:4566/000000000000/my-sqs-object-uploads
```

---

## 📡 API Endpoints

### GET /files

Lists objects in S3

- Returns objects if present
- Returns message if bucket is empty

---

### POST /upload

Uploads JSON data to S3

Example:

```json
{
  "name": "test",
  "value": 123
}
```

---
# Clean Environment (Recommended before Docker Compose)

Stop and remove previous containers:

```bash
docker-compose down -v
```

(Optional) Remove any running LocalStack containers:

```bash
docker rm -f $(docker ps -aq --filter "ancestor=localstack/localstack")
```

---

# Run with Docker Compose (Recommended alternative)

```bash
docker-compose up --build
```

This will start:

- LocalStack
- API container

---

# Destroy Infrastructure

```bash
cd Terraform
terraform destroy -auto-approve
```

---

# CI/CD

A GitHub Actions pipeline is included to validate infrastructure:

- terraform init
- terraform fmt -check
- terraform validate
- terraform plan

LocalStack is used to simulate AWS during CI execution.

---

# Notes

- No real AWS resources are used
- Terraform `plan` is used instead of `apply` in CI
- The system is fully local and reproducible

---

# Author

Daniel Arco