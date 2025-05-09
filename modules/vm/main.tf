locals {
  script_name = "auswertung_skript.sh"
}

# initiiert ein Netzwerkinterface mit fester privater ip
resource "azurerm_network_interface" "bachelor" {
  name                = "${var.naming.network_interface.name}-${var.count_index}"
  location            = var.region
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = "test-ip-${var.count_index}"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    private_ip_address            = "10.0.2.${4 + var.count_index}"
  }
}

# Definition der Linux-VM, inkl. Admin-Zugang & Image
resource "azurerm_linux_virtual_machine" "bachelor" {
  name                = "${var.naming.virtual_machine.name}-${var.count_index}"
  resource_group_name = var.rg_name
  location            = var.region
  size                = var.vm_configuration.instance_properties.vm_size
  admin_username      = "hsh-admin${var.count_index}"
  network_interface_ids = [
    azurerm_network_interface.bachelor.id,
  ]
  admin_password = var.admin_password
  disable_password_authentication = false

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = var.vm_configuration.storage_image_reference.publisher
    offer     = var.vm_configuration.storage_image_reference.offer
    sku       = var.vm_configuration.storage_image_reference.sku
    version   = var.vm_configuration.storage_image_reference.version
  }
}

# VM-Erweiterung: Führt das Auswertungsskript nach Start aus
resource "azurerm_virtual_machine_extension" "bachelor" {
  name                 = "auswertung_skript_extension"
  virtual_machine_id   = azurerm_linux_virtual_machine.bachelor.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = jsonencode({
    commandToExecute = "sudo nohup bash ${local.script_name} > /var/log/script.log 2>&1 &"
  })

  protected_settings = jsonencode({
    fileUris = ["https://tfbackendstorage2210.blob.core.windows.net/scripts/${local.script_name}?${var.tools_sas_token}"]
  })
}


