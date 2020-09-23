# Azure Virtual WAN Module

![test](https://github.com/innovationnorway/terraform-azurerm-virtual-wan/workflows/test/badge.svg)

This [Terraform](https://www.terraform.io/docs) module manages [Azure Virtual WAN](https://docs.microsoft.com/en-us/azure/virtual-wan/).

```hcl
resource "azurerm_resource_group" "example" {
  name     = "example-rg"
  location = "westeurope"
}

module "wan" {
  source = "innovationnorway/virtual-wan/azurerm"

  name = "example-vwan"

  resource_group = azurerm_resource_group.example

  hubs = [
    {
      region = "westeurope"
      prefix = "10.1.0.0/16"
    },
    {
      region = "northeurope"
      prefix = "10.2.0.0/16"
    },
  ]
}
```

## Arguments

* `name` - (Required) The name of the virtual WAN.	

* `resource_group` - (Required) The resource group in which to create the resources.

* `hubs` - (Required) - A list of hubs to create within the virtual WAN. This should be a list of `hubs` objects as described below.

* `connections` - (Optional) A mapping from each region to a list of virtual network IDs to which the virtual hub should be connected.

The `hubs` object supports the following:

* `region` - (Required) The Azure region where the virtual hub should be created.

* `prefix` - (Required) The address prefix which should be used for the virtual hub.
