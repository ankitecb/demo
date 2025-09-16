#################################################
Data Sources (Getting Existing AWS Resources)
What it does: Finds your AWS account's default VPC (Virtual Private Cloud)
Why we need it: Every EC2 instance needs to be placed in a VPC
code-
data "aws_vpc" "default" {
  default = true
}
#################################################

Amazon Linux AMI
What it does: Searches for the latest Amazon Linux 2023 AMI (Amazon Machine Image)
Why we need it: This is the "template" that tells AWS what operating system to install on our server

data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  # Filters to find the right AMI
}
#################################################
Security Group (Firewall Rules)
What it does: Creates a security group (like a firewall) for our web server
Key parts:
ingress: Allows incoming traffic on port 80 (HTTP) from anywhere
egress: Allows all outgoing traffic (so server can download updates)
resource "aws_security_group" "web_sg" {
  name        = "demo-web-sg"
  description = "Allow HTTP inbound traffic"
  vpc_id      = data.aws_vpc.default.id
#######################################################
Ingress Rule (Incoming Traffic)
What it does: Allows incoming HTTP traffic on port 80 from anywhere on the internet
  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
##########################################################  
Egress Rule (Outgoing Traffic)
What it does: Allows all outgoing traffic from the server to anywhere

protocol = "-1" means all protocols

from_port = 0 and to_port = 0 means all ports
These rules ensure your web server can receive HTTP requests and can make outbound connections for updates and downloads.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
################################################################
EC2 Instance (The Actual Server)
What it does: Creates the actual web server
Key settings:
Uses the AMI we found earlier
t2.micro = small, free-tier eligible server size
Applies our security group for network access

resource "aws_instance" "web" {
  ami                    = data.aws_ami.amazon_linux_2023.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  ############################################################
  User Data Script (Server Setup)
  user_data = <<EOF
#!/bin/bash
dnf update -y
dnf install -y httpd
systemctl enable httpd
systemctl start httpd

What it does: Runs automatically when server starts up
Steps it performs:
Updates the system packages
Installs Apache web server (httpd)
Enables Apache to start automatically
Starts the Apache service

HTML Page Creation
cat <<HTML_PAGE > /var/www/html/index.html
<!DOCTYPE html>
<html>
# ... HTML content ...
</html>
HTML_PAGE
What it does: Creates a custom web page that shows:

Demo title
The server's public IP address
Welcome message and animated GIF
###############################################################
Resource Tags
What it does: Labels the server in AWS console for easy identification
tags = {
  Name = "terraform-demo-web"
}
##############################################################
Output Values
What it does: Displays the server's public IP address after creation
Why it's useful: You need this IP to visit your website
output "web_public_ip" {
  value = aws_instance.web.public_ip
}





 




