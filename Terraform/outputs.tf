output "instance_id" {
  description = "ID of the EC2 instance"
  value       = [for instancia in aws_instance.dev_app_ec2 : instancia.id]
}

output "public_ip" {
  description = "Elastic IP attached to the instance"
  value = [for eip in aws_eip.dev_eip_ec2 : eip.public_ip ]
}