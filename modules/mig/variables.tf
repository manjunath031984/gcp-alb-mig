variable "region" {
  description = "Google Cloud region where the Managed Instance Group will be created."
  type        = string
}

variable "zone" {
  description = "Google Cloud zone used for the instance template and distribution policy."
  type        = string
}

variable "instance_template_id" {
  description = "ID of the Compute Engine instance template used by the Managed Instance Group."
  type        = string
}

variable "health_check_id" {
  description = "ID of the HTTP health check used for auto-healing."
  type        = string
}