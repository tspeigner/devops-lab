output "instance_public_ip" {
  value = aws_instance.basic_vm.public_ip
}