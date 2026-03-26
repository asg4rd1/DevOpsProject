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

variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type = map(string)
}

variable "private_subnet_ids" {
  type = map(string)
}