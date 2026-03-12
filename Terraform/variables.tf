variable "region" {
  type = string
} 
variable "instance_type" {
    type = map(string)
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