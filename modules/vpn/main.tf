resource "azurerm_local_network_gateway" "onpremise" {
  name                = var.naming.local_network_gateway
  location            = var.region
  resource_group_name = var.rg_name
  gateway_address     = "168.62.225.23"
  address_space       = ["10.1.1.0/24"]
}

resource "azurerm_public_ip" "bachelor" {
  name                = "${var.naming.public_ip}-gateway"
  location            = var.region
  resource_group_name = var.rg_name
  allocation_method   = "Dynamic"
}

resource "azurerm_virtual_network_gateway" "bachelor" {
  name                = var.naming.virtual_network_gateway
  location            = var.region
  resource_group_name = var.rg_name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = "Basic"

  ip_configuration {
    public_ip_address_id          = azurerm_public_ip.bachelor.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = var.gateway_subnet_id
  }
}

resource "azurerm_virtual_network_gateway_connection" "bachelor" {
  name                = var.naming.virtual_network_gateway_connection
  location            = var.region
  resource_group_name = var.rg_name

  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.bachelor.id
  local_network_gateway_id   = azurerm_local_network_gateway.onpremise.id

  shared_key = var.shared_key
}