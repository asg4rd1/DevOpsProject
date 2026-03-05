output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.dev_app_ec2.id
}

output "public_ip" {
  description = "Elastic IP attached to the instance"
  value       = aws_eip.dev_eip_ec2.public_ip
}