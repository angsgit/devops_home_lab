output "master_public_ip" {
  value = aws_instance.k8s_master.public_ip
}

output "worker1_public_ip" {
  value = aws_instance.k8s_worker1.public_ip
}

output "worker2_public_ip" {
  value = aws_instance.k8s_worker2.public_ip
}
