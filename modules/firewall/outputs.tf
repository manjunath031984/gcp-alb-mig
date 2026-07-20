output "firewall_ssh_name" {
  description = "Name of the SSH firewall rule."
  value       = google_compute_firewall.allow_ssh.name
}