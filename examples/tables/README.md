# Tables

This deploys tables

## Types

```hcl
account = object({
  name           = string
  location       = string
  resource_group = string
  kind           = string
  capabilities   = optional(list(string))
  geo_location = map(object({
    location          = string
    failover_priority = number
  }))
  tables = optional(map(object({
    throughput = number
  })))
})
```
