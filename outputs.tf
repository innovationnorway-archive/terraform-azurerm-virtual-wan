output "name" {
  value       = var.name
  description = "Echoes back the `name` input variable value, for convenience if passing the result of this module elsewhere as an object."
}

output "hubs" {
  value = [
    for h in azurerm_virtual_hub.main : {
      region = h.location
      prefix = h.address_prefix
    }
  ]

  description = "A list of hubs within the virtual WAN."
}
