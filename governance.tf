# governance.tf
# One Azure Policy guardrail: "Allowed locations" — restricts which regions
# resources can be deployed to. This is governance expressed as code.

# Look up the current subscription so we never hardcode its ID.
data "azurerm_subscription" "current" {}

# Reference the built-in "Allowed locations" policy definition by name.
data "azurerm_policy_definition" "allowed_locations" {
  display_name = "Allowed locations"
}

# Assign the policy at the subscription scope.
resource "azurerm_subscription_policy_assignment" "allowed_locations" {
  name                 = "northgate-allowed-locations"
  display_name         = "Northgate - Allowed Locations"
  description          = "Restricts the regions where resources can be deployed."
  subscription_id      = data.azurerm_subscription.current.id
  policy_definition_id = data.azurerm_policy_definition.allowed_locations.id

  parameters = jsonencode({
    listOfAllowedLocations = {
      value = var.allowed_locations
    }
  })
}
