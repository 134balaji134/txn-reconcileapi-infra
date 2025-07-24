# Terraform CI/CD with Manual Apply & GitHub Environments

This repository uses a secure and review-driven workflow for deploying infrastructure with [Terraform](https://www.terraform.io/) using [GitHub Actions](https://docs.github.com/en/actions). The workflow is designed to automatically plan infrastructure changes and apply them only after manual approval, following best practices for production-grade infrastructure as code (IaC).

---

## Workflow Overview

- **Terraform Plan:**  
  Runs automatically on every pull request and push to `main`.  
  - Checks code formatting (`terraform fmt`)
  - Validates configuration (`terraform validate`)
  - Generates and uploads a Terraform execution plan

- **Terraform Apply:**  
  Runs only after a push to the `main` branch and requires manual approval via [GitHub Environments](https://docs.github.com/en/actions/deployment/targeting-different-environments/using-environments-for-deployment).  
  - Downloads the execution plan
  - Applies changes to your cloud environment

---

## Security & Best Practices

- **Manual Approval:**  
  `terraform apply` will only run after someone with appropriate permissions approves the run in the GitHub UI.

- **Branch Protection:**  
  Only applies changes on `main`. No applies are performed on pull requests or forks.

- **Cloud Credentials:**  
  Store all necessary cloud provider credentials as [GitHub Secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets).

- **Environment URLs:**  
  After apply, if you output a public endpoint (like an ALB DNS), it can be surfaced in the Actions UI for easy access.

---

## How to Set Up

1. **Configure GitHub Environments:**
   - Go to **Settings > Environments** in your repository.
   - Create an environment (e.g., `production`, `dev`, `stg`).
   - Set required reviewers if needed.

2. **Add Cloud Credentials:**
   - Add your cloud provider credentials as repository secrets (e.g., `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`).

3. **Adjust the Workflow (if needed):**
   - Edit `.github/workflows/terraform-ci.yml` to match your environment names and variable files.

---

## Running the Workflow

- **On PR or push:**  
  The workflow runs `terraform plan` and shows the output in the Actions tab.
- **On merge to main:**  
  After code review and approval, the plan is available for apply.
- **Manual approval required:**  
  A reviewer must approve the job in the GitHub Actions UI before `terraform apply` will execute.

---

## Example Workflow File

See `.github/workflows/terraform-ci.yml` in this repository for the full workflow.

---

## References

- [Terraform Docs](https://www.terraform.io/docs/)
- [GitHub Actions Docs](https://docs.github.com/en/actions)
- [Environments for Deployment](https://docs.github.com/en/actions/deployment/targeting-different-environments/using-environments-for-deployment)
- [Securing Environments](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/about-environment-protection-rules)