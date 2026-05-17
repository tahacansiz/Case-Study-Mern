# Output Değerleri - Terraform apply sonrası gösterilecek bilgiler

output "instance_id" {
  description = "EC2 Instance ID"
  value       = aws_instance.mern_k3s_server.id
}

output "instance_public_ip" {
  description = "EC2 Instance Public IP (SSH için kullanın)"
  value       = aws_instance.mern_k3s_server.public_ip
}

output "instance_private_ip" {
  description = "EC2 Instance Private IP"
  value       = aws_instance.mern_k3s_server.private_ip
}

output "security_group_id" {
  description = "Security Group ID"
  value       = aws_security_group.mern_k3s_sg.id
}

output "ssh_command" {
  description = "SSH ile bağlanma komutu"
  value       = "ssh -i /path/to/mern-key.pem ubuntu@${aws_instance.mern_k3s_server.public_ip}"
}

output "ami_used" {
  description = "Kullanılan Ubuntu AMI ID"
  value       = data.aws_ami.ubuntu.id
}

output "instance_type_used" {
  description = "EC2 Instance Tipi"
  value       = aws_instance.mern_k3s_server.instance_type
}
