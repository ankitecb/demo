#################################################
# Terraform & Provider Setup
#################################################
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

#################################################
# Data Source (read-only information from AWS)
#################################################
# Fetches AWS Account ID and ARN for the current credentials
data "aws_caller_identity" "current" {}

#################################################
# Locals (computed values for reuse)
#################################################
locals {
  # Bucket prefix comes from variable + "-project"
  bucket_prefix = "${var.bucket_prefix}-project"

  # Environment name in uppercase
  env_upper = upper(var.environment)
}

#################################################
# Resource (creates infrastructure)
#################################################
# Create one bucket per environment using for_each
resource "aws_s3_bucket" "my_buckets" {
  for_each = toset(var.environments)

  # Bucket name is built using:
  #   - local bucket_prefix
  #   - current environment
  #   - account id (from data source)
  bucket = "${local.bucket_prefix}-${each.key}-${data.aws_caller_identity.current.account_id}"

  force_destroy = true

  tags = {
    Environment = each.key
    Owner       = "rana"
    Name        = "Demo bucket for ${each.key}"
  }
}

#################################################
# Outputs
#################################################
output "bucket_names" {
  value = [for b in aws_s3_bucket.my_buckets : b.bucket]
}
