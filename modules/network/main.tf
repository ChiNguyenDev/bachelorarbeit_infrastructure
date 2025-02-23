resource "azurerm_virtual_network" "bachelor" {
  name                = var.naming.virtual_network.name
  address_space       = [var.network_configuration.vnet.address_space]
  location            = var.region
  resource_group_name = var.rg_name
}

resource "azurerm_subnet" "bachelor" {
  name                 = var.naming.subnet.name
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.bachelor
  address_prefixes     = [var.network_configuration.subnet.address_space]
}

resource "azurerm_network_security_group" "bachelor" {
  name                = var.naming.network_security_group.name
  location            = var.region
  resource_group_name = var.rg_name

  security_rule {
    name                   = var.network_configuration.nsg.name
    priority               = var.network_configuration.nsg.priority
    direction              = var.network_configuration.nsg.direction
    access                 = var.network_configuration.nsg.access
    protocol               = var.network_configuration.nsg.protocol
    destination_port_range = var.network_configuration.nsg.destination_port_range
  }
}
