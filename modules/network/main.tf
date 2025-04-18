data "azurerm_virtual_network" "bachelor" {
  name                = "vnet-hsh-ba-test"
  resource_group_name = "rg-hsh-ba-test"
}

resource "azurerm_subnet" "bachelor" {
  for_each             = var.network_configuration.subnets
  name                 = "${var.naming.subnet.name}-${each.key}"
  resource_group_name  = var.rg_name
  virtual_network_name = data.azurerm_virtual_network.bachelor.name
  address_prefixes     = [each.value.address_space]
}

resource "azurerm_subnet" "gateway" {
  name                 = "GatewaySubnet"
  resource_group_name  = var.rg_name
  virtual_network_name = data.azurerm_virtual_network.bachelor.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "bachelor" {
  name                = var.naming.network_security_group.name
  location            = var.region
  resource_group_name = var.rg_name

  for_each = var.network_configuration.nsg
  security_rule {
    name                   = each.value.name
    priority               = each.value.priority
    direction              = each.value.direction
    access                 = each.value.access
    protocol               = each.value.protocol
    destination_port_range = each.value.destination_port_range
  }
}
