# DevOps Technical Assessment - LocalStack + Terraform + Python API

## 📌 Overview

This project builds a fully reproducible local environment using:

- **Terraform** → Infrastructure as Code (S3 + SQS)
- **LocalStack** → AWS services simulation
- **Python (FastAPI)** → API to interact with S3
- **Docker & Docker Compose** → Container orchestration
- **GitHub Actions** → CI pipeline for Terraform validation

---

## 🏗️ Infrastructure

The following resources are created using Terraform:

- 1 **S3 bucket**
- 1 **SQS queue**
- **S3 → SQS notification** when an object is uploaded

---

## ⚙️ Requirements

Make sure you have installed:

- Docker
- Docker Compose
- Terraform
- AWS CLI (optional but recommended)
- Python 3.10+

---

## 🚀 1. Start LocalStack

Run:

docker run -d -p 4566:4566 localstack/localstack

Check:

curl http://localhost:4566/health

---

## 🏗️ 2. Apply Terraform

cd Terraform

terraform init

terraform plan

terraform apply -auto-approve

---

## 📦 3. Verify Infrastructure (Optional)

aws --endpoint-url=http://localhost:4566 s3 ls

aws --endpoint-url=http://localhost:4566 sqs list-queues

---

## 🐍 4. Run the Application

cd ../api

pip install -r requirements.txt

python -m uvicorn app:app --reload

API available at:

http://127.0.0.1:8000

---

## 📡 5. API Endpoints

GET /files  
→ Lists objects in S3 (or returns message if empty)

POST /upload  
→ Upload JSON to S3

Example JSON:

{
  "name": "test",
  "value": 123
}

---

## 🔁 6. Test S3 → SQS Flow

aws --endpoint-url=http://localhost:4566 s3 cp fichero.txt s3://my-s3-object-uploads/

aws --endpoint-url=http://localhost:4566 --region eu-west-1 sqs receive-message --queue-url http://sqs.eu-west-1.localhost.localstack.cloud:4566/000000000000/my-sqs-object-uploads

---

## 🐳 7. Run with Docker Compose

docker-compose up --build

This starts:
- LocalStack
- API container

---

## 🧹 8. Destroy Infrastructure

cd terraform

terraform destroy -auto-approve

---

## 🔄 CI/CD

A GitHub Actions workflow is included that:

- Starts LocalStack
- Runs terraform init
- Runs terraform fmt -check
- Runs terraform validate
- Runs terraform plan

This ensures infrastructure is always validated on every push.

---

## 🧠 Notes

- LocalStack simulates AWS locally (no real AWS resources are used)
- Terraform plan is used in CI to avoid real deployments
- The project is fully reproducible and isolated

---

## 👨‍💻 Author

Daniel Arco