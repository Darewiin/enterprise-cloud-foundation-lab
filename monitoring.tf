# monitoring.tf
# Centralized logging: a Log Analytics workspace that will collect your Entra ID
# sign-in and audit logs. This is the monitoring layer of the foundation — the
# single place identity activity flows into.
#
# COST NOTE: creating the workspace is free. You're billed only for data ingested
# beyond the free 5 GB/month, which a small lab tenant won't reach. retention of
# 30 days stays inside the free retention window. You'll destroy this in Phase 6.

resource "azurerm_log_analytics_workspace" "core" {
  name                = "log-${var.org_prefix}-core"
  location            = var.location
  resource_group_name = azurerm_resource_group.monitoring.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = var.common_tags
}
