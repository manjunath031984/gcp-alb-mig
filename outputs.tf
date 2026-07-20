output "vpc_name" {
  value       = module.vpc.vpc_name
  description = "The computed name of the primary VPC environment."
}

output "subnet_name" {
  value       = module.vpc.subnet_name
  description = "The computed identifier for the target subnet configuration."
}

output "instance_template_name" {
  value       = module.instance_template.template_name
  description = "The generated production immutable instance template identifier."
}

output "managed_instance_group_name" {
  value       = module.mig.mig_name
  description = "The name of the regional managed instance group."
}

output "health_check_name" {
  value       = module.health_check.health_check_name
  description = "The structural tracking name of the active health checking engine."
}

output "backend_service_name" {
  value       = module.load_balancer.backend_service_name
  description = "The upstream routing engine component name for the Load Balancer."
}

output "load_balancer_name" {
  value       = module.load_balancer.url_map_name
  description = "The central structural URL Map reference defining the HTTP Load Balancer."
}

output "global_ip_address" {
  value       = module.load_balancer.global_ip
  description = "The structural edge dynamic IP address mapped to the internet."
}

output "application_url" {
  value       = "http://${module.load_balancer.global_ip}"
  description = "The direct address link to evaluate external web target loads across clusters."
}