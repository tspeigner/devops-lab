variable "aws_region" {
  description = "The AWS region to deploy resources in."
  type        = string
  default     = "us-east-1"
}

variable "profile" {
  description = "The AWS CLI profile to use for authentication."
  type        = string
  default     = "tommy"
}

variable "instance_type" {
  description = "The type of EC2 instance to deploy."
  type        = string
  default     = "t2.micro"
}

variable "ami" {
  description = "The AMI ID for the EC2 instance."
  type        = string
  default     = "ami-08c40ec9ead489470" # Amazon Linux 2 AMI in us-east-1
  validation {
    condition     = can(regex("^ami-[a-f0-9]{8,17}$", var.ami))
    error_message = "The AMI ID must be a valid ID starting with 'ami-' followed by 8 to 17 hexadecimal characters."
  }
}
