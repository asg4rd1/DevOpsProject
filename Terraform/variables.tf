variable "tags" {
  type = map(string)
}

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
  type = set(number)
}

variable "enable_http" {
  type    = bool
}