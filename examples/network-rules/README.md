# Network Rules

This deploys network rules

## Types

```hcl
account = object({
  name           = string
  location       = string
  resource_group = string
  kind           = string
  capabilities   = optional(list(string))
  network_filter = optional(bool)
  geo_location = map(object({
    location          = string
    failover_priority = number
  }))
  network_rules = optional(map(object({
    id                                   = string
    ignore_missing_vnet_service_endpoint = optional(bool)
  })))
})
```
