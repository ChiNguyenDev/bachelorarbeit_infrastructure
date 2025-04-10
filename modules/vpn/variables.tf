variable "naming" {
  type = any
}

variable "rg_name" {
  type = string
}

variable "region" {
  type = string
}

variable "vpn_gateway_configuration" {
  type = object({
    local_gateway = object({
      gateway_address = string 
      address_space = string
    })

  })
}

variable "shared_key" {
  type = string
}

variable "gateway_subnet_id" {
  type = string
}