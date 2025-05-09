# ========================================================================================
# Dieses Terraform Skript wurde im Rahmen der Bachelorarbeit von Chi Cuong Nguyen erstellt
# ========================================================================================

module "naming" {
  source  = "Azure/naming/azurerm"
  version = "0.4.2"
  suffix = [ "hsh-ba-test" ]
} 

data "azurerm_resource_group" "bachelor" {
  name = "rg-hsh-ba-test"
}

module "vm" {
    source = "./modules/vm/"
    count = var.vm_configuration.vm_count
    count_index = "${count.index}"
    vm_configuration = var.vm_configuration
    rg_name = data.azurerm_resource_group.bachelor.name
    region = var.region
    naming = module.naming
    subnet_id = module.network.vm_subnet_id
    tools_sas_token = var.tools_sas_token
    admin_password = var.admin_password
}

module "network" {
    source = "./modules/network/"
    rg_name = data.azurerm_resource_group.bachelor.name
    region = var.region
    naming = module.naming
    network_configuration = var.network_configuration
}

