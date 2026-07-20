variable "vpc_name" {
  description = "Name of the VPC network where the firewall rules will be created."
  type        = string
}

variable "network_tags" {
  description = "List of network tags to associate with the firewall rules."
  type        = list(string)
}