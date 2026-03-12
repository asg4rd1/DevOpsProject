locals {
  name_prefix = "${var.environment}-app"
  default_tags = {
    environment = var.environment
    Project = "terraform-lab"
    Owner = "DanielArco"
    repository_name = "Asg4rd0"
  }
}