region = "West Europe"

vm_configuration = {
  vm_count = 20 # number of vm instances
  instance_properties = {
    vm_size = "Standard_DS1_v2"
    storage_image_reference = {
      publisher = "Canonical"
      offer     = "0001-com-ubuntu-server-jammy"
      sku       = "22_04-lts"
      version   = "latest"
    }
    storage_os_disk = {
      caching           = "ReadWrite"
      create_option     = "FromImage"
      managed_disk_type = "Standard_LRS"
    }
  }
}

network_configuration = {
  vnet = {
    adress_space = "10.0.0.0/16"
  }
  subnets = {
    vm = {
      adress_space = "10.0.2.0/24"
    }
    bastion = {
      adress_space = "10.0.3.0/24"
    }
  }
  nsg = {
    name                   = "AllowSSH"
    priority               = 100
    direction              = "Inbound"
    access                 = "Allow"
    protocol               = "Tcp"
    destination_port_range = "22"
  }
}

