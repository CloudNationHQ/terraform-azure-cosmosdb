This example shows how to use network rules to enhance security with secure access control.

## Usage

```hcl
module "cosmosdb" {
  source  = "cloudnationhq/cosmosdb/azure"
  version = "~> 0.5"

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
```
