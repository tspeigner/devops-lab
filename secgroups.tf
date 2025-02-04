resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Security group allowing HTTP and SSM"
  vpc_id      = data.aws_vpc.default.id

  # HTTP Access
  ingress {
    description      = "Allow HTTP from my IP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["76.144.17.103/32"]
  }

  # App Port 8080
  ingress {
    description      = "Allow App Traffic on 8080"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["76.144.17.103/32"]
  }

  # App Port 8081
  ingress {
    description      = "Allow App Traffic on 8081"
    from_port        = 8081
    to_port          = 8081
    protocol         = "tcp"
    cidr_blocks      = ["76.144.17.103/32"]
  }

  # No SSH needed - We use AWS SSM

  # Outbound Access
  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow-http-ssm"
  }
}
