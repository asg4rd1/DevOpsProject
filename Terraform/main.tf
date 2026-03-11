provider "aws" {
  region = var.region
}

resource "aws_security_group" "dev_app_sg" {
  tags = local.default_tags
  name = "${local.name_prefix}-sg"
}

resource "aws_vpc_security_group_ingress_rule" "ingress"{
  for_each = var.enable_http ? toset([for p in var.ports : tostring(p)]) : toset(["22", "443"])
  security_group_id = aws_security_group.dev_app_sg.id
    cidr_ipv4 = var.allowed_ip
  from_port   = tonumber(each.value)
  to_port     = tonumber(each.value)
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "egress"{
  for_each = var.enable_http ? toset([for p in var.ports : tostring(p)]) : toset(["22", "443"])
  security_group_id = aws_security_group.dev_app_sg.id
    cidr_ipv4 = var.allowed_ip
  from_port   = tonumber(each.value)
  to_port     = tonumber(each.value)
  ip_protocol = "tcp"
}

resource "aws_instance" "dev_app_ec2" {
  count = length(var.instance_type)
  instance_type = var.instance_type[count.index]
  ami = "ami-0f3caa1cf4417e51b"
  tags = merge(
    local.default_tags,
    {
      Name = "${local.name_prefix}-ec2-${count.index}"
    }
  )
  vpc_security_group_ids = [aws_security_group.dev_app_sg.id]
  user_data_replace_on_change = true
  user_data = file("./user_data.sh") 
}

resource "aws_eip" "dev_eip_ec2" {
  count = length(var.instance_type)
  tags = merge(
    local.default_tags,
    {
      Name = "${local.name_prefix}-eip-${count.index}"
    }
  )
  domain   = "vpc"
  instance = aws_instance.dev_app_ec2[count.index].id
}