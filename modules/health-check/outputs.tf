output "health_check_id" {
  description = "Unique identifier of the HTTP health check."
  value       = google_compute_health_check.web_health_check.id
}

output "health_check_name" {
  description = "Name of the HTTP health check."
  value       = google_compute_health_check.web_health_check.name
}