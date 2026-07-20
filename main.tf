# Custom Mode Virtual Private Cloud Setup
module "vpc" {
  source      = "./modules/vpc"
  vpc_name    = var.vpc_name
  subnet_name = var.subnet_name
  subnet_cidr = var.subnet_cidr
  region      = var.region
}

# Advanced Security Groups & Firewall Enforcement Boundaries
module "firewall" {
  source       = "./modules/firewall"
  vpc_name     = module.vpc.vpc_name
  network_tags = local.common_tags
}

# Immutable Base Image Architecture Declaration
module "instance_template" {
  source       = "./modules/instance-template"
  network_name = module.vpc.vpc_name
  subnet_name  = module.vpc.subnet_name
  network_tags = local.common_tags
}

# Global Health Status Tracking Core Engine
module "health_check" {
  source = "./modules/health-check"
}

# Multi-Zone Self-Healing Compute Clusters
module "mig" {
  source               = "./modules/mig"
  region               = var.region
  zone                 = var.zone
  instance_template_id = module.instance_template.template_id
  health_check_id      = module.health_check.health_check_id
}

# Edge Application Optimization Delivery Architecture
module "load_balancer" {
  source             = "./modules/load-balancer"
  mig_instance_group = module.mig.instance_group_manager_id
  health_check_id    = module.health_check.health_check_id
}