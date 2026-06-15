module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.25"

  suffix = ["demo", "dev"]
}

module "rg" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 2.0"

  groups = {
    demo = {
      name     = module.naming.resource_group.name_unique
      location = "germanywestcentral"
    }
  }
}

module "network" {
  source  = "cloudnationhq/vnet/azure"
  version = "~> 9.0"

  naming = local.naming

  vnet = {
    name                = module.naming.virtual_network.name
    location            = module.rg.groups.demo.location
    resource_group_name = module.rg.groups.demo.name
    address_space       = ["10.19.0.0/16"]

    subnets = {
      sn1 = {
        address_prefixes = ["10.19.1.0/24"]
        service_endpoints = [
          "Microsoft.AzureCosmosDB",
        ]
      }
    }
  }
}

module "cosmosdb" {
  source  = "cloudnationhq/cosmosdb/azure"
  version = "~> 4.0"

  account = {
    name                              = module.naming.cosmosdb_account.name_unique
    location                          = module.rg.groups.demo.location
    resource_group_name               = module.rg.groups.demo.name
    offer_type                        = "Standard"
    kind                              = "MongoDB"
    capabilities                      = ["EnableAggregationPipeline", "EnableMongo"]
    is_virtual_network_filter_enabled = true

    geo_location = {
      francecentral = {
        location          = "francecentral"
        failover_priority = 0
      }
    }

    consistency_policy = {
      consistency_level = "Session"
    }

    virtual_network_rule = {
      rule1 = {
        id = module.network.subnets.sn1.id
      }
    }
  }
}
