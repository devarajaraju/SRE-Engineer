output "ec2_public_ip" {
  description = "EC2 Elastic IP address"
  value       = aws_eip.sre_eip.public_ip
}

output "ec2_instance_id" {
  description = "EC2 Instance ID"
  value       = aws_instance.sre_server.id
}

output "instance_type" {
  description = "EC2 instance type"
  value       = aws_instance.sre_server.instance_type
}

output "security_group_id" {
  description = "Security Group ID"
  value       = aws_security_group.sre_sg.id
}
