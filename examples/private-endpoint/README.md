# Private Endpoint

This deploys private endpoint

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
})
```

## Notes

Additional modules will be used to configure private endpoints and private dns zones.
