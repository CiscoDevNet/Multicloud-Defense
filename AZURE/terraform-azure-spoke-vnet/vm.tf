locals {
  user_data = <<EOF
#! /bin/bash
curl -o /tmp/setup.sh https://raw.githubusercontent.com/maskiran/sample-web-app/main/ubuntu/setup_app.sh
bash /tmp/setup.sh &> /tmp/setup.log
EOF
}

resource "azurerm_public_ip" "vm_public_ip" {
  # vms_map  {vm_name: {az_name: us-east-1}}
  for_each            = local.vms_map
  name                = "${each.key}-public-ip"
  resource_group_name = azurerm_resource_group.app_rg.name
  location            = var.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "vm_nic" {
  for_each            = local.vms_map
  name                = "${each.key}-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.app_rg.name

  ip_configuration {
    name                          = "${each.key}-ip"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_public_ip[each.key].id
  }
  depends_on = [
    azurerm_network_security_group.security_group,
    azurerm_subnet.subnet,
    azurerm_public_ip.vm_public_ip
  ]
}

resource "azurerm_network_interface_security_group_association" "vm_nic_sg" {
  for_each                  = local.vms_map
  network_interface_id      = azurerm_network_interface.vm_nic[each.key].id
  network_security_group_id = azurerm_network_security_group.security_group.id
}

resource "azurerm_linux_virtual_machine" "vm" {
  for_each = local.vms_map
  name     = each.key
  location = var.location
  # zone                  = each.value.az_name
  resource_group_name   = azurerm_resource_group.app_rg.name
  network_interface_ids = [azurerm_network_interface.vm_nic[each.key].id]
  size                  = var.instance_size
  admin_username        = "ubuntu"
  custom_data           = base64encode(local.user_data)
  admin_ssh_key {
    username   = "ubuntu"
    public_key = file(var.ssh_public_key_file)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    name                 = "${each.key}-osdisk"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "22.04.202208100"
    # az vm image list --output table --publisher Canonical --offer 0001-com-ubuntu-server-jammy --sku 22_04-lts-gen2 --all
  }
}
