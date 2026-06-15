variable "account" {
  description = "contains all cosmosdb configuration"
  type = object({
    name                                  = string
    resource_group_name                   = optional(string)
    location                              = optional(string)
    offer_type                            = optional(string)
    kind                                  = string
    automatic_failover_enabled            = optional(bool)
    free_tier_enabled                     = optional(bool)
    network_acl_bypass_ids                = optional(list(string))
    mongo_server_version                  = optional(string)
    access_key_metadata_writes_enabled    = optional(bool)
    multiple_write_locations_enabled      = optional(bool)
    local_authentication_disabled         = optional(bool)
    network_acl_bypass_for_azure_services = optional(bool)
    is_virtual_network_filter_enabled     = optional(bool)
    public_network_access_enabled         = optional(bool)
    analytical_storage_enabled            = optional(bool)
    key_vault_key_id                      = optional(string)
    partition_merge_enabled               = optional(bool)
    create_mode                           = optional(string)
    minimal_tls_version                   = optional(string)
    default_identity_type                 = optional(string)
    ip_range_filter                       = optional(set(string))
    tags                                  = optional(map(string))
    burst_capacity_enabled                = optional(bool)
    cors_rule = optional(object({
      allowed_headers    = list(string)
      allowed_methods    = list(string)
      allowed_origins    = list(string)
      exposed_headers    = list(string)
      max_age_in_seconds = number
    }))
    capacity = optional(object({
      total_throughput_limit = number
    }))
    identity = optional(object({
      type         = string
      identity_ids = optional(list(string))
    }))
    capabilities = optional(list(string))
    analytical_storage = optional(object({
      schema_type = string
    }))
    backup = optional(object({
      type                = string
      tier                = optional(string)
      retention_in_hours  = optional(number)
      interval_in_minutes = optional(number)
      storage_redundancy  = optional(string)
    }))
    restore = optional(object({
      tables_to_restore          = optional(list(string))
      restore_timestamp_in_utc   = string
      source_cosmosdb_account_id = string
      database = optional(map(object({
        name             = string
        collection_names = optional(list(string))
      })))
      gremlin_database = optional(map(object({
        name        = string
        graph_names = list(string)
      })))
    }))
    geo_location = map(object({
      location          = string
      failover_priority = number
      zone_redundant    = optional(bool)
    }))
    consistency_policy = object({
      consistency_level       = string
      max_interval_in_seconds = optional(number)
      max_staleness_prefix    = optional(number)
    })
    virtual_network_rule = optional(map(object({
      id                                   = string
      ignore_missing_vnet_service_endpoint = optional(bool)
    })))
    private_endpoints = optional(map(object({
      name                            = optional(string)
      subnet_resource_id              = string
      subresource_name                = optional(string)
      private_dns_zone_resource_ids   = optional(list(string))
      custom_network_interface_name   = optional(string)
      tags                            = optional(map(string))
      private_service_connection_name = optional(string)
      is_manual_connection            = optional(bool)
      request_message                 = optional(string)
      ip_configurations = optional(map(object({
        name               = optional(string)
        private_ip_address = optional(string)
        member_name        = optional(string)
        subresource_name   = optional(string)
      })))
    })))
    databases = optional(object({
      mongo = optional(map(object({
        name       = optional(string)
        throughput = optional(number)
        autoscale_settings = optional(object({
          max_throughput = number
        }))
        collections = optional(map(object({
          name       = optional(string)
          throughput = optional(number)
          autoscale_settings = optional(object({
            max_throughput = number
          }))
          shard_key              = optional(string)
          analytical_storage_ttl = optional(number)
          default_ttl_seconds    = optional(number)
          index = optional(map(object({
            keys   = list(string)
            unique = optional(bool)
          })))
        })))
      })))
      sql = optional(map(object({
        name       = optional(string)
        throughput = optional(number)
        autoscale_settings = optional(object({
          max_throughput = number
        }))
        containers = optional(map(object({
          name       = optional(string)
          throughput = optional(number)
          autoscale_settings = optional(object({
            max_throughput = number
          }))
          analytical_storage_ttl = optional(number)
          conflict_resolution_policy = optional(object({
            mode                          = string
            conflict_resolution_path      = optional(string)
            conflict_resolution_procedure = optional(string)
          }))
          index_policy = optional(object({
            indexing_mode  = optional(string)
            included_paths = optional(list(string))
            excluded_paths = optional(list(string))
            composite_index = optional(map(object({
              index = list(object({
                path  = string
                order = string
              }))
            })))
            spatial_index = optional(map(object({
              path = string
            })))
          }))
          unique_key = optional(map(object({
            paths = list(string)
          })))
          partition_key_paths   = list(string)
          partition_key_kind    = optional(string)
          partition_key_version = optional(number)
          default_ttl           = optional(number)
        })))
      })))
    }))
    tables = optional(map(object({
      name       = optional(string)
      throughput = optional(number)
      autoscale_settings = optional(object({
        max_throughput = number
      }))
    })))
  })

  validation {
    condition     = lookup(var.account, "location", null) != null || var.location != null
    error_message = "location must be set on var.account.location or on the module-level var.location."
  }

  validation {
    condition     = lookup(var.account, "resource_group_name", null) != null || var.resource_group_name != null
    error_message = "resource_group_name must be set on var.account.resource_group_name or on the module-level var.resource_group_name."
  }
}

variable "location" {
  description = "default azure region to be used."
  type        = string
  default     = null
}

variable "resource_group_name" {
  description = "default resource group to be used."
  type        = string
  default     = null
}

variable "tags" {
  description = "tags to be added to the resources"
  type        = map(string)
  default     = {}
}
