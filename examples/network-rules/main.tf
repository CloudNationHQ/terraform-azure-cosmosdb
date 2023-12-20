module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.1"

  suffix = ["demo", "dev"]
}

module "rg" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 0.1"

  groups = {
    demo = {
      name   = module.naming.resource_group.name
      region = "westeurope"
    }
  }
}

module "network" {
  source  = "cloudnationhq/vnet/azure"
  version = "~> 1.0"

  naming = local.naming

  vnet = {
    name          = module.naming.virtual_network.name
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name
    cidr          = ["10.19.0.0/16"]

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
  version = "~> 0.1"

  cosmosdb = {
    name           = module.naming.cosmosdb_account.name_unique
    location       = module.rg.groups.demo.location
    resourcegroup  = module.rg.groups.demo.name
    kind           = "MongoDB"
    capabilities   = ["EnableAggregationPipeline", "EnableMongo"]
    network_filter = true

    geo_location = {
      weu = {
        location          = "westeurope"
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
