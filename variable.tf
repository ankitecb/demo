variable "region" {
  description = "AWS region to deploy resources into"
  type        = string
  default     = "eu-west-1"
}

variable "bucket_prefix" {
  description = "Prefix for S3 bucket names"
  type        = string
  default     = "my-terraform-bucket"
}

variable "environment" {
  description = "Default environment name"
  type        = string
  default     = "dev"
}

variable "environments" {
  description = "List of environments to create buckets for"
  type        = list(string)
  default     = ["dev", "qa", "prod"]
}
