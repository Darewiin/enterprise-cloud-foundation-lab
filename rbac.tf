# rbac.tf
# Least-privilege RBAC: roles are scoped to a single resource group rather than
# the whole subscription, so each group gets only the access it actually needs.
# Limiting blast radius like this is a core security principle — and a great
# interview talking point.

# Give the help desk read-only visibility into the identity resource group.
resource "azurerm_role_assignment" "helpdesk_reader" {
  scope                = azurerm_resource_group.identity.id
  role_definition_name = "Reader"
  principal_id         = azuread_group.helpdesk.object_id
}
