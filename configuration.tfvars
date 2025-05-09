# terraform plan -var-file="./configuration.tfvars" -var-file="./secrets.tfvars"
# terraform apply -var-file="./configuration.tfvars" -var-file="./secrets.tfvars"
# terraform destroy -var-file="./configuration.tfvars" -var-file="./secrets.tfvars"

region = "West Europe"

vm_configuration = {
  vm_count = 1 # number of vm instances
  instance_properties = {
    vm_size = "Standard_D2s_v4"
  }
  storage_image_reference = {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "24_04-lts"
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
  }
  nsg = {
    ssh = {
      name                   = "AllowSSH"
      direction              = "Inbound"
      access                 = "Allow"
      destination_port_range = "22"
      priority = 100
    }
    icmp = {
      name                   = "AllowICMP"
      direction              = "Inbound"
      access                 = "Allow"
      destination_port_range = "*"
      protocol               = "Icmp"
      priority = 110
    }
    postgre = {
      name                       = "AllowPostgre"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      source_address_prefix      = "10.250.0.0/24"
      destination_port_range     = "5432"
      destination_address_prefix = "*"
      priority = 120
    }
    iperf = {
      name                       = "AllowIperf"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      source_address_prefix      = "10.250.0.0/24"
      destination_port_range     = "5201"
      destination_address_prefix = "*"
      priority = 130
    }
  }
}


