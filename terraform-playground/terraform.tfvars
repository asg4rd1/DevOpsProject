ports = [80, 443]
enable_http = true
region = "us-east-1"
environment = "dev"
instance_type = {
  app1 = "t3.micro"
  app2 = "t3.small"
}
allowed_ip    = "0.0.0.0/0" # JUST ALLOWED IN LAB ENV

vpc_cidr    = "10.0.0.0/16"
public_subnets = {
  public_1 = {
    cidr = "10.0.1.0/24"
    az   = "us-east-1a"
  }
  public_2 = {
    cidr = "10.0.2.0/24"
    az   = "us-east-1b"
  }
}

private_subnets = {
  private_1 = {
    cidr = "10.0.11.0/24"
    az   = "us-east-1a"
  }
  private_2 = {
    cidr = "10.0.12.0/24"
    az   = "us-east-1b"
  }
}