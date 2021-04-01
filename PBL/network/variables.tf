variable "region" {}


variable "vpc_cidr" {}

variable "max_subnets" {
  type = number
}

variable "enable_dns_support" {}

variable "enable_dns_hostnames" {
  default = "true"
}

variable "enable_classiclink" {}

variable "enable_classiclink_dns_support" {}

variable "private_subnets" {
  type = list(any)
}

variable "public_subnets" {
  type = list(any)

}

variable "private_sn_count" {
  description = "number of desired private subnets"
  type        = number

}

variable "public_sn_count" {
  description = "number of desired  Public subnets"
  type        = number

}

variable "environment" {
  default = "true"
}

variable "public_key_path" {}

variable "security_groups" {}