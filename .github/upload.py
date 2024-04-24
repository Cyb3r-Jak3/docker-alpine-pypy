"""Upload the artifacts to Cloudflare R2 Storage"""

import os
import boto3
import re

BUCKET_NAME = os.getenv("BUCKET_NAME", "pypy-files")
pattern = re.compile(r"\d\.\d(\d)?")

s3 = boto3.client(
    service_name="s3",
    endpoint_url='https://8be772befd147a8df540aae0fa15c047.r2.cloudflarestorage.com',
    region_name="auto",
)

CONTENT_TYPE_MAP = {
    "sig": "application/pgp-signature",
    "bz2": "application/x-bzip2",
    "sha256sum": "text/plain"
}


def upload_file(file_name: str) -> None:
    """Uploads a file to R2"""
    python_version = pattern.search(file_name).group()
    try:
        s3.upload_file(
            f"output/{file_name}",
            BUCKET_NAME,
            f"pypy/{python_version}/{file_name}",
            ExtraArgs={
                "ContentType": CONTENT_TYPE_MAP.get(file_name.split('.')[-1], 'application/octet-stream'),
                "CacheControl": "public, max-age=31536000",
                "ContentDisposition": f"attachment; filename={file_name.split('/')[-1]}",
            }
        )
    except Exception as e:
        print(f"Failed to upload {file_name} to {file_name}: {e}")
        raise e
    print(f"Uploaded {file_name}")


if __name__ == "__main__":
    for file in os.listdir("output"):
        upload_file(file)
