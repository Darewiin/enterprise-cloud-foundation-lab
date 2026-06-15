# outputs.tf
# Surface useful values after `terraform apply` — handy for verification and for
# referencing these resources in documentation or later work.

output "identity_resource_group" {
  description = "Name of the identity resource group."
  value       = azurerm_resource_group.identity.name
}

output "monitoring_resource_group" {
  description = "Name of the monitoring resource group."
  value       = azurerm_resource_group.monitoring.name
}

output "log_analytics_workspace_name" {
  description = "Name of the Log Analytics workspace."
  value       = azurerm_log_analytics_workspace.core.name
}

output "log_analytics_workspace_id" {
  description = "Resource ID of the Log Analytics workspace."
  value       = azurerm_log_analytics_workspace.core.id
}

output "helpdesk_group_object_id" {
  description = "Object ID of the Northgate-Helpdesk group."
  value       = azuread_group.helpdesk.object_id
}

output "windows_devices_group_object_id" {
  description = "Object ID of the Northgate-Windows11-Devices group."
  value       = azuread_group.windows_devices.object_id
}
