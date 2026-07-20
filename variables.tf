variable "project_id" {
  type        = string
  description = "The GCP Project ID where resources will be provisioned."
}

variable "region" {
  type        = string
  description = "The target region for regional network resources."
}

variable "zone" {
  type        = string
  description = "The default zone for target instances within the managed instance group."
}

variable "vpc_name" {
  type        = string
  description = "The custom name assigned to the underlying VPC."
}

variable "vpc_cidr" {
  type        = string
  description = "The master CIDR block defining the custom VPC network space."
}

variable "subnet_name" {
  type        = string
  description = "Name assignment for the primary public subnet."
}

variable "subnet_cidr" {
  type        = string
  description = "The specific CIDR block dedicated to the public subnet."
}

variable "network_tags" {
  type        = list(string)
  description = "Network security tags mapped dynamically across resources."
}