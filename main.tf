# main.tf
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  required_version = ">= 1.0"
}

# Configure AWS Provider
provider "aws" {
  #region = var.aws_region  # Change to your preferred region
  #profile = var.profile     # Use my profile
}

resource "aws_iam_role" "ssm_role" {
  name = "EC2_SSM_Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy_attachment" "ssm_attach" {
  name       = "SSMPolicyAttachment"
  roles      = [aws_iam_role.ssm_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm_profile" {
  name = "ssm_instance_profile"
  role = aws_iam_role.ssm_role.name
}

resource "aws_instance" "basic_vm" {
  ami           = var.ami
  instance_type = var.instance_type
  iam_instance_profile = aws_iam_instance_profile.ssm_profile.name

  tags = {
    Name = "MyBasicVM"
  }
}

# Create an EC2 Instance
resource "aws_instance" "basic_vm" {
  ami           = var.ami
  instance_type = var.instance_type

  # (Optional) If you want SSH access:
  key_name = "devops-testin.pem"

  # Attach security group here
  vpc_security_group_ids = [aws_security_group.allow_ssh_http.id]

  user_data = <<-EOF
  #!/bin/bash
  sudo apt update -y
  sudo apt install -y nginx
  sudo systemctl start nginx
  sudo systemctl enable nginx
  echo "Reverse Proxy Webserver" | sudo tee /var/www/html/index.html
  EOF



  # Add a Name tag
  tags = {
    Name = "MyBasicVM"
  }

}