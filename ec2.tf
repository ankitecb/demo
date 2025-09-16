
# Get default VPC
data "aws_vpc" "default" {
  default = true
}

# Get latest Amazon Linux 2023 AMI
data "aws_ami" "amazon_linux_2023" {
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["137112412989"] # Amazon
}

# Security Group
resource "aws_security_group" "web_sg" {
  name        = "demo-web-sg"
  description = "Allow HTTP inbound traffic"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 instance
resource "aws_instance" "web" {
  ami                    = data.aws_ami.amazon_linux_2023.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  user_data = <<EOF
#!/bin/bash
dnf update -y
dnf install -y httpd

systemctl enable httpd
systemctl start httpd

# Get public IP
PUBLIC_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4 || echo "Unavailable")

# Create demo HTML page
cat <<HTML_PAGE > /var/www/html/index.html
<!DOCTYPE html>
<html>
<head>
<title>Infrastructure as Code Demo</title>
<style>
body { background-color: #222; color: white; font-family: sans-serif; text-align: center; padding-top: 50px; }
h1 { color: #ffcc00; }
h2 { color: #00ccff; }
p { font-size: 18px; }
</style>
</head>
<body>
<h1>Infrastructure as Code Demo</h1>
<h2>Instance Public IP: \$PUBLIC_IP</h2>
<p>Welcome! This is your simple demo page served by Apache on Amazon Linux 2023.</p>
<img src="https://media.giphy.com/media/3o7abKhOpu0NwenH3O/giphy.gif" alt="Demo Image" width="400"/>
</body>
</html>
HTML_PAGE

systemctl restart httpd
EOF

  tags = {
    Name = "terraform-demo-web"
  }
}

# Output the public IP
output "web_public_ip" {
  value = aws_instance.web.public_ip
}
