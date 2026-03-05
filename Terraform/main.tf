provider "aws" {
  region = var.region
}

resource "aws_security_group" "dev_app_sg" {
  tags = {
  Name = "dev-app-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ingress"{
  for_each = toset(var.ports)
  security_group_id = aws_security_group.dev_app_sg.id
    cidr_ipv4 = var.allowed_ip
  from_port   = each.value
  to_port     = each.value
  ip_protocol = "tcp"
}

resource "aws_instance" "dev_app_ec2" {
  instance_type = var.instance_type
  ami = "ami-0f3caa1cf4417e51b"
  tags = {
    Environment = "dev"
    Name = "dev-app-ec2"
    }
  vpc_security_group_ids = [aws_security_group.dev_app_sg.id]
}

resource "aws_eip" "dev_eip_ec2" {
  domain   = "vpc"
  instance = aws_instance.dev_app_ec2.id
}