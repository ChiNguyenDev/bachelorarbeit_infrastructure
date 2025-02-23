variable "count_index" {
  type = string
}

variable "naming" {
  type = any
}

variable "rg_name" {
  type = string
}

variable "region" {
  type = string
}

variable "vm_configuration" {
  type = object({
    vm_count = number
    instance_properties = object({
      vm_size = string
    })
    storage_image_reference = object({
      publisher = string
      offer     = string
      sku       = string
      version   = string
    })
    storage_os_disk = object({
      caching           = string
      create_option     = string
      managed_disk_type = string
    })
  })
}

variable "subnet_id" {
  type = string
}
