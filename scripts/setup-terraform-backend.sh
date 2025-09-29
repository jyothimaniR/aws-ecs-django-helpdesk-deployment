#!/bin/bash
set -e

echo "Setting up Terraform backend resources..."

# Generate unique suffix for S3 bucket
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
SUFFIX=$(echo $ACCOUNT_ID | tail -c 5)
BUCKET_NAME="helpdesk-terraform-state-${SUFFIX}"
REGION="us-east-1"

# Create S3 bucket for state
echo "Creating S3 bucket: ${BUCKET_NAME}"
aws s3api create-bucket \
    --bucket ${BUCKET_NAME} \
    --region ${REGION} 2>/dev/null || echo "Bucket already exists"

# Enable versioning
aws s3api put-bucket-versioning \
    --bucket ${BUCKET_NAME} \
    --versioning-configuration Status=Enabled

# Enable encryption
aws s3api put-bucket-encryption \
    --bucket ${BUCKET_NAME} \
    --server-side-encryption-configuration '{
        "Rules": [{
            "ApplyServerSideEncryptionByDefault": {
                "SSEAlgorithm": "AES256"
            }
        }]
    }'

# Block public access
aws s3api put-public-access-block \
    --bucket ${BUCKET_NAME} \
    --public-access-block-configuration \
        BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true

# Create DynamoDB table for state locking
echo "Creating DynamoDB table for state locking..."
aws dynamodb create-table \
    --table-name helpdesk-terraform-locks \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --billing-mode PAY_PER_REQUEST \
    --region ${REGION} 2>/dev/null || echo "Table already exists"

echo ""
echo "Backend setup complete!"
echo ""
echo "Update backend.tf with:"
echo "  bucket = \"${BUCKET_NAME}\""
echo ""
