variable "aws_region" {
  type    = string
  default = "eu-central-1"
}

variable "vpc_name" {
  type    = string
  default = "p2-vpc"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "az_a" {
  type    = string
  default = "eu-central-1a"
}

variable "az_b" {
  type    = string
  default = "eu-central-1b"
}
terraform fmt -recursive
