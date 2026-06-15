# Enterprise Cloud Foundation Lab

Terraform-provisioned Azure foundation for the **Northgate Solutions** environment — resource groups, tags, Azure Policy, Entra ID groups, least-privilege RBAC, and centralized monitoring, all defined as code.

> This is the Infrastructure-as-Code layer of a larger initiative. See the **[Enterprise Cloud Security Portfolio](https://github.com/darewiin/enterprise-cloud-security-portfolio)** hub for the full architecture, the IaC boundary, and how this connects to the identity, endpoint, and email-security work.

---

## What this provisions

| File | Resources |
|------|-----------|
| `resource-groups.tf` | Tagged resource groups (`rg-northgate-identity`, `rg-northgate-monitoring`) |
| `governance.tf` | "Allowed locations" Azure Policy assignment |
| `identity.tf` | `Northgate-Helpdesk` group and the dynamic `Northgate-Windows11-Devices` group |
| `rbac.tf` | Reader role for Helpdesk, scoped least-privilege to one resource group |
| `monitoring.tf` | `log-northgate-core` Log Analytics workspace |
| `outputs.tf` | Resource names and IDs surfaced after apply |

### What this deliberately does NOT provision

Conditional Access, PIM, and Intune compliance are operated in the portal by design — to avoid tenant-wide lockout risk and preserve approval workflows. See the hub's `SECURITY-DECISIONS.md` for the full reasoning behind the boundary.

---

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform) >= 1.5
- [Azure CLI](https://learn.microsoft.com/cli/azure/) (authenticated via `az login`)
- An Azure subscription and a Microsoft Entra tenant

---

## Usage

```bash
# Authenticate
az login

# Initialize providers (run once)
terraform init

# Preview changes
terraform plan

# Apply
terraform apply
```

All variables have defaults in `variables.tf`, so no `terraform.tfvars` is required. To override them, copy `terraform.tfvars.example` to `terraform.tfvars` and edit.

To tear everything down:

```bash
terraform destroy
```

---

## Providers

- `hashicorp/azurerm` (~> 3.0) — Azure resources
- `hashicorp/azuread` (~> 2.0) — Entra ID objects

---

## Notes

- **State is local** for this lab. A production deployment would use a remote backend (Azure Storage) with state locking.
- **No secrets are committed.** State files and any real `terraform.tfvars` are gitignored; only the non-secret `terraform.tfvars.example` is published.
- See **[TROUBLESHOOTING.md](TROUBLESHOOTING.md)** for issues encountered during the build and how they were resolved.
