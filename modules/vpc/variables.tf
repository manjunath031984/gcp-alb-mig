variable "vpc_name" {
  description = "Name of the custom VPC network."
  type        = string
}

variable "subnet_name" {
  description = "Name of the public subnet."
  type        = string
}

variable "subnet_cidr" {
  description = "CIDR range for the public subnet."
  type        = string

  validation {
    condition     = can(cidrhost(var.subnet_cidr, 0))
    error_message = "The subnet_cidr must be a valid IPv4 CIDR block."
  }
}

variable "region" {
  description = "Google Cloud region where resources will be deployed."
  type        = string
}