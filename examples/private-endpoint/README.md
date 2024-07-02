This example details a cosmosdb setup with a private endpoint, enhancing security by restricting data access to a private network.

## Usage: private endpoint

```hcl
module "privatelink" {
  source  = "cloudnationhq/pe/azure"
  version = "~> 0.9"

  resourcegroup = module.rg.groups.demo.name
  location      = module.rg.groups.demo.location

  endpoints = local.endpoints
}
```

The module uses the below locals for configuration:

```hcl
locals {
  endpoints = {
    mongo = {
      name                           = module.naming.private_endpoint.name
      subnet_id                      = module.network.subnets.sn1.id
      private_connection_resource_id = module.cosmosdb.account.id
      private_dns_zone_ids           = [module.private_dns.zones.mongo.id]
      subresource_names              = ["MongoDB"]
    }
  }
}
```
