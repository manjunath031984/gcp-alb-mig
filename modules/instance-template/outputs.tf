output "template_id" {
  description = "Unique identifier of the Compute Engine instance template."
  value       = google_compute_instance_template.web_template.id
}

output "template_name" {
  description = "Name of the Compute Engine instance template."
  value       = google_compute_instance_template.web_template.name
}