provider "aws" {
  region = var.region
}

module "vpc" {
  source = "./modules/vpc"

  region          = var.region
  environment     = var.environment
  vpc_cidr        = var.vpc_cidr
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
}

module "ec2" {
  source = "./modules/ec2"
  region             = var.region
  environment        = var.environment
  allowed_ip         = var.allowed_ip
  ports              = var.ports
  enable_http        = var.enable_http
  instance_type      = var.instance_type
  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids
}