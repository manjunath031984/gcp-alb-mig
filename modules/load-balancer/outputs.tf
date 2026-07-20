output "global_ip" {
  description = "Public IPv4 address assigned to the external Application Load Balancer."
  value       = google_compute_global_address.lb_ip.address
}

output "backend_service_name" {
  description = "Name of the backend service associated with the Application Load Balancer."
  value       = google_compute_backend_service.web_backend.name
}

output "url_map_name" {
  description = "Name of the URL map used by the Application Load Balancer."
  value       = google_compute_url_map.web_map.name
}