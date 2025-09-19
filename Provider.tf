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
