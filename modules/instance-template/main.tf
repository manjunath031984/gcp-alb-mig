resource "google_compute_instance_template" "web_template" {
  name_prefix  = "web-template-"
  machine_type = "e2-micro"

  lifecycle {
    create_before_destroy = true
  }

  disk {
    source_image = "ubuntu-os-cloud/ubuntu-minimal-2604-lts-amd64" # Valid minimal release tracking
    auto_delete  = true
    boot         = true
    type         = "pd-balanced"
    disk_size_gb = 10
  }

  network_interface {
    network    = var.network_name
    subnetwork = var.subnet_name

    # Allocate ephemeral external IP to compute workloads directly
    access_config {}
  }

  metadata = {
    startup-script = file("${path.root}/script.sh")
  }

  tags = var.network_tags

  lifecycle {
    create_before_destroy = true
  }
}
