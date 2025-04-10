resource "azurerm_virtual_wan" "bachelor" {
  name                = var.naming.virtual_wan
  resource_group_name = var.rg_name
  location            = var.region
}

resource "azurerm_virtual_hub" "bachelor" {
  name                = "virtual-hub-hsh-ba-test"
  resource_group_name = var.rg_name
  location            = var.region
  virtual_wan_id      = azurerm_virtual_wan.bachelor.id
  address_prefix      = "10.0.1.0/24"
}

resource "azurerm_vpn_gateway" "example" {
  name                = module.naming.virtual_network_gateway
  location            = var.region
  resource_group_name = var.rg_name
  virtual_hub_id      = azurerm_virtual_hub.bachelor.id
}

resource "azurerm_local_network_gateway" "bachelor" {
  name                = var.naming.local_network_gateway
  resource_group_name = var.rg_name
  location            = var.region
  gateway_address     = var.local_gateway.public_ip # z. B. DynDNS oder feste IP
  address_space       = var.local_gateway.subnets   # z. B. ["192.168.1.0/24"]
}

resource "azurerm_vpn_site_to_site_connection" "home" {
  name                          = "${module.naming.virtual_network_gateway}-s2s"
  location                      = var.region
  resource_group_name           = var.rg_name
  vpn_gateway_id                = azurerm_vpn_gateway.bachelor.id
  local_network_gateway_id      = azurerm_local_network_gateway.bachelor.id
  connection_protocol           = "IKEv2"
  shared_key                    = var.shared_key

  ipsec_policy {
    dh_group         = "DHGroup2"
    encryption       = "AES256"
    integrity        = "SHA256"
    pfs_group        = "PFS2"
    sa_lifetime_sec  = 3600
    sa_data_size_kb  = 102400000
  }
}
