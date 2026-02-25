resource "aws_instance" "myec2" {
    ami = "ami-09c20105c9b62f893"
    instance_type = "t3.micro"
}