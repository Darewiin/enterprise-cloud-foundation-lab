# providers.tf

provider "azurerm" {
  features {}

  # Don't bulk-register every Azure resource provider on each run.
  # Azure auto-registers the ones we actually use (resource groups, policy, etc.).
  # Keeps plans fast and avoids needing subscription-wide registration rights.

 skip_provider_registration = true
}

provider "azuread" {}
