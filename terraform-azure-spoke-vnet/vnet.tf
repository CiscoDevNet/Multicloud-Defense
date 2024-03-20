resource "azurerm_virtual_network" "spoke_vnet" {
  name                = "${var.prefix}-vnet"
  resource_group_name = azurerm_resource_group.app_rg.name
  location            = var.location
  address_space       = [var.vnet_cidr]
}

resource "azurerm_subnet" "subnet" {
  name                 = "${var.prefix}-subnet"
  resource_group_name  = azurerm_resource_group.app_rg.name
  virtual_network_name = azurerm_virtual_network.spoke_vnet.name
  address_prefixes     = [cidrsubnet(var.vnet_cidr, var.subnet_bits, 0)]
}

resource "azurerm_route_table" "route_table" {
  name                = "${var.prefix}-route-table"
  location            = var.location
  resource_group_name = azurerm_resource_group.app_rg.name

  route {
    name           = "Internet"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "Internet"
  }
  dynamic "route" {
    for_each = local.external_ips
    content {
      name           = route.value
      address_prefix = "${route.value}/32"
      next_hop_type  = "Internet"
    }
  }
}

resource "azurerm_subnet_route_table_association" "route_table_association" {
  subnet_id      = azurerm_subnet.subnet.id
  route_table_id = azurerm_route_table.route_table.id
}
