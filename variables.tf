variable "account" {
  description = "Contains all cosmosdb configuration"
  type = object({
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
}

variable "location" {
  description = "default azure region to be used."
  type        = string
  default     = null
}

variable "resource_group" {
  description = "default resource group to be used."
  type        = string
  default     = null
}

variable "tags" {
  description = "tags to be added to the resources"
  type        = map(string)
  default     = {}
}
