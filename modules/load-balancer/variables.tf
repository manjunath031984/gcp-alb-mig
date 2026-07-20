variable "mig_instance_group" {
  description = "Self-link of the Managed Instance Group used as the backend for the load balancer."
  type        = string
}

variable "health_check_id" {
  description = "ID of the HTTP health check associated with the backend service."
  type        = string
}