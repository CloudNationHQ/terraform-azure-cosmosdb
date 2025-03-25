# cosmosdb account
resource "azurerm_cosmosdb_account" "db" {

  resource_group_name = coalesce(
    lookup(
      var.account, "resource_group", null
    ), var.resource_group
  )

  location = coalesce(
    lookup(var.account, "location", null
    ), var.location
  )

  name                                  = var.account.name
  offer_type                            = var.account.offer_type
  kind                                  = var.account.kind
  automatic_failover_enabled            = var.account.automatic_failover_enabled
  free_tier_enabled                     = var.account.free_tier_enabled
  network_acl_bypass_ids                = var.account.network_acl_bypass_ids
  mongo_server_version                  = var.account.kind == "MongoDB" ? try(var.account.mongo_server_version, "4.2") : null
  managed_hsm_key_id                    = var.account.managed_hsm_key_id
  burst_capacity_enabled                = var.account.burst_capacity_enabled
  access_key_metadata_writes_enabled    = var.account.access_key_metadata_writes
  multiple_write_locations_enabled      = var.account.multiple_write_locations_enabled
  local_authentication_disabled         = var.account.local_authentication_disabled
  network_acl_bypass_for_azure_services = var.account.network_acl_bypass_for_azure_services
  is_virtual_network_filter_enabled     = var.account.network_filter
  public_network_access_enabled         = var.account.public_network_access
  analytical_storage_enabled            = var.account.analytical_storage_enabled
  key_vault_key_id                      = var.account.key_vault_key_id
  partition_merge_enabled               = var.account.partition_merge_enabled
  create_mode                           = var.account.create_mode
  minimal_tls_version                   = var.account.minimal_tls_version
  default_identity_type                 = var.account.default_identity_type
  ip_range_filter                       = var.account.ip_range_filter

  tags = try(
    var.account.tags, var.tags, null
  )

  dynamic "cors_rule" {
    for_each = lookup(var.account, "cors_rule", null) != null ? { "cors_rule" = var.account.cors_rule } : {}

    content {
      allowed_headers    = cors_rule.value.allowed_headers
      allowed_methods    = cors_rule.value.allowed_methods
      allowed_origins    = cors_rule.value.allowed_origins
      exposed_headers    = cors_rule.value.exposed_headers
      max_age_in_seconds = cors_rule.value.max_age_in_seconds
    }
  }

  dynamic "capacity" {
    for_each = lookup(var.account, "capacity", null) != null ? { "capacity" = var.account.capacity } : {}

    content {
      total_throughput_limit = capacity.value.total_throughput_limit
    }
  }

  dynamic "identity" {
    for_each = contains(keys(var.account), "identity") && var.account.identity != null ? [var.account.identity] : []

    content {
      type = identity.value.type
      identity_ids = contains(["UserAssigned", "SystemAssigned, UserAssigned"], identity.value.type) ? concat(
        try([azurerm_user_assigned_identity.identity["identity"].id], []),
        try(lookup(identity.value, "identity_ids", []), [])
      ) : []
    }
  }

  dynamic "capabilities" {
    for_each = try(var.account.capabilities, [])

    content {
      name = capabilities.value
    }
  }

  dynamic "analytical_storage" {
    for_each = lookup(var.account, "analytical_storage", null) != null ? { "analytical_storage" = var.account.analytical_storage } : {}

    content {
      schema_type = analytical_storage.value.schema_type
    }
  }

  dynamic "backup" {
    for_each = lookup(var.account, "backup", null) != null ? { "backup" = var.account.backup } : {}

    content {
      type                = backup.value.type
      tier                = backup.value.tier
      retention_in_hours  = backup.value.retention_in_hours
      interval_in_minutes = backup.value.interval_in_minutes
      storage_redundancy  = backup.value.storage_redundancy
    }
  }

  dynamic "restore" {
    for_each = lookup(var.account, "restore", null) != null ? { "restore" = var.account.restore } : {}

    content {
      tables_to_restore          = restore.value.tables_to_restore
      restore_timestamp_in_utc   = restore.value.restore_timestamp_in_utc
      source_cosmosdb_account_id = restore.value.source_cosmosdb_account_id

      dynamic "database" {
        for_each = lookup(
          var.account.restore, "database", {}
        )

        content {
          name             = database.value.name
          collection_names = database.value.collection_names
        }
      }

      dynamic "gremlin_database" {
        for_each = lookup(
          var.account.restore, "gremlin_database", {}
        )

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

  consistency_policy {
    consistency_level       = var.account.consistency_policy.consistency_level
    max_interval_in_seconds = var.account.consistency_policy.max_interval_in_seconds
    max_staleness_prefix    = var.account.consistency_policy.max_staleness_prefix
  }

  dynamic "virtual_network_rule" {
    for_each = lookup(
      var.account, "network_rules", {}
    )

    content {
      id                                   = virtual_network_rule.value.id
      ignore_missing_vnet_service_endpoint = virtual_network_rule.value.ignore_missing_vnet_service_endpoint
    }
  }
}

# mongo databases
resource "azurerm_cosmosdb_mongo_database" "mongodb" {
  for_each = lookup(
    lookup(var.account, "databases", {}), "mongo", {}
  )

  name = coalesce(
    lookup(each.value, "name", null
    ), "mongo-${each.key}"
  )

  account_name        = azurerm_cosmosdb_account.db.name
  resource_group_name = azurerm_cosmosdb_account.db.resource_group_name
  throughput          = each.value.throughput

  dynamic "autoscale_settings" {
    for_each = lookup(each.value, "autoscale_settings", null) != null ? { "autoscale_settings" = each.value.autoscale_settings } : {}

    content {
      max_throughput = autoscale_settings.value.max_throughput
    }
  }
}

resource "azurerm_cosmosdb_mongo_collection" "mongodb_collection" {
  for_each = merge([
    for db_key, db in lookup(lookup(var.account, "databases", {}), "mongo", {}) : {
      for collection_key, collection in lookup(db, "collections", {}) :
      "${db_key}.${collection_key}" => {
        db_key                 = db_key
        collection_key         = collection_key
        throughput             = collection.throughput
        autoscale_settings     = collection.autoscale_settings
        shard_key              = collection.shard_key
        analytical_storage_ttl = collection.analytical_storage_ttl
        default_ttl_seconds    = collection.default_ttl_seconds
        name = coalesce(
          lookup(
            collection, "name", null
          ), "${db_key}-${collection_key}"
        )
        index = merge(
          {
            id = {
              keys   = ["_id"]
              unique = true
            }
          },
          lookup(
            collection, "index", {}
          )
        )
      }
    }
  ]...)

  name                   = each.value.name
  throughput             = each.value.autoscale_settings != null ? null : try(each.value.throughput, 400)
  account_name           = azurerm_cosmosdb_account.db.name
  resource_group_name    = azurerm_cosmosdb_account.db.resource_group_name
  database_name          = azurerm_cosmosdb_mongo_database.mongodb[each.value.db_key].name
  default_ttl_seconds    = each.value.default_ttl_seconds
  shard_key              = each.value.shard_key
  analytical_storage_ttl = each.value.analytical_storage_ttl

  dynamic "autoscale_settings" {
    for_each = each.value.autoscale_settings != null ? { "autoscale_settings" = each.value.autoscale_settings } : {}

    content {
      max_throughput = autoscale_settings.value.max_throughput
    }
  }

  dynamic "index" {
    for_each = each.value.index
    content {
      keys   = index.value.keys
      unique = lookup(index.value, "unique", false)
    }
  }
}

# cosmosdb tables
resource "azurerm_cosmosdb_table" "tables" {
  for_each = lookup(
    var.account, "tables", {}
  )

  name = coalesce(
    lookup(each.value, "name", null
    ), "table-${each.key}"
  )

  account_name        = azurerm_cosmosdb_account.db.name
  resource_group_name = azurerm_cosmosdb_account.db.resource_group_name
  throughput          = each.value.throughput

  dynamic "autoscale_settings" {
    for_each = lookup(each.value, "autoscale_settings", null) != null ? { "autoscale_settings" = each.value.autoscale_settings } : {}

    content {
      max_throughput = autoscale_settings.value.max_throughput
    }
  }

  connection {
    host            = azurerm_cosmosdb_account.db.endpoint
    host_key        = azurerm_cosmosdb_account.db.primary_master_key
    port            = each.value.connection.port
    proxy_user_name = each.value.connection.proxy_user_name
    target_platform = each.value.connection.target_platform
    type            = each.value.connection.type
    user            = each.value.connection.user
    password        = each.value.connection.password
    script_path     = each.value.connection.script_path
  }
}

# sql databases
resource "azurerm_cosmosdb_sql_database" "sqldb" {
  for_each = lookup(
    lookup(var.account, "databases", {}), "sql", {}
  )

  name = coalesce(
    lookup(each.value, "name", null
    ), "sql-${each.key}"
  )

  account_name        = azurerm_cosmosdb_account.db.name
  resource_group_name = azurerm_cosmosdb_account.db.resource_group_name
  throughput          = each.value.throughput

  dynamic "autoscale_settings" {
    for_each = lookup(each.value, "autoscale_settings", null) != null ? { "autoscale_settings" = each.value.autoscale_settings } : {}

    content {
      max_throughput = autoscale_settings.value.max_throughput
    }
  }
}

# sql containers
resource "azurerm_cosmosdb_sql_container" "sqlc" {
  for_each = merge([
    for db_key, db in try(var.account.databases.sql, {}) : {
      for container_key, container in try(db.containers, {}) :
      "${db_key}.${container_key}" => {
        db_key                     = db_key
        container_key              = container_key
        throughput                 = container.throughput
        autoscale_settings         = container.autoscale_settings
        analytical_storage_ttl     = container.analytical_storage_ttl
        conflict_resolution_policy = container.conflict_resolution_policy
        indexing_mode              = container.index_policy.indexing_mode
        included_paths             = container.index_policy.included_paths
        excluded_paths             = container.index_policy.excluded_paths
        unique_key                 = container.unique_key
        composite_index            = container.index_policy.composite_index
        spatial_index              = container.index_policy.spatial_index
        partition_key_paths        = container.partition_key_paths
        partition_key_kind         = container.partition_key_kind
        default_ttl                = container.default_ttl
        partition_key_version      = container.partition_key_version
        name = coalesce(
          lookup(
            container, "name", null
          ), "${db_key}-${container_key}"
        )
      }
    }
  ]...)

  name                   = each.value.name
  resource_group_name    = azurerm_cosmosdb_account.db.resource_group_name
  account_name           = azurerm_cosmosdb_account.db.name
  database_name          = azurerm_cosmosdb_sql_database.sqldb[each.value.db_key].name
  partition_key_paths    = each.value.partition_key_paths
  partition_key_kind     = each.value.partition_key_kind
  partition_key_version  = each.value.partition_key_version
  throughput             = try(each.value.autoscale_settings == null ? each.value.throughput : null, each.value.throughput)
  default_ttl            = each.value.default_ttl
  analytical_storage_ttl = each.value.analytical_storage_ttl

  dynamic "autoscale_settings" {
    for_each = each.value.autoscale_settings == null ? [] : [each.value.autoscale_settings]
    content {
      max_throughput = autoscale_settings.value.max_throughput
    }
  }

  dynamic "conflict_resolution_policy" {
    for_each = each.value.conflict_resolution_policy != null ? [each.value.conflict_resolution_policy] : []

    content {
      mode                          = conflict_resolution_policy.value.mode
      conflict_resolution_path      = conflict_resolution_policy.value.conflict_resolution_path
      conflict_resolution_procedure = conflict_resolution_policy.value.conflict_resolution_procedure
    }
  }

  indexing_policy {
    indexing_mode = each.value.indexing_mode

    dynamic "included_path" {
      for_each = each.value.included_paths

      content {
        path = included_path.value
      }
    }

    dynamic "excluded_path" {
      for_each = each.value.excluded_paths

      content {
        path = excluded_path.value
      }
    }

    dynamic "composite_index" {
      for_each = try(
        each.value.composite_index, {}
      )

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
      for_each = try(
        each.value.spatial_index, {}
      )

      content {
        path = spatial_index.value.path
      }
    }
  }

  dynamic "unique_key" {
    for_each = each.value.unique_key

    content {
      paths = unique_key.value.paths
    }
  }
}

resource "azurerm_user_assigned_identity" "identity" {
  for_each = contains(["UserAssigned", "SystemAssigned, UserAssigned"], try(var.account.identity.type, "")) ? { "identity" = var.account.identity } : {}

  resource_group_name = coalesce(
    lookup(
      var.account, "resource_group", null
    ), var.resource_group
  )

  location = coalesce(
    lookup(var.account, "location", null
    ), var.location
  )

  name = try(
    each.value.name, "uai-${var.account.name}"
  )

  tags = try(
    var.account.tags, var.tags, null
  )
}
