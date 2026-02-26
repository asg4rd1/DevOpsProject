resource "aws_instance" "myec2" {
    ami = "ami-09c20105c9b62f893"
    instance_type = "t3.micro"
}

resource "aws_eip" "lb" {
  instance = aws_instance.web.id
  domain   = "vpc"
}