# Mongo Databases

This deploys mongo databases

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
  databases = optional(object({
    mongo = optional(map(object({
      throughput = number
      collections = optional(map(object({
        throughput = number
        index = optional(map(object({
          keys   = list(string)
          unique = optional(bool)
        })))
      })))
    })))
  }))
})
```
