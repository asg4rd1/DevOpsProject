resource "aws_eip" "lb" {
  domain = "vpc"
}

resource "aws_security_group" "allow_tls-2" {
  name = "attribute-stg"
}

resource "aws_vpc_security_group_ingress_rule" "name" {
  security_group_id = aws_security_group.allow_tls-2.id


  cidr_ipv4 = "${aws_eip.lb.public_ip}/32"
  from_port = 443
  ip_protocol = "tcp"
  to_port = 443

}