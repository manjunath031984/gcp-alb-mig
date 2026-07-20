# GCP Production-Ready Auto-Healing High-Availability Web Cluster

This project defines a scalable, multi-zone web infrastructure stack using Terraform on Google Cloud Platform. It provisions a custom VPC network, an autoscaling Regional Managed Instance Group running Apache2, and points traffic down through a Global External Application Load Balancer.

## Architecture Blueprint Overview
1. **Network Boundary**: Custom Mode VPC with isolated firewall tags capturing only HTTP/S and diagnostic monitoring tools.
2. **Compute Resiliency**: Regional MIG distributing dynamic virtual instances within target threshold metrics across zones safely.
3. **Traffic Distribution**: Edge Global external Load Balancer handling termination routing configurations dynamically.

## Prerequisites
* Terraform CLI `v1.13.x` locally installed.
* Authenticated GCP Account with administrative ownership access over Project ID: `gcp-dev-july-2026`.
* Google Cloud SDK CLI tool suite loaded for execution parsing.

## Deployment Sequences

### 1. Initialize Working Directory
Downloads structural backend providers and standard state configuration wrappers.
```bash
terraform init
### 2. Layout Standardization Linting
Auto formats workspace parameters to preserve clean semantic spacing.
``bash
terraform fmt -recursive
### 3. Syntax Verification Validation
Confirms infrastructure logic integrity maps safely to provider properties.
``bash
terraform validate
### 4. Speculative Execution Execution Blueprinting
Pre-calculates precise cloud target provisioning maps before live execution runs.
``bash
terraform plan
### 5. Final Workspace Deployment Build
Applies runtime state parameters directly to active GCP projects.
``bash
terraform apply -auto-approve
### 6. Destructive Tear Down Verification
Tears down active components to clear billing state scopes.
``bash
terraform destroy -auto-approve