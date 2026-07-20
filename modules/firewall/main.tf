resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh"
  network = var.vpc_name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = var.network_tags
  description   = "Allows SSH access to Compute Engine instances."
}

resource "google_compute_firewall" "allow_http" {
  name    = "allow-http"
  network = var.vpc_name

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = var.network_tags
}

resource "google_compute_firewall" "allow_https" {
  name    = "allow-https"
  network = var.vpc_name

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = var.network_tags
}

resource "google_compute_firewall" "allow_health_check" {
  name    = "allow-health-check"
  network = var.vpc_name

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  # Allow Google Front End (GFE) and health checking networks
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
  target_tags   = var.network_tags
}