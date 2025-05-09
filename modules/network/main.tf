data "azurerm_virtual_network" "bachelor" {
  name                = "vnet-hsh-ba-test" #10.0.0.0/16
  resource_group_name = var.rg_name
}

resource "azurerm_subnet" "bachelor" {
  for_each             = var.network_configuration.subnets
  name                 = "${var.naming.subnet.name}-${each.key}"
  resource_group_name  = var.rg_name
  virtual_network_name = data.azurerm_virtual_network.bachelor.name
  address_prefixes     = [each.value.address_space]
}

resource "azurerm_network_security_group" "bachelor" {
  name                = var.naming.network_security_group.name
  location            = var.region
  resource_group_name = var.rg_name

  dynamic "security_rule" {
    for_each = var.network_configuration.nsg
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port_range
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
    }
  }
}

# Route Table zur Umleitung des Traffics an das VPN-Gateway
resource "azurerm_route_table" "bachelor" {
  name                = "gateway-route-table"
  location            = var.region
  resource_group_name = var.rg_name

  route {
    name           = "to-local-network"
    address_prefix = "141.71.31.0/24"
    next_hop_type  = "VirtualNetworkGateway"
  }
}

resource "azurerm_subnet_route_table_association" "bachelor" {
  subnet_id      = azurerm_subnet.bachelor["vm"].id
  route_table_id = azurerm_route_table.bachelor.id
}