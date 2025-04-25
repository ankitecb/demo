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
