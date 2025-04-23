variable "naming" {
  type = any
}

variable "rg_name" {
  type = string
}

variable "region" {
  type = string
}

variable "network_configuration" {
  type = object({
    vnet = object({
      address_space = string
    })
    subnets = map(object({
      address_space = string
    }))
    nsg = map(object({
      name                       = string
      priority                   = optional(number, 100)
      direction                  = string
      access                     = string
      protocol                   = optional(string, "Tcp")
      source_port_range          = optional(string, "*")
      source_address_prefix      = optional(string, "*")
      destination_address_prefix = optional(string, "*")
      destination_port_range     = string
    }))
  })
}
