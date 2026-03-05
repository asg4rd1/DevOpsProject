provider "aws" {
  region = var.region
}

resource "aws_security_group" "dev_app_sg" {
  tags = var.tags
}

resource "aws_vpc_security_group_ingress_rule" "ingress"{
  for_each = var.enable_http ? toset([for p in var.ports : tostring(p)]) : toset(["22", "443"])
  security_group_id = aws_security_group.dev_app_sg.id
    cidr_ipv4 = var.allowed_ip
  from_port   = tonumber(each.value)
  to_port     = tonumber(each.value)
  ip_protocol = "tcp"
}

resource "aws_instance" "dev_app_ec2" {
  instance_type = var.instance_type
  ami = "ami-0f3caa1cf4417e51b"
  tags = var.tags
  vpc_security_group_ids = [aws_security_group.dev_app_sg.id]
}

resource "aws_eip" "dev_eip_ec2" {
  domain   = "vpc"
  instance = aws_instance.dev_app_ec2.id
}