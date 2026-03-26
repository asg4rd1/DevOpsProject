variable "region" {
  type = string
}

variable "environment" {
  type = string
}

variable "allowed_ip" {
  type = string
}

variable "ports" {
  type = set(number)
}

variable "enable_http" {
  type = bool
}

variable "instance_type" {
  type = map(string)
}

variable "public_subnets" {
  type = map(object({
    cidr = string
    az   = string
  }))
}

variable "private_subnets" {
  type = map(object({
    cidr = string
    az   = string
  }))
}

variable "vpc_cidr" {
  type = string
}