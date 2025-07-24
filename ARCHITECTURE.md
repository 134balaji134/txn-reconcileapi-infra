# Architecture Overview

## Assumptions

- Three environments: dev, stg, prod (see `/environments/`)
- EC2 in Auto Scaling Group behind an ALB.
- No PAN data, but PCI DSS Level 1 controls expected.
- All secrets managed outside repo (e.g., AWS Secrets Manager).

## Networking

| Component      | CIDR Example      | Notes                |
|----------------|------------------|----------------------|
| VPC            | 10.x.0.0/16      | One per env          |
| Public Subnets | 10.x.1.0/24...   | For ALB              |
| Private Subnets| 10.x.10.0/24...  | For EC2, RDS         |

## Compute

| Component    | Description                           |
|--------------|---------------------------------------|
| EC2 ASG      | Private subnets, Launch Template, SSM |
| ALB          | HTTPS, ACM cert, public subnet        |

## Security

- ALB only allows HTTPS from the internet
- EC2 only allows HTTP from ALB SG
- SSM enabled, no SSH keys
- Roles scoped to least privilege

## DR & Compliance

- Multi-AZ for all critical resources
- Tags for all resources
- All state encrypted and locked
- Next Steps: Enable AWS Config, GuardDuty, WAF, detailed logging

## Risks/Next Steps

- Confirm logging/monitoring with auditors
- Harden AMIs and patching
- Set up alerting for drift and security events
- Consider backup/restore automation for RDS (if used)