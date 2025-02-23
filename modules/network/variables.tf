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
    nsg = object({
      name = string
      priority = number
      direction = string
      access = string
      protocol = string
      destination_port_range = string
    })
  })
}
