# This bastion vm acts as a Jump hosts to the clients

resource "azurerm_public_ip" "bastion_bachelor" {
  name                = var.naming.public_ip.name
  location            = var.region
  resource_group_name = var.rg_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "bachelor" {
  name                = var.naming.bastion_host.name
  location            = var.region
  resource_group_name = var.rg_name

  ip_configuration {
    name                 = "${var.naming.bastion_host.name}-ip-config"
    subnet_id            = var.bastion_subnet_id
    public_ip_address_id = azurerm_public_ip.bastion_bachelor
  }
}
