# DevOps Cheatsheet (LocalStack + Terraform)

## 🚀 LocalStack

Check containers and service availability:

```bash
docker ps
curl localhost:4566
```

---

## 🪣 S3

List buckets:

```bash
aws --endpoint-url=http://localhost:4566 s3 ls
```

List objects in bucket:

```bash
aws --endpoint-url=http://localhost:4566 s3 ls s3://my-s3-object-uploads/
```

Upload file (trigger event):

```bash
echo "test" > test.json
aws --endpoint-url=http://localhost:4566 s3 cp test.json s3://my-s3-object-uploads/
```

---

## 📬 SQS

List queues:

```bash
aws --endpoint-url=http://localhost:4566 sqs list-queues
```

Get queue URL:

```bash
aws --endpoint-url=http://localhost:4566 sqs get-queue-url \
  --queue-name my-sqs-object-uploads
```

Receive messages:

```bash
aws --endpoint-url=http://localhost:4566 sqs receive-message \
  --queue-url http://sqs.eu-west-1.localhost.localstack.cloud:4566/000000000000/my-sqs-object-uploads
```

Receive multiple messages (recommended):

```bash
aws --endpoint-url=http://localhost:4566 sqs receive-message \
  --max-number-of-messages 10 \
  --wait-time-seconds 5 \
  --queue-url http://sqs.eu-west-1.localhost.localstack.cloud:4566/000000000000/my-sqs-object-uploads
```

Delete message:

```bash
aws --endpoint-url=http://localhost:4566 sqs delete-message \
  --queue-url <QUEUE_URL> \
  --receipt-handle <RECEIPT_HANDLE>
```

---

## ⚙️ Terraform

Initialize:

```bash
terraform init
```

Plan:

```bash
terraform plan
```

Apply:

```bash
terraform apply
```

Destroy:

```bash
terraform destroy
```

---

## 🔍 Debug

Check LocalStack logs:

```bash
docker logs localstack
```

---

## 🧠 Full Flow

```text
1. terraform apply
2. upload file to S3
3. receive message from SQS
```