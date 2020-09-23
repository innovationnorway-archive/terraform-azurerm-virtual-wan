data "azurerm_client_config" "test" {}

resource "azurerm_resource_group" "test" {
  name     = format("%s-rg", var.name_prefix)
  location = var.region
}

resource "azurerm_virtual_network" "test" {
  name                = format("%s-vnet", var.name_prefix)
  location            = "westeurope"
  resource_group_name = azurerm_resource_group.test.name

  address_space = ["10.128.0.0/16"]
}

module "wan" {
  source = "../"

  name = format("%s-vwan", var.name_prefix)

  resource_group = azurerm_resource_group.test

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
    "westeurope" = [
      # We cannot use "for_each" with resource attributes that
      # are unknown before apply, so we have to build the 
      # resource ID from known values.
      format(
        "/subscriptions/%s/resourceGroups/%s/providers/Microsoft.Network/virtualNetworks/%s",
        data.azurerm_client_config.test.subscription_id,
        "${var.name_prefix}-rg",
        "${var.name_prefix}-vnet"
      )
    ]
  }

  depends_on = [azurerm_virtual_network.test]
}

data "testing_assertions" "wan" {
  subject = "Virtual WAN"

  equal "hubs" {
    statement = "has the expected virtual hubs"

    got = module.wan.hubs
    want = [
      {
        region = "northeurope"
        prefix = "10.1.0.0/16"
      },
      {
        region = "westeurope"
        prefix = "10.2.0.0/16"
      },
    ]
  }
}

output "wan" {
  value = module.wan
}
