data "azurerm_resources" "example" {
  type = "Microsoft.Network/virtualNetworks"

  required_tags = {
    name_prefix = var.name_prefix
  }
}

resource "azurerm_resource_group" "example" {
  name     = format("%s-rg", var.name_prefix)
  location = var.region
}

module "wan" {
  source = "../.."

  name = format("%s-vwan", var.name_prefix)

  resource_group = azurerm_resource_group.example

  hubs = [
    {
      region = "northeurope"
      prefix = "10.1.0.0/16"
    },
    {
      region = "westeurope"
      prefix = "10.2.0.0/16"
    },
  ]

  connections = {
    for r in data.azurerm_resources.example.resources : r.location => r.id...
  }
}

output "wan" {
  value = module.wan
}
