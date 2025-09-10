module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.22"

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

module "cosmosdb" {
  source  = "cloudnationhq/cosmosdb/azure"
  version = "~> 4.0"

  account = {
    name                = module.naming.cosmosdb_account.name_unique
    location            = module.rg.groups.demo.location
    resource_group_name = module.rg.groups.demo.name
    kind                = "MongoDB"
    capabilities        = ["EnableAggregationPipeline", "EnableMongo"]
    geo_location = {
      francecentral = {
        location          = "francecentral"
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
              index = {
                id = {
                  keys   = ["_id"]
                  unique = true
                }
                email = {
                  keys   = ["email"]
                  unique = true
                }
                timestamp = {
                  keys   = ["createdAt"]
                  unique = false
                }
              }
            }
          }
        }
        db2 = {
          throughput = 400
          collections = {
            col1 = {
              throughput = 400
              index = {
                id = {
                  keys   = ["_id"]
                  unique = true
                }
                compound = {
                  keys   = ["field1", "field2"]
                  unique = false
                }
              }
            }
          }
        }
      }
    }
  }
}
