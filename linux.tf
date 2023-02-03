resource "azurerm_subnet" "linux" {
  name                 = "linux-subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes       = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "linux" {
  count                = var.linux_count
  name                 = "linux-nic-${count.index}"
  location             = azurerm_resource_group.example.location
  resource_group_name  = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "example"
    subnet_id                     = azurerm_subnet.linux.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "example" {
  count              = var.linux_count
  name               = "vm-linux-${count.index}"
  location           = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  network_interface_ids = [azurerm_network_interface.linux[count.index].id]
  size                 = "Standard_DS1_v2"
  disable_password_authentication = false
  admin_username      = "adminuser"
  admin_password      = "P@ssw0rd!"

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  os_disk {
    name              = "example-os-disk-${count.index}"
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
}