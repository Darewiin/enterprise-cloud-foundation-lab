# variables.tf
# Reusable inputs. Every value has a default, so you can apply without a tfvars file.

variable "location" {
  type        = string
  description = "Azure region for resources."
  default     = "eastus"
}

variable "org_prefix" {
  type        = string
  description = "Short name used to prefix resource names (e.g. rg-northgate-identity)."
  default     = "northgate"
}

variable "allowed_locations" {
  type        = list(string)
  description = "Regions permitted by the Allowed Locations policy."
  default     = ["eastus", "eastus2"]
}

variable "common_tags" {
  type        = map(string)
  description = "Tags applied to every resource — your governance/tagging strategy as code."
  default = {
    environment = "lab"
    project     = "enterprise-cloud-foundation"
    owner       = "Darwin Marmolejos"
    managed_by  = "Terraform"
  }
}
