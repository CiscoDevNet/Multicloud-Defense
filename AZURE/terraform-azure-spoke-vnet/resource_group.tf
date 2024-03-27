resource "azurerm_resource_group" "app_rg" {
  name     = "${var.prefix}-rg"
  location = var.location
}
