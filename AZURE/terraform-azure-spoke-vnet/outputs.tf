output "vnet" {
  value = {
    name                = azurerm_virtual_network.spoke_vnet.name
    id                  = azurerm_virtual_network.spoke_vnet.id
    cidr                = var.vnet_cidr
    resource_group_name = azurerm_resource_group.app_rg.name
    subnet = {
      name = azurerm_subnet.subnet.name
      id   = azurerm_subnet.subnet.id
    }
  }
}

output "vms" {
  value = [
    for vm_name_key, ignore in local.vms_map :
    {
      public_ip      = azurerm_public_ip.vm_public_ip[vm_name_key].ip_address
      private_ip     = azurerm_network_interface.vm_nic[vm_name_key].private_ip_address
      security_group = azurerm_network_security_group.security_group.name
      ssh_cmd        = "ssh ubuntu@${azurerm_public_ip.vm_public_ip[vm_name_key].ip_address}"
      name           = vm_name_key
      vpc            = azurerm_virtual_network.spoke_vnet.id
      vnet           = azurerm_virtual_network.spoke_vnet.id
    }
  ]
}

output "resource_group" {
  value = {
    name        = azurerm_resource_group.app_rg.name
    console_url = "https://portal.azure.com/#@${data.azuread_domains.current.domains[0].domain_name}/resource/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${azurerm_resource_group.app_rg.name}/overview"
  }
}
