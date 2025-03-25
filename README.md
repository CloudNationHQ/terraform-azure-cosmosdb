# Cosmos DB Account

This Terraform module streamlines the creation and administration of Cosmos DB resources on Azure, offering customizable options for database accounts, consistency levels, throughput settings, and more, to ensure a highly scalable, globally distributed, and secure data management platform in the cloud.

## Features

Supports multiple mongodb databases and collections for efficient data organization

Enables management of multiple sql databases and containers

Utilization of terratest for robust validation

Supports assigning multiple user assigned identities

Integrates seamlessly with private endpoint capabilities for direct and secure connectivity

Supports both system and multiple user assigned identities

<!-- BEGIN_TF_DOCS -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (~> 1.0)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 4.0)

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (~> 4.0)

## Resources

The following resources are used by this module:

- [azurerm_cosmosdb_account.db](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_account) (resource)
- [azurerm_cosmosdb_mongo_collection.mongodb_collection](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_mongo_collection) (resource)
- [azurerm_cosmosdb_mongo_database.mongodb](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_mongo_database) (resource)
- [azurerm_cosmosdb_sql_container.sqlc](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_sql_container) (resource)
- [azurerm_cosmosdb_sql_database.sqldb](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_sql_database) (resource)
- [azurerm_cosmosdb_table.tables](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_table) (resource)
- [azurerm_user_assigned_identity.identity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_account"></a> [account](#input\_account)

Description: Contains all cosmosdb configuration

Type:

```hcl
object({
    name                                  = string
    resource_group                        = optional(string, null)
    location                              = optional(string, null)
    offer_type                            = optional(string, "Standard")
    kind                                  = string
    automatic_failover_enabled            = optional(bool, false)
    free_tier_enabled                     = optional(bool, false)
    network_acl_bypass_ids                = optional(list(string), [])
    mongo_server_version                  = optional(string, "4.2")
    access_key_metadata_writes            = optional(bool, false)
    multiple_write_locations_enabled      = optional(bool, false)
    local_authentication_disabled         = optional(bool, false)
    network_acl_bypass_for_azure_services = optional(bool, false)
    network_filter                        = optional(bool, false)
    public_network_access                 = optional(bool, true)
    analytical_storage_enabled            = optional(bool, false)
    key_vault_key_id                      = optional(string, null)
    partition_merge_enabled               = optional(bool, false)
    create_mode                           = optional(string, null)
    minimal_tls_version                   = optional(string, "Tls12")
    default_identity_type                 = optional(string, "FirstPartyIdentity")
    ip_range_filter                       = optional(set(string), null)
    tags                                  = optional(map(string), null)
    managed_hsm_key_id                    = optional(string, null)
    burst_capacity_enabled                = optional(bool, false)
    cors_rule = optional(object({
      allowed_headers    = list(string)
      allowed_methods    = list(string)
      allowed_origins    = list(string)
      exposed_headers    = list(string)
      max_age_in_seconds = number
    }), null)
    capacity = optional(object({
      total_throughput_limit = number
    }), null)
    identity = optional(object({
      type         = string
      name         = optional(string, null)
      identity_ids = optional(list(string), [])
      tags         = optional(map(string), null)
    }), null)
    capabilities = optional(list(string), [])
    analytical_storage = optional(object({
      schema_type = string
    }), null)
    backup = optional(object({
      type                = string
      tier                = optional(string, null)
      retention_in_hours  = optional(number, null)
      interval_in_minutes = optional(number, null)
      storage_redundancy  = optional(string, null)
    }), null)
    restore = optional(object({
      tables_to_restore          = optional(list(string), [])
      restore_timestamp_in_utc   = string
      source_cosmosdb_account_id = string
      database = optional(map(object({
        name             = string
        collection_names = optional(list(string), [])
      })), {})
      gremlin_database = optional(map(object({
        name        = string
        graph_names = list(string)
      })), {})
    }), null)
    geo_location = map(object({
      location          = string
      failover_priority = number
      zone_redundant    = optional(bool, false)
    }))
    consistency_policy = optional(object({
      consistency_level       = optional(string, "BoundedStaleness")
      max_interval_in_seconds = optional(number, 300)
      max_staleness_prefix    = optional(number, 100000)
    }), {})
    network_rules = optional(map(object({
      id                                   = string
      ignore_missing_vnet_service_endpoint = optional(bool, false)
    })), {})
    databases = optional(object({
      mongo = optional(map(object({
        name       = optional(string, null)
        throughput = optional(number, null)
        autoscale_settings = optional(object({
          max_throughput = number
        }), null)
        collections = optional(map(object({
          name       = optional(string, null)
          throughput = optional(number, null)
          autoscale_settings = optional(object({
            max_throughput = number
          }), null)
          shard_key              = optional(string, null)
          analytical_storage_ttl = optional(number, null)
          default_ttl_seconds    = optional(number, -1)
          index = optional(map(object({
            keys   = list(string)
            unique = optional(bool, false)
          })), {})
        })), {})
      })), {})
      sql = optional(map(object({
        name       = optional(string, null)
        throughput = optional(number, null)
        autoscale_settings = optional(object({
          max_throughput = number
        }), null)
        containers = optional(map(object({
          name       = optional(string, null)
          throughput = optional(number, null)
          autoscale_settings = optional(object({
            max_throughput = number
          }), null)
          analytical_storage_ttl = optional(number, null)
          conflict_resolution_policy = optional(object({
            mode                          = string
            conflict_resolution_path      = optional(string, null)
            conflict_resolution_procedure = optional(string, null)
          }), null)
          index_policy = object({
            indexing_mode  = string
            included_paths = optional(list(string), [])
            excluded_paths = optional(list(string), [])
            composite_index = optional(map(object({
              index = list(object({
                path  = string
                order = string
              }))
            })), {})
            spatial_index = optional(map(object({
              path = string
            })), {})
          })
          unique_key = optional(map(object({
            paths = list(string)
          })), {})
          partition_key_paths   = list(string)
          partition_key_kind    = optional(string, "Hash")
          partition_key_version = optional(number, 1)
          default_ttl           = optional(number, -1)
        })), {})
      })), {})
    }), {})
    tables = optional(map(object({
      name       = optional(string, null)
      throughput = optional(number, null)
      autoscale_settings = optional(object({
        max_throughput = number
      }), null)
      connection = optional(object({
        port            = optional(number, null)
        proxy_user_name = optional(string, null)
        target_platform = optional(string, null)
        type            = optional(string, null)
        user            = optional(string, null)
        password        = optional(string, null)
        script_path     = optional(string, null)
      }), null)
    })), {})
  })
```

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_location"></a> [location](#input\_location)

Description: default azure region to be used.

Type: `string`

Default: `null`

### <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group)

Description: default resource group to be used.

Type: `string`

Default: `null`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: tags to be added to the resources

Type: `map(string)`

Default: `{}`

## Outputs

The following outputs are exported:

### <a name="output_account"></a> [account](#output\_account)

Description: n/a

### <a name="output_mongodb"></a> [mongodb](#output\_mongodb)

Description: n/a

### <a name="output_mongodb_collection"></a> [mongodb\_collection](#output\_mongodb\_collection)

Description: n/a

### <a name="output_sql_container"></a> [sql\_container](#output\_sql\_container)

Description: n/a

### <a name="output_sqldb"></a> [sqldb](#output\_sqldb)

Description: n/a

### <a name="output_tables"></a> [tables](#output\_tables)

Description: n/a
<!-- END_TF_DOCS -->

## Goals

For more information, please see our [goals and non-goals](./GOALS.md).

## Testing

For more information, please see our testing [guidelines](./TESTING.md)

## Notes

Using a dedicated module, we've developed a naming convention for resources that's based on specific regular expressions for each type, ensuring correct abbreviations and offering flexibility with multiple prefixes and suffixes.

Full examples detailing all usages, along with integrations with dependency modules, are located in the examples directory.

To update the module's documentation run `make doc`

## Authors

Module is maintained by [these awesome contributors](https://github.com/cloudnationhq/terraform-azure-cosmosdb/graphs/contributors).

## Contributing

We welcome contributions from the community! Whether it's reporting a bug, suggesting a new feature, or submitting a pull request, your input is highly valued.

For more information, please see our contribution [guidelines](./CONTRIBUTING.md).

## License

MIT Licensed. See [LICENSE](./LICENSE) for full details.

## References

- [Documentation](https://learn.microsoft.com/en-us/azure/cosmos-db/)
- [Rest Api](https://learn.microsoft.com/en-us/rest/api/cosmos-db/)
- [Rest Api Specs](https://github.com/Azure/azure-rest-api-specs/tree/main/specification/cosmos-db)
