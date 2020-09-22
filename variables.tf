variable "name" {
  type        = string
  description = "The name of the Virtual WAN."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the resources."
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
