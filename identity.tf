# identity.tf
# Entra ID security groups defined as code. These are the same kind of groups
# your Conditional Access, PIM, and Intune policies target — now version-controlled
# and reproducible instead of clicked together by hand.

# A standard (assigned-membership) security group for the help desk team.
resource "azuread_group" "helpdesk" {
  display_name     = "Northgate-Helpdesk"
  description      = "Help desk staff - managed by Terraform"
  security_enabled = true
}

# A DYNAMIC device group that automatically includes every Windows device.
# Your Intune compliance policy (Phase 5) will target this group, so new
# Windows 11 devices are covered automatically as they enroll.
#
# NOTE: dynamic membership requires a Microsoft Entra ID P1 license (you used
# these in your UEM Lab, so your tenant should already have it). If apply fails
# on this resource with a licensing error, see the fallback in the chat.
resource "azuread_group" "windows_devices" {
  display_name     = "Northgate-Windows11-Devices"
  description      = "All Windows devices - dynamic membership, managed by Terraform"
  security_enabled = true
  types            = ["DynamicMembership"]

  dynamic_membership {
    enabled = true
    rule    = "device.deviceOSType -eq \"Windows\""
  }
}
