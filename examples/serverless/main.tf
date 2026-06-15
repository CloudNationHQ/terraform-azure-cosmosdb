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

module "cosmosdb" {
  source  = "cloudnationhq/cosmosdb/azure"
  version = "~> 4.0"

  account = {
    name                = module.naming.cosmosdb_account.name_unique
    location            = module.rg.groups.demo.location
    resource_group_name = module.rg.groups.demo.name
    kind                = "GlobalDocumentDB"
    capabilities        = ["EnableServerless"]

    geo_location = {
      germanywestcentral = {
        location          = "germanywestcentral"
        failover_priority = 0
      }
    }

    consistency_policy = {
      consistency_level = "Session"
    }

    databases = {
      sql = {
        db1 = {
          containers = {
            sqlc1 = {
              partition_key_paths = ["/id"]
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
