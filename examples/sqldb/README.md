# Sql Databases

This deploys sql databases

## Types

```hcl
account = object({
  name           = string
  location       = string
  resource_group = string
  kind           = string
  geo_location = map(object({
    location          = string
    failover_priority = number
  }))
  databases = optional(object({
    sql = optional(map(object({
      throughput = number
      containers = optional(map(object({
        throughput          = number
        partition_key_paths = list(string)
        index_policy = object({
          indexing_mode  = string
          included_paths = list(string)
        })
        unique_key = optional(map(object({
          paths = list(string)
        })))
      })))
    })))
  }))
})
```
