output "vpc_name" {
  description = "Name of the custom VPC network."
  value       = google_compute_network.custom_vpc.name
}

output "subnet_name" {
  description = "Name of the public subnet."
  value       = google_compute_subnetwork.public_subnet.name
}