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
    kind          = "GlobalDocumentDB"

    geo_location = {
      weu = {
        location          = "westeurope"
        failover_priority = 0
      }
    }

    databases = {
      sql = {
        db1 = {
          throughput = 400
          containers = {
            sqlc1 = {
              throughput       = 400
              unique_key_paths = ["/definition/idlong"]
              index_policy = {
                indexing_mode  = "consistent"
                included_paths = ["/*"]
              }
            }
          }
        }
      }
    }
  }
}
