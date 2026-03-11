locals {
  environment = "dev"
  name_prefix = "${local.environment}-app"
  default_tags = {
    environment = local.environment
    Project = "terraform-lab"
    Owner = "DanielArco"
    repository_name = "Asg4rd0"
  }
}