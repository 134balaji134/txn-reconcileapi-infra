# Architecture Overview

## Assumptions

- Three environments: dev, stg, prod (see `/environments/`)
- Stateless microservice: txn-reconcileapi
- EC2 in Auto Scaling Group (ASG) behind an Application Load Balancer (ALB)
- Blue/Green deployment pattern for zero-downtime releases
- No Primary Account Number (PAN) data, but PCI DSS Level 1 controls expected
- All secrets managed outside repo (e.g., AWS Secrets Manager, SSM Parameter Store)
- Infrastructure managed via Terraform, state stored in encrypted S3 with locking

---

## Networking

| Component      | CIDR Example      | Notes                |
|----------------|------------------|----------------------|
| VPC            | 10.x.0.0/16      | One per environment  |
| Public Subnets | 10.x.1.0/24...   | For ALB              |
| Private Subnets| 10.x.10.0/24...  | For EC2, RDS, etc.   |

### Security Groups

- **ALB SG:** Allows inbound HTTPS (443) from 0.0.0.0/0
- **EC2 SG:** Allows inbound HTTP (80) only from ALB SG

---

## Compute & Deployment

| Component     | Description                                                       |
|---------------|-------------------------------------------------------------------|
| EC2 ASG Blue  | Private subnet, Launch Template, SSM, runs current "blue" version |
| EC2 ASG Green | Private subnet, Launch Template, SSM, runs candidate "green" ver. |
| ALB           | HTTPS, ACM cert, public subnet, forwards to active target group   |
| Target Groups | Separate for Blue and Green, ALB switches between these           |

---

## Blue/Green Deployment Flow

1. **Normal State:** ALB routes traffic to Blue ASG (TG-Blue).
2. **Deploy:** Provision Green ASG (TG-Green) with new version, run health checks.
3. **Switch:** ALB listener is updated to route to TG-Green.
4. **Monitor:** If healthy, destroy Blue ASG. If issues, revert ALB to TG-Blue.
5. **Repeat:** On next deployment, roles flip.

---

## Security

- ALB only allows HTTPS from the internet
- EC2 only allows HTTP from ALB SG (no direct internet access)
- SSM enabled, no SSH keys on EC2
- IAM roles scoped to least privilege (per environment and per ASG)
- All resources tagged (e.g., `pci_scope = true`)
- Encryption at rest (EBS, S3, RDS if used)
- ACM for TLS

---

## DR & Compliance

| Aspect         | Approach                                                  |
|----------------|----------------------------------------------------------|
| High Availability | Multi-AZ for ALB, EC2, and subnets                   |
| Rollback       | Blue/Green enables instant traffic reversal               |
| Backups        | (If RDS) Automated snapshots scheduled                    |
| State          | Terraform state in S3, encrypted and locked               |
| Monitoring     | CloudWatch logs, alarms; VPC flow logs                    |
| Audit          | AWS Config, resource tagging, inventory scripts           |

---

## Open Questions

- Is WAF required at this phase for public endpoints?
- Are there automated requirements for blue/green rollback and promotion logic?
- Should we integrate Infracost/cost estimation, tfsec/Checkov security scans, or policy-as-code (OPA/Sentinel) in CI/CD?
- Are there requirements for preview/review environments per PR?
- Is database DR (snapshots, cross-region) needed in MVP?

---

## Risks / Next Steps

- **Session stickiness:** May cause some users to persist on old target group briefly after switch.
- **Cost:** Double resource consumption during deploys (both Blue and Green live).
- **Manual switch:** Ensure automation for ALB target group switching is reliable and audited.
- **Logging/Monitoring:** Confirm with auditors what log retention and monitoring is required.
- **AMI hardening:** Ensure latest patches, CIS hardening, and regular updates.
- **Drift Detection:** Implement scheduled Terraform plan and alert on drift.
- **Compliance:** Expand AWS Config rules, enable GuardDuty, enable VPC/ALB access logs, enforce encryption and tagging policies.
- **Backup/restore:** Automate for any stateful resources (e.g., RDS, if added).
