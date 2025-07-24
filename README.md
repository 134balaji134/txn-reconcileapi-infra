# txn-reconcileapi-infra

This repository contains infrastructure-as-code (IaC) for securely deploying and operating the `txn-reconcileapi` microservice across multiple AWS environments (dev, stg, prod) using Terraform. The design follows security best practices and is compatible with PCI DSS Level 1 expectations.

---

## Features

- **Modular Terraform**: Reusable modules for VPC, security groups, ALB, EC2/ASG, etc.
- **Environment Isolation**: Separate configuration for dev, stg, and prod (see `/environments/`).
- **Secure Networking**: ALB in public subnets; EC2 in private subnets; strict security groups.
- **Blue/Green Ready**: Design supports rolling or blue/green deployment patterns.
- **Tagging & Inventory**: Includes scripts for tagging and auditing AWS resources.
- **State Management**: S3 backend with DynamoDB state locking (see `backend.tf` in each environment).
- **PCI DSS Alignment**: All secrets managed outside repo, tagging for PCI scope, encrypted state.

---

## Repository Structure

```
modules/
  alb/         # ALB and Target Group
  sg/          # Security Groups for ALB and EC2
  ...
environments/
  dev/
    dev.tfvars
    variables.tf
  stg/
    stg.tfvars
    outputs.tf
    backend.tf
  prod/
    prod.tfvars
scripts/
  user_data.sh           # Sample EC2 user data (installs Docker, runs container)
  tag_and_inventory.sh   # Tags untagged AWS resources and outputs inventory CSV
```

---

## Usage

### Prerequisites

- [Terraform](https://terraform.io/) >= 1.0
- AWS CLI configured with profiles for each environment
- S3 bucket and DynamoDB table for remote state and locking
- ACM certificates for ALB (ARNs in tfvars)

### Deploying an Environment

1. **Initialize Terraform**
   ```sh
   cd environments/dev    # or stg/prod
   terraform init
   ```

2. **Plan**
   ```sh
   terraform plan -var-file=dev.tfvars
   ```

3. **Apply**
   ```sh
   terraform apply -var-file=dev.tfvars
   ```

### Tag & Inventory Script

To tag untagged resources and produce an audit CSV:
```sh
cd scripts
bash tag_and_inventory.sh us-east-1
```
Outputs `aws_inventory_us-east-1.csv`.

---

## Security & Compliance

- All resources tagged for audit (`pci_scope`)
- Security Groups restrict all traffic to only what is necessary
- EC2 instances managed via SSM (no SSH keys)
- Terraform state encrypted and locked

---

## Customization

- Update AMI IDs, ACM certificate ARNs, and desired instance types in each environment's tfvars.
- Adjust scaling parameters in tfvars as needed.

---

## See Also

- [Terraform AWS Provider Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [PCI DSS Guidance](https://www.pcisecuritystandards.org/)

---

## License

Assignment/demo use only.

---

> **Note:** This README summarizes only part of the repository. For full details, review the code and modules in [the GitHub repo](https://github.com/134balaji134/txn-reconcileapi-infra).
