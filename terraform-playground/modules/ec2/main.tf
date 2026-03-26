provider "aws" {
  region = var.region
}

resource "aws_security_group" "dev_app_sg_private" {
  vpc_id = var.vpc_id
  tags = local.default_tags
  name = "${local.name_prefix}-sg-private"
}

resource "aws_security_group" "dev_app_sg_public" {
  vpc_id = var.vpc_id
  tags = local.default_tags
  name = "${local.name_prefix}-sg-public"
}

resource "aws_vpc_security_group_ingress_rule" "ingress_private" {
  security_group_id            = aws_security_group.dev_app_sg_private.id
  referenced_security_group_id = aws_security_group.dev_app_sg_public.id
  from_port                    = 22
  to_port                      = 22
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "egress_private"{
  security_group_id = aws_security_group.dev_app_sg_private.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "ingress_public_web"{
  for_each = toset([for p in var.ports : tostring(p)])
  security_group_id = aws_security_group.dev_app_sg_public.id
    cidr_ipv4 = var.allowed_ip
  from_port   = tonumber(each.value)
  to_port     = tonumber(each.value)
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "ingress_public_ssh"{
  security_group_id = aws_security_group.dev_app_sg_public.id
  cidr_ipv4 = var.allowed_ip
  from_port   = 22
  to_port     = 22
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "egress_public"{
  security_group_id = aws_security_group.dev_app_sg_public.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "-1"
}

resource "aws_instance" "dev_app_ec2_private" {
  for_each      = local.private_instances
  instance_type = each.value.instance_type
  subnet_id = var.private_subnet_ids[each.value.subnet_key]
  ami = data.aws_ami.app_ami.id
  tags = merge(
    local.default_tags,
    {
      Name = "${local.name_prefix}-ec2-${each.key}"
    }
  )
  vpc_security_group_ids = [aws_security_group.dev_app_sg_private.id]
  user_data_replace_on_change = true
  user_data = file("${path.module}/user_data.sh")
}

resource "aws_instance" "dev_app_ec2_public" {
  for_each      = local.public_instances
  instance_type = each.value.instance_type
  subnet_id = var.public_subnet_ids[each.value.subnet_key]
  ami = data.aws_ami.app_ami.id
  tags = merge(
    local.default_tags,
    {
      Name = "${local.name_prefix}-ec2-${each.key}"
    }
  )
  vpc_security_group_ids = [aws_security_group.dev_app_sg_public.id]
  user_data_replace_on_change = true
  user_data = file("${path.module}/user_data.sh")
}