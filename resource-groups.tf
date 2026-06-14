# resource-groups.tf
# Tagged resource groups that mirror your UEM Lab structure.
# These are the containers later phases will deploy into.

resource "azurerm_resource_group" "identity" {
  name     = "rg-${var.org_prefix}-identity"
  location = var.location
  tags     = var.common_tags
}

resource "azurerm_resource_group" "monitoring" {
  name     = "rg-${var.org_prefix}-monitoring"
  location = var.location
  tags     = var.common_tags
}
