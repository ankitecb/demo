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

terraform {

  cloud {

   

    organization = "MilanR"



    workspaces {

      name = "terraform-demo"

    }

  }

}


data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "example" {

bucket = "my-demoo-bucket-${data.aws_caller_identity.current.account_id}"
}


output "a3_bucket_arn" {
  value = aws_s3_bucket.example.arn
}




resource "aws_instance" "web" {
  ami           = "ami-0fa8fe6f147dc938b"
  instance_type = "t2.micro"

  tags = {
    Name = "HelloWorld"
  }
}
