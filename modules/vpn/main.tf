resource "azurerm_public_ip" "gateway" {
  name                = var.naming.public_ip.name
  location            = var.region
  resource_group_name = var.rg_name

  allocation_method = "Dynamic"
}

resource "azurerm_virtual_network_gateway" "gateway" {
  name                = "hsh-ba-test-gateway"
  location            = var.region
  resource_group_name = var.rg_name

  type     = "Vpn"
  vpn_type = "RouteBased"
  sku           = "VpnGw1"

  ip_configuration {
    name                          = "vpngw-ipconfig"
    public_ip_address_id          = azurerm_public_ip.gateway.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = var.gateway_subnet_id
  }

  vpn_client_configuration {
    address_space = ["172.16.0.0/24"]

    root_certificate {
      name = "MyRootCert"
      public_cert_data = filebase64("${path.module}/certs/root-cert.pem")
    }
  }
}