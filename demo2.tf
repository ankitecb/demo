provider "aws" {



  region = "eu-west-1"  # Replace with your desired AWS region



}



data "aws_caller_identity" "current" {}



resource "aws_s3_bucket" "example" {



  bucket = "my-demo-bucket-${data.aws_caller_identity.current.account_id}"







}



terraform { 



  cloud { 



    



    organization = "MilanR" 







    workspaces { 



      name = "terraform-demo" 



    } 



  } 



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







***********

terraform {

  required_providers {

    aws = {

      source  = "hashicorp/aws"

      version = "~> 3.0"

    }

  }

}



provider "aws" {

  region = "eu-west-1"

}



data "aws_caller_identity" "current" {}



resource "aws_s3_bucket" "example" {

  bucket = "my-demo-bucket-${data.aws_caller_identity.current.account_id}"

}





********************************************************************



terraform {

  required_providers {

    aws = {

      source  = "hashicorp/aws"

      version = "~> 5.0"  # AWS provider version (adjust as needed)

    }

  }

}



provider "aws" {

  region = "eu-west-1"

}



data "aws_caller_identity" "current" {}



# Create an S3 bucket (your existing code)

resource "aws_s3_bucket" "example" {

  bucket = "my-demo-bucket-${data.aws_caller_identity.current.account_id}"

}



# Get the default VPC

data "aws_vpc" "default" {

  default = true

}



# Get the default security group of the default VPC

data "aws_security_group" "default" {

  name   = "default"

  vpc_id = data.aws_vpc.default.id

}



# Get the latest Amazon Linux 2 AMI

data "aws_ami" "amazon_linux" {

  most_recent = true

  owners      = ["amazon"]



  filter {

    name   = "name"

    values = ["amzn2-ami-hvm-*-x86_64-gp2"]

  }

}



# Create an EC2 instance in the default VPC with the default security group

resource "aws_instance" "example" {

  ami           = data.aws_ami.amazon_linux.id

  instance_type = "t2.micro"  # Free tier eligible



  # Associate the default security group

  vpc_security_group_ids = [data.aws_security_group.default.id]



  # Use the default subnet (optional, but recommended)

  subnet_id = tolist(data.aws_vpc.default.public_subnets)[0]



  tags = {

    Name = "example-instance"

  }

}







************

terraform {

  required_providers {

    aws = {

      source  = "hashicorp/aws"

      version = "~> 5.0"

    }

  }

}



provider "aws" {

  region = "eu-west-1"  # Change as needed

}



# Get the latest Amazon Linux 2 AMI (optional, can replace with hardcoded AMI)

data "aws_ami" "amazon_linux" {

  most_recent = true

  owners      = ["amazon"]



  filter {

    name   = "name"

    values = ["amzn2-ami-hvm-*-x86_64-gp2"]

  }

}



# Create EC2 instance (uses default VPC & default SG)

resource "aws_instance" "example" {

  ami           = data.aws_ami.amazon_linux.id  # or use a hardcoded AMI like "ami-0c55b159cbfafe1f0"

  instance_type = "t2.micro"



  tags = {

    Name = "my-ec2-instance"  # Name tag for the instance

  }

}





Output



terraform {

  required_providers {

    aws = {

      source  = "hashicorp/aws"

      version = "~> 5.0"

    }

  }

}



provider "aws" {

  region = "eu-west-1"

}



# Get AWS account ID

data "aws_caller_identity" "current" {}



# Create S3 bucket

resource "aws_s3_bucket" "example" {

  bucket = "my-demo-bucket-${data.aws_caller_identity.current.account_id}"

}



# Get the latest Amazon Linux 2 AMI

data "aws_ami" "amazon_linux" {

  most_recent = true

  owners      = ["amazon"]



  filter {

    name   = "name"

    values = ["amzn2-ami-hvm-*-x86_64-gp2"]

  }

}



# Create EC2 instance (uses default VPC & default SG)

resource "aws_instance" "example" {

  ami           = data.aws_ami.amazon_linux.id

  instance_type = "t2.micro"



  tags = {

    Name = "my-ec2-instance"

  }

}



# ========= OUTPUTS ==========

output "s3_bucket_name" {

  description = "The name of the S3 bucket"

  value       = aws_s3_bucket.example.bucket

}



output "s3_bucket_arn" {

  description = "The ARN of the S3 bucket"

  value       = aws_s3_bucket.example.arn

}



output "ec2_instance_id" {

  description = "The ID of the EC2 instance"

  value       = aws_instance.example.id

}

