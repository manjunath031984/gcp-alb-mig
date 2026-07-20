# Root provider configuration pointing to target project and home region
provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}