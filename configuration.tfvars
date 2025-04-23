# terraform plan -var-file="./configuration.tfvars" -var-file="./secrets.tfvars"
# terraform apply -var-file="./configuration.tfvars" -var-file="./secrets.tfvars"
# terraform destroy -var-file="./configuration.tfvars" -var-file="./secrets.tfvars"

region = "West Europe"

vm_configuration = {
  vm_count = 1 # number of vm instances
  instance_properties = {
    vm_size = "Standard_B1ms"
  }
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

network_configuration = {
  vnet = {
    address_space = "10.0.0.0/16"
  }
  subnets = {
    vm = {
      address_space = "10.0.2.0/24"
    }
    gateway = {
      address_space = "10.0.3.0/24"
    }
  }
  nsg = {
    ssh = {
      name                   = "AllowSSH"
      direction              = "Inbound"
      access                 = "Allow"
      destination_port_range = "22"
    }
  }
}


