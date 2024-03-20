locals {
  subscription_guids_list = length(var.subscription_guids_list) == 0 ? [data.azurerm_subscription.primary.subscription_id] : var.subscription_guids_list
  subscription_ids_list     = [for sub in local.subscription_guids_list : "/subscriptions/${sub}"]
}

resource "azurerm_role_definition" "ciscomcd_controller_role" {
  name        = "${var.prefix}-vtxcontroller-role"
  scope       = local.subscription_ids_list[0]
  description = "Custom role name that's assigned to the app for accessing Azure Environment"

  permissions {
    actions = [
      "Microsoft.ApiManagement/service/*",
      "Microsoft.Compute/disks/*",
      "Microsoft.Compute/images/read",
      "Microsoft.Compute/sshPublicKeys/read",
      "Microsoft.Compute/virtualMachines/*",
      "Microsoft.ManagedIdentity/userAssignedIdentities/read",
      "Microsoft.ManagedIdentity/userAssignedIdentities/assign/action",
      "Microsoft.Network/loadBalancers/*",
      "Microsoft.Network/networkinterfaces/*",
      "Microsoft.Network/networkSecurityGroups/*",
      "Microsoft.Network/publicIPAddresses/*",
      "Microsoft.Network/routeTables/*",
      "Microsoft.Network/virtualNetworks/*",
      "Microsoft.Network/virtualNetworks/subnets/*",
      "Microsoft.Resources/subscriptions/resourcegroups/*",
      "Microsoft.Storage/storageAccounts/blobServices/*",
      "Microsoft.Storage/storageAccounts/listkeys/action",
      "Microsoft.Network/networkWatchers/*",
      "Microsoft.Network/applicationSecurityGroups/*",
      "Microsoft.Compute/diskEncryptionSets/read"
    ]
  }
  assignable_scopes = local.subscription_ids_list
}

resource "azurerm_role_assignment" "ciscomcd_controller_role_assignment" {
  count              = length(local.subscription_ids_list)
  scope              = local.subscription_ids_list[count.index]
  role_definition_id = azurerm_role_definition.ciscomcd_controller_role.role_definition_resource_id
  principal_id       = azuread_service_principal.ciscomcd-controller.object_id
}
