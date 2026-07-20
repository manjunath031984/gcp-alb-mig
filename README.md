# GCP Production-Ready Auto-Healing High-Availability Web Cluster

This project provisions a **production-ready, highly available, auto-healing web infrastructure** on **Google Cloud Platform (GCP)** using **Terraform**. The deployment includes a custom VPC, firewall rules, a Regional Managed Instance Group (MIG) running Apache2, HTTP health checks, autoscaling, and a Global External Application Load Balancer.

---

# Architecture Overview

The infrastructure consists of the following components:

1. **Networking**
   - Custom Mode VPC
   - Public Subnet
   - Firewall Rules (SSH, HTTP, HTTPS, Health Check)

2. **Compute**
   - Compute Engine Instance Template
   - Apache2 Startup Script
   - Regional Managed Instance Group (MIG)
   - Auto-Healing
   - Autoscaling

3. **Load Balancing**
   - Global Static IP Address
   - Backend Service
   - HTTP Health Check
   - URL Map
   - HTTP Target Proxy
   - Global Forwarding Rule

---

# Project Structure

```text
.
├── backend.tf
├── providers.tf
├── versions.tf
├── variables.tf
├── terraform.tfvars
├── locals.tf
├── main.tf
├── outputs.tf
├── startup-script.sh
├── README.md
└── modules
    ├── vpc
    ├── firewall
    ├── instance-template
    ├── health-check
    ├── mig
    └── load-balancer
```

---

# Prerequisites

Before deploying the infrastructure, ensure the following requirements are met:

- Terraform CLI **v1.13.x** installed
- Google Cloud SDK (gcloud) installed
- Authenticated GCP account
- A GCP project with the required APIs enabled

### Project Information

| Property | Value |
|----------|-------|
| Project ID | `gcp-dev-july-2026` |
| Region | `us-central1` |
| Zone | `us-central1-a` |

---

# Remote State Backend

Terraform state is stored securely in a Google Cloud Storage (GCS) bucket.

```hcl
terraform {
  backend "gcs" {
    bucket = "gcp-dev-july-2026-terraform-state"
    prefix = "gcp-alb-mig"
  }
}
```

Initialize using:

```bash
terraform init
```

or

```bash
terraform init -backend-config=gcp-alb-mig.tf
```

---

# Deployment Steps

## 1. Initialize Terraform

Downloads providers, configures the remote backend, and initializes the working directory.

```bash
terraform init
```

---

## 2. Format Terraform Code

Formats all Terraform files according to HashiCorp best practices.

```bash
terraform fmt -recursive
```

---

## 3. Validate Configuration

Validates the Terraform configuration for syntax and configuration errors.

```bash
terraform validate
```

---

## 4. Generate an Execution Plan

Creates an execution plan to preview infrastructure changes.

```bash
terraform plan
```

---

## 5. Deploy Infrastructure

Creates all resources in Google Cloud Platform.

```bash
terraform apply -auto-approve
```

---

## 6. Verify Deployment

After deployment, verify the following:

- Custom VPC Network
- Public Subnet
- Firewall Rules
- Instance Template
- Regional Managed Instance Group
- HTTP Health Check
- Backend Service
- Global External Load Balancer
- Public IP Address
- Apache Web Server

Access the application using:

```text
http://<LOAD_BALANCER_IP>
```

---

## 7. Destroy Infrastructure

Deletes all deployed resources.

```bash
terraform destroy -auto-approve
```

---

# Resources Created

- Custom VPC
- Public Subnet
- Firewall Rules
- Compute Instance Template
- Regional Managed Instance Group
- Autoscaler
- HTTP Health Check
- Backend Service
- URL Map
- Target HTTP Proxy
- Global Forwarding Rule
- Global Static IP Address

---

# Outputs

Terraform provides the following outputs after deployment:

- VPC Name
- Subnet Name
- Firewall Rule Names
- Instance Template Name
- Health Check Name
- Managed Instance Group Name
- Backend Service Name
- URL Map Name
- Global Load Balancer IP Address

---

# Cleanup

To remove all resources and stop billing:

```bash
terraform destroy -auto-approve
```

---

# Author

**Manjunath V**

Senior Site Reliability Engineer (SRE) | Terraform | Google Cloud Platform | DevOps | Infrastructure as Code
