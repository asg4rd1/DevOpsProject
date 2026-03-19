from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import boto3
import os
import json
import uuid

app = FastAPI()

# Config
AWS_ENDPOINT = os.getenv("AWS_ENDPOINT", "http://localhost:4566")
REGION = "eu-west-1"
BUCKET_NAME = "my-s3-object-uploads"

# S3 client
s3 = boto3.client(
    "s3",
    endpoint_url=AWS_ENDPOINT,
    aws_access_key_id="test",
    aws_secret_access_key="test",
    region_name=REGION,
)

# ----------- MODELO PARA POST -----------
class Item(BaseModel):
    data: dict


# ----------- ENDPOINTS -----------

@app.get("/health")
def health():
    return {"status": "ok"}


@app.get("/files")
def list_files():
    try:
        response = s3.list_objects_v2(Bucket=BUCKET_NAME)

        if "Contents" not in response:
            return {"message": "Bucket is empty", "files": []}

        files = [obj["Key"] for obj in response["Contents"]]

        return {"files": files}

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@app.post("/upload")
def upload(item: Item):
    try:
        file_name = f"{uuid.uuid4()}.json"

        s3.put_object(
            Bucket=BUCKET_NAME,
            Key=file_name,
            Body=json.dumps(item.data),
            ContentType="application/json"
        )

        return {"message": "File uploaded", "file": file_name}

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))