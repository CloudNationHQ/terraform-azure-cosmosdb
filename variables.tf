variable "account" {
  description = "Contains all cosmosdb configuration"
  type = object({
    name                                  = string
    resource_group_name                   = optional(string)
    location                              = optional(string)
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
    key_vault_key_id                      = optional(string)
    partition_merge_enabled               = optional(bool, false)
    create_mode                           = optional(string)
    minimal_tls_version                   = optional(string, "Tls12")
    default_identity_type                 = optional(string, "FirstPartyIdentity")
    ip_range_filter                       = optional(set(string))
    tags                                  = optional(map(string))
    managed_hsm_key_id                    = optional(string)
    burst_capacity_enabled                = optional(bool, false)
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
      name         = optional(string)
      identity_ids = optional(list(string), [])
      tags         = optional(map(string))
    }))
    capabilities = optional(list(string), [])
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
    }))
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
          default_ttl_seconds    = optional(number, -1)
          index = optional(map(object({
            keys   = list(string)
            unique = optional(bool, false)
          })), {})
        })), {})
      })), {})
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
            indexing_mode  = optional(string, "consistent")
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
          }), {})
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
      name       = optional(string)
      throughput = optional(number)
      autoscale_settings = optional(object({
        max_throughput = number
      }))
    })), {})
  })

  validation {
    condition = var.account.kind != "MongoDB" || contains([
      "3.2", "3.6", "4.0", "4.2", "5.0", "6.0"
    ], var.account.mongo_server_version)
    error_message = "MongoDB server version must be one of: 3.2, 3.6, 4.0, 4.2, 5.0, 6.0 when kind is MongoDB."
  }

  validation {
    condition = var.account.consistency_policy.consistency_level != "BoundedStaleness" || (
      var.account.consistency_policy.max_interval_in_seconds >= 5 &&
      var.account.consistency_policy.max_interval_in_seconds <= 86400
    )
    error_message = "When using BoundedStaleness consistency, max_interval_in_seconds must be between 5 and 86400 seconds (1 day)."
  }

  validation {
    condition = var.account.consistency_policy.consistency_level != "BoundedStaleness" || (
      var.account.consistency_policy.max_staleness_prefix >= 10 &&
      var.account.consistency_policy.max_staleness_prefix <= 2147483647
    )
    error_message = "When using BoundedStaleness consistency, max_staleness_prefix must be between 10 and 2147483647."
  }

  validation {
    condition     = length(var.account.geo_location) > 0
    error_message = "At least one geo_location must be specified."
  }

  validation {
    condition = length([
      for loc in var.account.geo_location : loc.failover_priority if loc.failover_priority == 0
    ]) == 1
    error_message = "Exactly one geo_location must have failover_priority of 0 (primary region)."
  }

  validation {
    condition = length(distinct([
      for loc in var.account.geo_location : loc.failover_priority
    ])) == length(var.account.geo_location)
    error_message = "All geo_location entries must have unique failover_priority values."
  }

  validation {
    condition = var.account.backup == null || var.account.backup.type != "Periodic" || (
      var.account.backup.interval_in_minutes != null &&
      var.account.backup.interval_in_minutes >= 60 &&
      var.account.backup.interval_in_minutes <= 1440
    )
    error_message = "For Periodic backup, interval_in_minutes must be between 60 and 1440 minutes."
  }

  validation {
    condition = var.account.backup == null || var.account.backup.type != "Periodic" || (
      var.account.backup.retention_in_hours != null &&
      var.account.backup.retention_in_hours >= 8 &&
      var.account.backup.retention_in_hours <= 720
    )
    error_message = "For Periodic backup, retention_in_hours must be between 8 and 720 hours."
  }

  validation {
    condition     = var.account.restore == null || var.account.create_mode == "Restore"
    error_message = "Restore configuration can only be used when create_mode is set to 'Restore'."
  }

  validation {
    condition     = var.account.identity == null || var.account.identity.type != "UserAssigned" && var.account.identity.type != "SystemAssigned, UserAssigned" || length(coalesce(var.account.identity.identity_ids, [])) > 0
    error_message = "When using UserAssigned or mixed identity types, at least one identity_id must be provided."
  }

  validation {
    condition = var.account.cors_rule == null || (
      var.account.cors_rule.max_age_in_seconds >= 1 &&
      var.account.cors_rule.max_age_in_seconds <= 2147483647
    )
    error_message = "CORS max_age_in_seconds must be between 1 and 2147483647."
  }

  validation {
    condition = var.account.capacity == null || (
      var.account.capacity.total_throughput_limit >= 400
    )
    error_message = "Total throughput limit must be at least 400 RU/s."
  }

  validation {
    condition     = !var.account.analytical_storage_enabled || var.account.analytical_storage != null
    error_message = "When analytical_storage_enabled is true, analytical_storage configuration must be provided."
  }

  validation {
    condition     = var.account.free_tier_enabled == false || length(var.account.geo_location) == 1
    error_message = "Free tier can only be enabled for single-region accounts."
  }

  validation {
    condition     = !var.account.multiple_write_locations_enabled || length(var.account.geo_location) > 1
    error_message = "Multiple write locations can only be enabled for multi-region accounts."
  }

  validation {
    condition     = var.account.network_filter == false || (var.account.network_rules != null && length(var.account.network_rules) > 0) || (var.account.ip_range_filter != null && length(var.account.ip_range_filter) > 0)
    error_message = "When network filtering is enabled, either virtual network rules or IP range filters must be specified."
  }

  validation {
    condition = var.account.databases == null || var.account.databases.mongo == null || alltrue([
      for db_key, db in var.account.databases.mongo : (
        (db.throughput == null) != (db.autoscale_settings == null)
      )
    ])
    error_message = "Each MongoDB database must specify either throughput OR autoscale_settings, but not both."
  }

  validation {
    condition = var.account.databases == null || var.account.databases.sql == null || alltrue([
      for db_key, db in var.account.databases.sql : (
        (db.throughput == null) != (db.autoscale_settings == null)
      )
    ])
    error_message = "Each SQL database must specify either throughput OR autoscale_settings, but not both."
  }

  validation {
    condition = var.account.databases == null || var.account.databases.mongo == null || alltrue(flatten([
      for db_key, db in var.account.databases.mongo : [
        for coll_key, coll in coalesce(db.collections, {}) : (
          (coll.throughput == null) != (coll.autoscale_settings == null)
        )
      ]
    ]))
    error_message = "Each MongoDB collection must specify either throughput OR autoscale_settings, but not both."
  }

  validation {
    condition = var.account.databases == null || var.account.databases.sql == null || alltrue(flatten([
      for db_key, db in var.account.databases.sql : [
        for cont_key, cont in coalesce(db.containers, {}) : (
          (cont.throughput == null) != (cont.autoscale_settings == null)
        )
      ]
    ]))
    error_message = "Each SQL container must specify either throughput OR autoscale_settings, but not both."
  }

  validation {
    condition = var.account.tables == null || alltrue([
      for table_key, table in var.account.tables : (
        (table.throughput == null) != (table.autoscale_settings == null)
      )
    ])
    error_message = "Each table must specify either throughput OR autoscale_settings, but not both."
  }

  validation {
    condition = var.account.databases == null || var.account.databases.mongo == null || alltrue(flatten([
      for db_key, db in var.account.databases.mongo : [
        for coll_key, coll in coalesce(db.collections, {}) :
        coll.throughput == null || coll.throughput >= 400
      ]
    ]))
    error_message = "MongoDB collection throughput must be at least 400 RU/s when specified."
  }

  validation {
    condition = var.account.databases == null || var.account.databases.sql == null || alltrue(flatten([
      for db_key, db in var.account.databases.sql : [
        for cont_key, cont in coalesce(db.containers, {}) :
        cont.throughput == null || cont.throughput >= 400
      ]
    ]))
    error_message = "SQL container throughput must be at least 400 RU/s when specified."
  }

  validation {
    condition = var.account.databases == null || var.account.databases.mongo == null || alltrue(flatten([
      for db_key, db in var.account.databases.mongo : [
        for coll_key, coll in coalesce(db.collections, {}) :
        coll.autoscale_settings == null || coll.autoscale_settings.max_throughput >= 1000
      ]
    ]))
    error_message = "MongoDB collection autoscale max_throughput must be at least 1000 RU/s when specified."
  }

  validation {
    condition = var.account.databases == null || var.account.databases.sql == null || alltrue(flatten([
      for db_key, db in var.account.databases.sql : [
        for cont_key, cont in coalesce(db.containers, {}) :
        cont.autoscale_settings == null || cont.autoscale_settings.max_throughput >= 1000
      ]
    ]))
    error_message = "SQL container autoscale max_throughput must be at least 1000 RU/s when specified."
  }

  validation {
    condition = var.account.databases == null || var.account.databases.sql == null || alltrue(flatten([
      for db_key, db in var.account.databases.sql : [
        for cont_key, cont in coalesce(db.containers, {}) :
        cont.partition_key_version == null || cont.partition_key_version >= 1
      ]
    ]))
    error_message = "SQL container partition key version must be at least 1."
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
