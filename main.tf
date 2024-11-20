# cosmosdb account
resource "azurerm_cosmosdb_account" "db" {
  name                       = var.account.name
  resource_group_name        = coalesce(lookup(var.account, "resource_group", null), var.resource_group)
  location                   = coalesce(lookup(var.account, "location", null), var.location)
  offer_type                 = try(var.account.offer_type, "Standard")
  kind                       = var.account.kind
  automatic_failover_enabled = try(var.account.automatic_failover_enabled, false)
  free_tier_enabled          = try(var.account.free_tier_enabled, false)
  network_acl_bypass_ids     = try(var.account.network_acl_bypass_ids, [])
  mongo_server_version       = var.account.kind == "MongoDB" ? try(var.account.mongo_server_version, "4.2") : null

  access_key_metadata_writes_enabled    = try(var.account.access_key_metadata_writes, false)
  multiple_write_locations_enabled      = try(var.account.multiple_write_locations_enabled, false)
  local_authentication_disabled         = try(var.account.local_authentication_disabled, false)
  network_acl_bypass_for_azure_services = try(var.account.network_acl_bypass_for_azure_services, false)
  is_virtual_network_filter_enabled     = try(var.account.network_filter, false)
  public_network_access_enabled         = try(var.account.public_network_access, true)
  analytical_storage_enabled            = try(var.account.analytical_storage, false)
  key_vault_key_id                      = try(var.account.key_vault_key_id, null)
  partition_merge_enabled               = try(var.account.partition_merge_enabled, false)
  create_mode                           = try(var.account.create_mode, null)
  minimal_tls_version                   = try(var.account.minimal_tls_version, "Tls12")
  default_identity_type                 = try(var.account.default_identity_type, "FirstPartyIdentity")
  tags                                  = try(var.account.tags, var.tags, null)

  dynamic "identity" {
    for_each = contains(keys(var.account), "identity") ? [var.account.identity] : []

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

  dynamic "backup" {
    for_each = try(var.account.backup, null) != null ? [1] : []

    content {
      tier                = try(var.account.backup.tier, null)
      type                = var.account.backup.type
      retention_in_hours  = try(var.account.backup.retention_in_hours, null)
      interval_in_minutes = try(var.account.backup.interval_in_minutes, null)
      storage_redundancy  = try(var.account.backup.storage_redundancy, null)
    }
  }

  dynamic "restore" {
    for_each = try(var.account.restore, null) != null ? [1] : []

    content {
      tables_to_restore          = try(var.account.restore.tables_to_restore, [])
      restore_timestamp_in_utc   = var.account.restore.restore_timestamp_in_utc
      source_cosmosdb_account_id = var.account.restore.source_cosmosdb_account_id

      dynamic "database" {
        for_each = try(var.account.restore.database, {})

        content {
          name             = database.value.name
          collection_names = try(database.value.collection_names, [])
        }
      }

      dynamic "gremlin_database" {
        for_each = try(var.account.restore.gremlin_database, {})

        content {
          name = gremlin_database.value.name
        }
      }
    }
  }

  dynamic "geo_location" {
    for_each = var.account.geo_location
    content {
      location          = geo_location.value.location
      failover_priority = geo_location.value.failover_priority
      zone_redundant    = try(geo_location.value.zone_redundant, false)
    }
  }

  consistency_policy {
    consistency_level       = try(var.account.consistency_policy.level, "BoundedStaleness")
    max_interval_in_seconds = try(var.account.consistency_policy.max_interval_in_seconds, 300)
    max_staleness_prefix    = try(var.account.consistency_policy.max_staleness_prefix, 100000)
  }

  ip_range_filter = try(var.account.ip_range_filter, null)

  dynamic "virtual_network_rule" {
    for_each = try(var.account.network_rules, {})
    content {
      id                                   = virtual_network_rule.value.id
      ignore_missing_vnet_service_endpoint = try(virtual_network_rule.value.ignore_missing_vnet_service_endpoint, false)
    }
  }
}

# mongo databases
resource "azurerm_cosmosdb_mongo_database" "mongodb" {
  for_each = try(var.account.databases.mongo, {})

  name                = try(each.value.name, "mongo-${each.key}")
  account_name        = azurerm_cosmosdb_account.db.name
  resource_group_name = azurerm_cosmosdb_account.db.resource_group_name
  throughput          = each.value.throughput
}

# mongo collections
resource "azurerm_cosmosdb_mongo_collection" "mongodb_collection" {
  for_each = {
    for coll in local.mongo_collections : "${coll.db_key}.${coll.collection_key}" => coll
  }

  name                = try(each.value.name, each.key)
  throughput          = each.value.throughput
  account_name        = azurerm_cosmosdb_account.db.name
  resource_group_name = azurerm_cosmosdb_account.db.resource_group_name
  database_name       = azurerm_cosmosdb_mongo_database.mongodb[each.value.db_key].name
  default_ttl_seconds = try(each.value.default_ttl_seconds, -1)
  shard_key           = each.value.shard_key

  index {
    keys   = ["_id"]
    unique = true
  }
}

# cosmosdb tables
resource "azurerm_cosmosdb_table" "tables" {
  for_each = try(var.account.tables, {})

  name                = try(each.value.name, "table-${each.key}")
  account_name        = azurerm_cosmosdb_account.db.name
  resource_group_name = azurerm_cosmosdb_account.db.resource_group_name
  throughput          = each.value.throughput

  connection {
    host     = azurerm_cosmosdb_account.db.endpoint
    host_key = azurerm_cosmosdb_account.db.primary_master_key
  }
}

# sql databases
resource "azurerm_cosmosdb_sql_database" "sqldb" {
  for_each = try(var.account.databases.sql, {})

  name                = try(each.value.name, "sql-${each.key}")
  account_name        = azurerm_cosmosdb_account.db.name
  resource_group_name = azurerm_cosmosdb_account.db.resource_group_name
  throughput          = each.value.throughput
}

# sql containers
resource "azurerm_cosmosdb_sql_container" "sqlc" {
  for_each = {
    for cont in local.sql_containers : "${cont.db_key}.${cont.container_key}" => cont
  }

  name                  = try(each.value.name, each.key)
  resource_group_name   = azurerm_cosmosdb_account.db.resource_group_name
  account_name          = azurerm_cosmosdb_account.db.name
  database_name         = azurerm_cosmosdb_sql_database.sqldb[each.value.db_key].name
  partition_key_paths   = each.value.partition_key_paths
  partition_key_kind    = try(each.value.partition_key_kind, "Hash")
  partition_key_version = 1
  throughput            = each.value.throughput
  default_ttl           = try(each.value.default_ttl, -1)

  indexing_policy {
    indexing_mode = each.value.indexing_mode

    dynamic "included_path" {
      for_each = try(each.value.included_paths, [])

      content {
        path = included_path.value
      }
    }

    dynamic "excluded_path" {
      for_each = try(each.value.excluded_paths, [])

      content {
        path = excluded_path.value
      }
    }
  }

  dynamic "unique_key" {
    for_each = try(each.value.unique_key, {})

    content {
      paths = unique_key.value.paths
    }
  }
}

resource "azurerm_user_assigned_identity" "identity" {
  for_each = contains(["UserAssigned", "SystemAssigned, UserAssigned"], try(var.account.identity.type, "")) ? { "identity" = var.account.identity } : {}

  name                = try(each.value.name, "uai-${var.account.name}")
  resource_group_name = coalesce(lookup(var.account, "resource_group", null), var.resource_group)
  location            = coalesce(lookup(var.account, "location", null), var.location)
  tags                = try(each.value.tags, var.tags, null)
}
