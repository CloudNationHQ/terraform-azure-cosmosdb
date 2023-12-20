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

module "cosmosdb" {
  source  = "cloudnationhq/cosmosdb/azure"
  version = "~> 0.1"

  cosmosdb = {
    name          = module.naming.cosmosdb_account.name
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name
    kind          = "MongoDB"
    capabilities  = ["EnableAggregationPipeline", "EnableMongo"]

    geo_location = {
      weu = {
        location          = "westeurope"
        failover_priority = 0
      }
    }

    databases = {
      mongo = {
        db1 = {
          throughput = 400
          collections = {
            col1 = {
              throughput = 400
            }
          }
        }
        db2 = {
          throughput = 400
          collections = {
            col1 = {
              throughput = 400
            }
          }
        }
      }
    }
  }
}
