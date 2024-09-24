module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.1"

  suffix = ["demo", "dev"]
}

module "rg" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 2.0"

  groups = {
    demo = {
      name     = module.naming.resource_group.name
      location = "germanywestcentral"
    }
  }
}

module "network" {
  source  = "cloudnationhq/vnet/azure"
  version = "~> 4.0"

  naming = local.naming

  vnet = {
    name           = module.naming.virtual_network.name
    location       = module.rg.groups.demo.location
    resource_group = module.rg.groups.demo.name
    cidr           = ["10.19.0.0/16"]

    subnets = {
      sn1 = {
        cidr = ["10.19.1.0/24"]
        endpoints = [
          "Microsoft.AzureCosmosDB",
        ]
      }
    }
  }
}

module "cosmosdb" {
  source  = "cloudnationhq/cosmosdb/azure"
  version = "~> 2.0"

  account = {
    name           = module.naming.cosmosdb_account.name_unique
    location       = module.rg.groups.demo.location
    resource_group = module.rg.groups.demo.name
    kind           = "MongoDB"
    capabilities   = ["EnableAggregationPipeline", "EnableMongo"]
    network_filter = true

    geo_location = {
      francecentral = {
        location          = "francecentral"
        failover_priority = 0
      }
    }

    network_rules = {
      rule1 = {
        id = module.network.subnets.sn1.id
      }
    }
  }
}
