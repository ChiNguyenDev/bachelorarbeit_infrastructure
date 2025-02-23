variable "client_id" {
    type = string
}

variable "client_secret" {
    type = string
}

variable "tenant_id" {
    type = string
}

variable "subscription_id" {
    type = string
}

variable "region" {
    type = string
}

variable "vm_configuration" {
  type = any # defined in submodule
}

variable "network_configuration" {
  type = any # defined in submodule
}
