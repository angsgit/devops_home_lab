output "ec2_public_ip" {
  description = "Public IP of the created EC2 instance"
  value       = aws_instance.test_vm.public_ip
}
