# txn-reconcileapi-infra

Modular, dynamic, multi-environment Terraform infrastructure for PCI DSS Level 1 APIs using EC2, ALB, secure VPC, IAM, and SG.

## Structure

- Dedicated folders for dev, stg, and prod environments, each fully isolated.
- Modules (VPC, SG, IAM, ALB, EC2) in `/modules` used by each environment.
- CI/CD with GitHub Actions: `.github/workflows/terraform-ci.yml`
- User data script in `scripts/`

## Usage

1. `cd environments/dev` (or `stg` or `prod`)
2. Edit the `*.tfvars` and `backend.tf` for your environment.
3. `terraform init`
4. `terraform plan -var-file=dev.tfvars`
5. `terraform apply -var-file=dev.tfvars`

## CI/CD

- [Terraform CI](.github/workflows/terraform-ci.yml) runs fmt, validate, and plan on PR/merge.

## Security & Compliance

- All modules support tagging and are PCI-DSS Level 1 ready; see [ARCHITECTURE.md](ARCHITECTURE.md) for details and next steps.