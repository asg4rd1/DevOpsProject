variable "region" {
  type = string
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type for the web server"
}

variable "allowed_ip" {
  type    = string
}

variable "ports" {
  type = list(number)
  default = [22, 80, 443]
}