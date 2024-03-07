locals {
  cosmosdb = {
    name          = module.naming.cosmosdb_account.name_unique
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name
    kind          = "MongoDB"
    capabilities  = ["EnableAggregationPipeline", "EnableMongo"]

    geo_location = {
      neu = {
        location          = "northeurope"
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
