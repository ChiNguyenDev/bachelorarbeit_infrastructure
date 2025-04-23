resource "azurerm_virtual_network" "bachelor" {
  name                = var.naming.virtual_network.name
  address_space       = ["10.0.0.0/16"]
  location            = var.region
  resource_group_name = var.rg_name
}

resource "azurerm_subnet" "bachelor" {
  for_each             = var.network_configuration.subnets
  name                 = "${var.naming.subnet.name}-${each.key}"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.bachelor.name
  address_prefixes     = [each.value.address_space]
}

resource "azurerm_network_security_group" "bachelor" {
  name                = var.naming.network_security_group.name
  location            = var.region
  resource_group_name = var.rg_name

  for_each = var.network_configuration.nsg
  security_rule {
    name                       = each.value.name
    priority                   = each.value.priority
    direction                  = each.value.direction
    access                     = each.value.access
    protocol                   = each.value.protocol
    destination_port_range     = each.value.destination_port_range
    destination_address_prefix = each.value.destination_address_prefix
    source_port_range          = each.value.source_port_range
    source_address_prefix      = each.value.source_address_prefix
  }
}
