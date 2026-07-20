# Standard versioning constraints for Terraform and Google Cloud Platform Provider
terraform {
  required_version = ">= 1.13.0, < 1.14.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0" # Stable provider line covering 2026 infrastructure paradigms
    }
  }
}