ports = [22, 80, 443]
enable_http = true
region = "us-east-1"
instance_type = {
  app1 = "t3.micro"
  app2 = "t3.small"
  app3 = "t3.micro"
}
allowed_ip    = "0.0.0.0/0"