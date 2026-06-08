# cosmosdb account
resource "azurerm_cosmosdb_account" "this" {
  name                = var.account.name
  resource_group_name = coalesce(var.account.resource_group_name, var.resource_group_name)
  location            = coalesce(var.account.location, var.location)
  offer_type          = var.account.offer_type
  kind                = var.account.kind
  tags                = coalesce(var.account.tags, var.tags)

  automatic_failover_enabled            = var.account.automatic_failover_enabled
  free_tier_enabled                     = var.account.free_tier_enabled
  network_acl_bypass_ids                = var.account.network_acl_bypass_ids
  mongo_server_version                  = var.account.kind == "MongoDB" ? var.account.mongo_server_version : null
  burst_capacity_enabled                = var.account.burst_capacity_enabled
  access_key_metadata_writes_enabled    = var.account.access_key_metadata_writes_enabled
  multiple_write_locations_enabled      = var.account.multiple_write_locations_enabled
  local_authentication_disabled         = var.account.local_authentication_disabled
  network_acl_bypass_for_azure_services = var.account.network_acl_bypass_for_azure_services
  is_virtual_network_filter_enabled     = var.account.is_virtual_network_filter_enabled
  public_network_access_enabled         = var.account.public_network_access_enabled
  analytical_storage_enabled            = var.account.analytical_storage_enabled
  key_vault_key_id                      = var.account.key_vault_key_id
  partition_merge_enabled               = var.account.partition_merge_enabled
  create_mode                           = var.account.create_mode
  minimal_tls_version                   = var.account.minimal_tls_version
  default_identity_type                 = var.account.default_identity_type
  ip_range_filter                       = var.account.ip_range_filter

  dynamic "cors_rule" {
    for_each = var.account.cors_rule != null ? { "this" = var.account.cors_rule } : {}

    content {
      allowed_headers    = cors_rule.value.allowed_headers
      allowed_methods    = cors_rule.value.allowed_methods
      allowed_origins    = cors_rule.value.allowed_origins
      exposed_headers    = cors_rule.value.exposed_headers
      max_age_in_seconds = cors_rule.value.max_age_in_seconds
    }
  }

  dynamic "capacity" {
    for_each = var.account.capacity != null ? { "this" = var.account.capacity } : {}

    content {
      total_throughput_limit = capacity.value.total_throughput_limit
    }
  }

  dynamic "identity" {
    for_each = var.account.identity != null ? { "this" = var.account.identity } : {}

    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  dynamic "capabilities" {
    for_each = coalesce(var.account.capabilities, [])

    content {
      name = capabilities.value
    }
  }

  dynamic "analytical_storage" {
    for_each = var.account.analytical_storage != null ? { "this" = var.account.analytical_storage } : {}

    content {
      schema_type = analytical_storage.value.schema_type
    }
  }

  dynamic "backup" {
    for_each = var.account.backup != null ? { "this" = var.account.backup } : {}

    content {
      type                = backup.value.type
      tier                = backup.value.tier
      retention_in_hours  = backup.value.retention_in_hours
      interval_in_minutes = backup.value.interval_in_minutes
      storage_redundancy  = backup.value.storage_redundancy
    }
  }

  dynamic "restore" {
    for_each = var.account.restore != null ? { "this" = var.account.restore } : {}

    content {
      tables_to_restore          = restore.value.tables_to_restore
      restore_timestamp_in_utc   = restore.value.restore_timestamp_in_utc
      source_cosmosdb_account_id = restore.value.source_cosmosdb_account_id

      dynamic "database" {
        for_each = coalesce(restore.value.database, {})

        content {
          name             = database.value.name
          collection_names = database.value.collection_names
        }
      }

      dynamic "gremlin_database" {
        for_each = coalesce(restore.value.gremlin_database, {})

        content {
          name        = gremlin_database.value.name
          graph_names = gremlin_database.value.graph_names
        }
      }
    }
  }

  dynamic "geo_location" {
    for_each = var.account.geo_location

    content {
      location          = geo_location.value.location
      failover_priority = geo_location.value.failover_priority
      zone_redundant    = geo_location.value.zone_redundant
    }
  }

  dynamic "consistency_policy" {
    for_each = var.account.consistency_policy != null ? { "this" = var.account.consistency_policy } : {}

    content {
      consistency_level       = consistency_policy.value.consistency_level
      max_interval_in_seconds = consistency_policy.value.max_interval_in_seconds
      max_staleness_prefix    = consistency_policy.value.max_staleness_prefix
    }
  }

  dynamic "virtual_network_rule" {
    for_each = coalesce(var.account.virtual_network_rule, {})

    content {
      id                                   = virtual_network_rule.value.id
      ignore_missing_vnet_service_endpoint = virtual_network_rule.value.ignore_missing_vnet_service_endpoint
    }
  }
}

# private endpoints
resource "azurerm_private_endpoint" "this" {
  for_each = var.account.private_endpoints != null ? var.account.private_endpoints : {}

  name                          = coalesce(each.value.name, each.key)
  resource_group_name           = coalesce(var.account.resource_group_name, var.resource_group_name)
  location                      = coalesce(var.account.location, var.location)
  subnet_id                     = each.value.subnet_resource_id
  custom_network_interface_name = each.value.custom_network_interface_name
  tags                          = coalesce(each.value.tags, var.tags)

  private_service_connection {
    name                           = coalesce(each.value.private_service_connection_name, "${each.key}-connection")
    is_manual_connection           = each.value.is_manual_connection
    private_connection_resource_id = azurerm_cosmosdb_account.this.id
    subresource_names              = each.value.subresource_name != null ? [each.value.subresource_name] : []
    request_message                = each.value.request_message
  }

  dynamic "private_dns_zone_group" {
    for_each = each.value.private_dns_zone_resource_ids != null ? { "this" = each.value.private_dns_zone_resource_ids } : {}

    content {
      name                 = "default"
      private_dns_zone_ids = private_dns_zone_group.value
    }
  }

  dynamic "ip_configuration" {
    for_each = each.value.ip_configurations != null ? each.value.ip_configurations : {}

    content {
      name               = ip_configuration.value.name
      private_ip_address = ip_configuration.value.private_ip_address
      member_name        = ip_configuration.value.member_name
      subresource_name   = ip_configuration.value.subresource_name
    }
  }
}

# mongo databases
resource "azurerm_cosmosdb_mongo_database" "this" {
  for_each = coalesce(try(var.account.databases.mongo, null), {})

  name = coalesce(each.value.name, "mongo-${each.key}")

  account_name        = azurerm_cosmosdb_account.this.name
  resource_group_name = azurerm_cosmosdb_account.this.resource_group_name
  throughput          = each.value.throughput

  dynamic "autoscale_settings" {
    for_each = each.value.autoscale_settings != null ? { "this" = each.value.autoscale_settings } : {}

    content {
      max_throughput = autoscale_settings.value.max_throughput
    }
  }
}

# mongo collections
resource "azurerm_cosmosdb_mongo_collection" "this" {
  for_each = merge([
    for db_key, db in coalesce(try(var.account.databases.mongo, null), {}) : {
      for collection_key, collection in lookup(db, "collections", {}) :
      "${db_key}.${collection_key}" => {
        db_key                 = db_key
        collection_key         = collection_key
        throughput             = collection.throughput
        autoscale_settings     = collection.autoscale_settings
        shard_key              = collection.shard_key
        analytical_storage_ttl = collection.analytical_storage_ttl
        default_ttl_seconds    = collection.default_ttl_seconds
        name                   = coalesce(lookup(collection, "name", null), "${db_key}-${collection_key}")
        index = merge(
          {
            id = {
              keys   = ["_id"]
              unique = true
            }
          },
          lookup(collection, "index", {})
        )
      }
    }
  ]...)

  name                   = each.value.name
  throughput             = each.value.autoscale_settings != null ? null : each.value.throughput
  account_name           = azurerm_cosmosdb_account.this.name
  resource_group_name    = azurerm_cosmosdb_account.this.resource_group_name
  database_name          = azurerm_cosmosdb_mongo_database.this[each.value.db_key].name
  default_ttl_seconds    = each.value.default_ttl_seconds
  shard_key              = each.value.shard_key
  analytical_storage_ttl = each.value.analytical_storage_ttl

  dynamic "autoscale_settings" {
    for_each = each.value.autoscale_settings != null ? { "this" = each.value.autoscale_settings } : {}

    content {
      max_throughput = autoscale_settings.value.max_throughput
    }
  }

  dynamic "index" {
    for_each = each.value.index

    content {
      keys   = index.value.keys
      unique = index.value.unique
    }
  }
}

# tables
resource "azurerm_cosmosdb_table" "this" {
  for_each = var.account.tables != null ? var.account.tables : {}

  name = coalesce(each.value.name, "table-${each.key}")

  account_name        = azurerm_cosmosdb_account.this.name
  resource_group_name = azurerm_cosmosdb_account.this.resource_group_name
  throughput          = each.value.throughput

  dynamic "autoscale_settings" {
    for_each = each.value.autoscale_settings != null ? { "this" = each.value.autoscale_settings } : {}

    content {
      max_throughput = autoscale_settings.value.max_throughput
    }
  }
}

# sql databases
resource "azurerm_cosmosdb_sql_database" "this" {
  for_each = coalesce(try(var.account.databases.sql, null), {})

  name = coalesce(each.value.name, "sql-${each.key}")

  account_name        = azurerm_cosmosdb_account.this.name
  resource_group_name = azurerm_cosmosdb_account.this.resource_group_name
  throughput          = each.value.throughput

  dynamic "autoscale_settings" {
    for_each = each.value.autoscale_settings != null ? { "this" = each.value.autoscale_settings } : {}

    content {
      max_throughput = autoscale_settings.value.max_throughput
    }
  }
}

# sql containers
resource "azurerm_cosmosdb_sql_container" "this" {
  for_each = merge([
    for db_key, db in coalesce(try(var.account.databases.sql, null), {}) : {
      for container_key, container in lookup(db, "containers", {}) :
      "${db_key}.${container_key}" => {
        db_key                     = db_key
        container_key              = container_key
        throughput                 = container.throughput
        autoscale_settings         = container.autoscale_settings
        analytical_storage_ttl     = container.analytical_storage_ttl
        conflict_resolution_policy = container.conflict_resolution_policy
        index_policy               = container.index_policy
        unique_key                 = container.unique_key
        partition_key_paths        = container.partition_key_paths
        partition_key_kind         = container.partition_key_kind
        default_ttl                = container.default_ttl
        partition_key_version      = container.partition_key_version
        name                       = coalesce(lookup(container, "name", null), "${db_key}-${container_key}")
      }
    }
  ]...)

  name                   = each.value.name
  resource_group_name    = azurerm_cosmosdb_account.this.resource_group_name
  account_name           = azurerm_cosmosdb_account.this.name
  database_name          = azurerm_cosmosdb_sql_database.this[each.value.db_key].name
  partition_key_paths    = each.value.partition_key_paths
  partition_key_kind     = each.value.partition_key_kind
  partition_key_version  = each.value.partition_key_version
  throughput             = each.value.autoscale_settings != null ? null : each.value.throughput
  default_ttl            = each.value.default_ttl
  analytical_storage_ttl = each.value.analytical_storage_ttl

  dynamic "autoscale_settings" {
    for_each = each.value.autoscale_settings != null ? { "this" = each.value.autoscale_settings } : {}

    content {
      max_throughput = autoscale_settings.value.max_throughput
    }
  }

  dynamic "conflict_resolution_policy" {
    for_each = each.value.conflict_resolution_policy != null ? { "this" = each.value.conflict_resolution_policy } : {}

    content {
      mode                          = conflict_resolution_policy.value.mode
      conflict_resolution_path      = conflict_resolution_policy.value.conflict_resolution_path
      conflict_resolution_procedure = conflict_resolution_policy.value.conflict_resolution_procedure
    }
  }

  dynamic "indexing_policy" {
    for_each = each.value.index_policy != null ? { "this" = each.value.index_policy } : {}

    content {
      indexing_mode = indexing_policy.value.indexing_mode

      dynamic "included_path" {
        for_each = coalesce(indexing_policy.value.included_paths, [])

        content {
          path = included_path.value
        }
      }

      dynamic "excluded_path" {
        for_each = coalesce(indexing_policy.value.excluded_paths, [])

        content {
          path = excluded_path.value
        }
      }

      dynamic "composite_index" {
        for_each = coalesce(indexing_policy.value.composite_index, {})

        content {
          dynamic "index" {
            for_each = composite_index.value.index

            content {
              path  = index.value.path
              order = index.value.order
            }
          }
        }
      }

      dynamic "spatial_index" {
        for_each = coalesce(indexing_policy.value.spatial_index, {})

        content {
          path = spatial_index.value.path
        }
      }
    }
  }

  dynamic "unique_key" {
    for_each = coalesce(each.value.unique_key, {})

    content {
      paths = unique_key.value.paths
    }
  }
}
