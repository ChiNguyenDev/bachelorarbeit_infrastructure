module "naming" {
  source  = "Azure/naming/azurerm"
  version = "0.4.2"
  suffix = [ "hsh-ba-test" ]
} 

resource "azurerm_resource_group" "bachelor" {
  name     = module.naming.resource_group.name
  location = var.region
}

module "vm" {
    source = "./modules/vm/"
    count = var.vm_configuration.vm_count
    count_index = "${count.index}"
    vm_configuration = var.vm_configuration
    rg_name = azurerm_resource_group.bachelor.name
    region = var.region
    naming = module.naming
    subnet_id = module.network.vm_subnet_id
}

module "network" {
    source = "./modules/network/"
    rg_name = azurerm_resource_group.bachelor.name
    region = var.region
    naming = module.naming
    network_configuration = var.network_configuration
}

module "bastion" {
    source = "./modules/bastion_vm/"
    rg_name = azurerm_resource_group.bachelor.name
    region = var.region
    naming = module.naming
    bastion_subnet_id = module.network.bastion_subnet_id
}
