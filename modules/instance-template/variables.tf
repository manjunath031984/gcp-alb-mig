variable "network_name" {
  description = "Name of the VPC network to associate with the instance template."
  type        = string
}

variable "subnet_name" {
  description = "Name of the subnetwork where instances will be deployed."
  type        = string
}

variable "network_tags" {
  description = "List of network tags to assign to the Compute Engine instances."
  type        = list(string)
}