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

module "cosmosdb" {
  source  = "cloudnationhq/cosmosdb/azure"
  version = "~> 2.0"

  account = {
    name           = module.naming.cosmosdb_account.name_unique
    location       = module.rg.groups.demo.location
    resource_group = module.rg.groups.demo.name
    kind           = "MongoDB"
    capabilities   = ["EnableAggregationPipeline"]

    geo_location = {
      francecentral = {
        location          = "francecentral"
        failover_priority = 0
      }
    }
  }
}
