This example illustrates the default cosmosdb account setup, in its simplest form.

## Usage: default

```hcl
module "cosmosdb" {
  source  = "cloudnationhq/cosmosdb/azure"
  version = "~> 0.6"

  cosmosdb = {
    name          = module.naming.cosmosdb_account.name
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name
    kind          = "MongoDB"
    capabilities  = ["EnableAggregationPipeline"]

    geo_location = {
      weu = { location = "westeurope", failover_priority = 0 }
    }
  }
}
```

Additionally, for certain scenarios, the example below highlights the ability to use multiple cosmosdb accounts, enabling a broader setup.

## Usage: multiple

```hcl
module "cosmosdbs" {
  source  = "cloudnationhq/cosmosdb/azure"
  version = "~> 0.1"

  for_each = local.cosmosdbs

  cosmosdb = each.value
}
```

The module uses a local to iterate, generating a cosmosdb account for each key.

```hcl
locals {
  cosmosdbs = {
    ac1 = {
      name          = join("-", [module.naming.cosmosdb_account.name_unique, "001"])
      location      = module.rg.groups.demo.location
      resourcegroup = module.rg.groups.demo.name
      kind          = "MongoDB"
      capabilities  = ["EnableAggregationPipeline"]

      geo_location = {
        weu = {
          location          = "westeurope"
          failover_priority = 0
        }
      }
    }
    ac2 = {
      name          = join("-", [module.naming.cosmosdb_account.name_unique, "002"])
      location      = module.rg.groups.demo.location
      resourcegroup = module.rg.groups.demo.name
      kind          = "MongoDB"
      capabilities  = ["EnableAggregationPipeline"]

      geo_location = {
        weu = {
          location          = "westeurope"
          failover_priority = 0
        }
      }
    }
  }
}
```
