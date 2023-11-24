This example demonstrates setting up tables in cosmosdb

## Usage

```hcl
module "cosmosdb" {
  source  = "cloudnationhq/cosmosdb/azure"
  version = "~> 0.1"

  cosmosdb = {
    name          = module.naming.cosmosdb_account.name
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name
    kind          = "GlobalDocumentDB"
    capabilities  = ["EnableTable"]

    geo_location = {
      weu = {
        location          = "westeurope"
        failover_priority = 0
      }
    }

    tables = {
      table1 = { name = "products", throughput = 400 }
      table2 = { name = "orders", throughput = 400
      }
    }
  }
}
```
