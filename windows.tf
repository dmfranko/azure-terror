resource "azurerm_subnet" "windows" {
  name                 = "windows-subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes       = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "windows" {
  count                = var.windows_count + 1
  name                 = "windows-pip-${count.index}"

  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "windows" {
  count                = var.windows_count + 1
  name                 = "windows-nic-${count.index}"
  location             = azurerm_resource_group.example.location
  resource_group_name  = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "example"
    subnet_id                     = azurerm_subnet.windows.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.windows[count.index].id
  }
}


resource "azurerm_windows_virtual_machine" "example" {
  count              = var.windows_count 
  name               = "vm-windows-${count.index}"

  location           = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  network_interface_ids = [azurerm_network_interface.windows[count.index].id]
  size                 = "Standard_DS1_v2"
  admin_username      = "adminuser"
  admin_password      = "P@ssw0rd!aaa"

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  os_disk {
    name              = "win-os-disk-${count.index}"
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
}


resource "azurerm_windows_virtual_machine" "mid" {
  name               = "SNMID"

  location           = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  network_interface_ids = [azurerm_network_interface.windows[var.windows_count].id]
  size                 = "Standard_DS1_v2"
  admin_username      = "adminusers"
  admin_password      = "P@ssw0rd!aaa"

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  os_disk {
    name              = "mid-os-disk"
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
}

locals {
  yourPowerShellScript= try(file("load.ps1"), null)
  base64EncodedScript = base64encode(local.yourPowerShellScript)
}

resource "azurerm_virtual_machine_extension" "mid" {
  name                 = "hostname"
  virtual_machine_id   = azurerm_windows_virtual_machine.mid.id
  publisher            = "Microsoft.Compute"
  depends_on           = [azurerm_windows_virtual_machine.mid]
  type                 = "CustomScriptExtension"
  failure_suppression_enabled  = true
  type_handler_version = "1.8"

  protected_settings = <<SETTINGS
  {
   "commandToExecute": "powershell -command \"[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String('${local.base64EncodedScript }')) | Out-File -filepath postBuild.ps1\" && powershell -ExecutionPolicy Unrestricted -File postBuild.ps1 -user ${var.mid_user} -password ${var.mid_password} -midname ${var.mid_name} -instance ${var.mid_instance}"
  }
  SETTINGS
}