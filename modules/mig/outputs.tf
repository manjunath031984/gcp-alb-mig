output "instance_group_manager_id" {
  description = "Instance group URL managed by the regional Managed Instance Group."
  value       = google_compute_region_instance_group_manager.web_mig.instance_group
}

output "mig_name" {
  description = "Name of the regional Managed Instance Group."
  value       = google_compute_region_instance_group_manager.web_mig.name
}