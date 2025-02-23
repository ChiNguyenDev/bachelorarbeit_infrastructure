resource "azurerm_network_interface" "bachelor" {
  name                = "${var.naming.network_interface.name}-${var.count_index}"
  location            = var.region
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = "test-ip-${var.count_index}"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "main" {
  name                  = "${var.naming.virtual_machine.name}-${var.count_index}"
  location              = var.region
  resource_group_name   = var.rg_name
  network_interface_ids = [azurerm_network_interface.bachelor.id]
  vm_size               = var.vm_configuration.instance_properties.vm_size

  storage_image_reference {
    publisher = var.vm_configuration.storage_image_reference.publisher
    offer     = var.vm_configuration.storage_image_reference.offer
    sku       = var.vm_configuration.storage_image_reference.sku
    version   = var.vm_configuration.storage_image_reference.version
  }
  storage_os_disk {
    name              = "os-disk-${var.count_index}"
    caching           = var.vm_configuration.storage_os_disk.caching
    create_option     = var.vm_configuration.storage_os_disk.create_option
    managed_disk_type = var.vm_configuration.storage_os_disk.managed_disk_type
  }
  os_profile {
    computer_name  = "${var.naming.virtual_machine.name}-${var.count_index}"
    admin_username = "admin${var.count_index}"
  }
  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/admin${var.count_index}/.ssh/authorized_keys"
      key_data = file("${path.module}/bachelorserver.pub")
    }
  }
}
