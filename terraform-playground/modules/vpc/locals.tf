locals {
  name_prefix = "${var.environment}-app"
  default_tags = {
    environment = var.environment
    Project = "terraform-lab"
    Owner = "DanielArco"
    repository_name = "Asg4rd0"
  }
}

locals {
  public_instances = {
    app1 = {
      instance_type = "t3.micro"
      subnet_key    = "public_1"
    }
    app2 = {
      instance_type = "t3.small"
      subnet_key    = "public_2"
    }
  }

  private_instances = {
    app1 = {
      instance_type = "t3.micro"
      subnet_key    = "private_1"
    }
    app2 = {
      instance_type = "t3.small"
      subnet_key    = "private_2"
    }
  }
}