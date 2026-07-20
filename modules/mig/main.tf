resource "google_compute_region_instance_group_manager" "web_mig" {
  name               = "web-mig"
  region             = var.region
  base_instance_name = "web"
  target_size        = 2

  version {
    instance_template = var.instance_template_id
  }

  named_port {
    name = "http"
    port = 80
  }

  distribution_policy_zones = [
    var.zone,
    "${var.region}-b"
  ]

  auto_healing_policies {
    health_check      = var.health_check_id
    initial_delay_sec = 300
  }
}

resource "google_compute_region_autoscaler" "web_autoscaler" {
  name   = "web-autoscaler"
  region = var.region
  target = google_compute_region_instance_group_manager.web_mig.id

  autoscaling_policy {
    max_replicas    = 4
    min_replicas    = 2
    cooldown_period = 60

    cpu_utilization {
      target = 0.5
    }
  }
}