output "vm_subnet_id" {
  value = azurerm_subnet.bachelor["vm"].id
}

output "gateway_subnet_id" {
  value = azurerm_subnet.gateway.id
}

output "bastion_subnet_id" {
  value = azurerm_subnet.bachelor["bastion"].id
}