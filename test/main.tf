resource "random_id" "test" {
  byte_length = 4
}

resource "azurerm_resource_group" "test" {
  name     = format("%s-%s", var.name_prefix, random_id.test.hex)
  location = var.region
}

module "wan" {
  source = "../"

  name = format("%s-%s", var.name_prefix, random_id.test.hex)

  resource_group_name = azurerm_resource_group.test.name

  allow_vnet_to_vnet_traffic = true

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
