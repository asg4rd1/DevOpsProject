output "vpc_id" {
  value = aws_vpc.app_dev_vpc.id
}

output "public_subnet_ids" {
  value = {
    for k, subnet in aws_subnet.public_subnet : k => subnet.id
  }
}

output "private_subnet_ids" {
  value = {
    for k, subnet in aws_subnet.private_subnet : k => subnet.id
  }
}