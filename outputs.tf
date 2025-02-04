output "instance_public_ip" {
  value = aws_instance.MyBasicVM.public_ip
}