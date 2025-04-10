resource "azurerm_virtual_network" "bachelor" {
  name                = var.naming.virtual_network.name
  address_space       = [var.network_configuration.vnet.address_space]
  location            = var.region
  resource_group_name = var.rg_name
}

resource "azurerm_subnet" "bachelor" {
  for_each             = var.network_configuration.subnets
  name                 = "${var.naming.subnet.name}-${each.key}"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.bachelor
  address_prefixes     = [each.value.address_space]
}

resource "azurerm_subnet" "gateway" {
  name                 = "GatewaySubnet"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.bachelor
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "bachelor" {
  name                = var.naming.network_security_group.name
  location            = var.region
  resource_group_name = var.rg_name

  for_each = var.network_configuration.nsg.security_rule
  security_rule {
    name                   = each.value.name
    priority               = each.value.priority
    direction              = each.value.direction
    access                 = each.value.access
    protocol               = each.value.protocol
    destination_port_range = each.value.destination_port_range
  }
}
