variable "name" {
  type        = string
  description = "The name of the Virtual WAN."
}

variable "resource_group" {
  type = object({
    name     = string
    location = string
  })
  description = "The resource group in which to create the resources."
}

variable "allow_branch_to_branch_traffic" {
  type        = bool
  default     = true
  description = "Whether branch to branch traffic is allowed."
}

variable "allow_vnet_to_vnet_traffic" {
  type        = bool
  default     = false
  description = "Whether VNet to VNet traffic is allowed."
}

variable "hubs" {
  type = list(object({
    region = string
    prefix = string
  }))

  description = "A list of hubs to create within the virtual WAN."
}

variable "connections" {
  type        = map(list(string))
  default     = {}
  description = "A mapping from each region to a list of virtual network IDs to which the virtual hub should be connected."
}

locals {
  # The "azurerm_virtual_hub_connection" resource only deal
  # with one variable at a time, so we need to flatten these.
  connections = flatten([
    for region, ids in var.connections : [
      for id in ids : {
        region = region
        id     = id
      }
    ]
  ])
}
