data "azurerm_subscription" "current" {}

# cosmosdb account
resource "azurerm_cosmosdb_account" "db" {
  name                       = var.cosmosdb.name
  resource_group_name        = coalesce(lookup(var.cosmosdb, "resourcegroup", null), var.resourcegroup)
  location                   = coalesce(lookup(var.cosmosdb, "location", null), var.location)
  offer_type                 = try(var.cosmosdb.offer_type, "Standard")
  kind                       = var.cosmosdb.kind
  automatic_failover_enabled = try(var.cosmosdb.automatic_failover_enabled, false)
  free_tier_enabled          = try(var.cosmosdb.free_tier_enabled, false)
  network_acl_bypass_ids     = try(var.cosmosdb.network_acl_bypass_ids, [])
  mongo_server_version       = var.cosmosdb.kind == "MongoDB" ? try(var.cosmosdb.mongo_server_version, "4.2") : null

  access_key_metadata_writes_enabled    = try(var.cosmosdb.access_key_metadata_writes, false)
  multiple_write_locations_enabled      = try(var.cosmosdb.multiple_write_locations_enabled, false)
  local_authentication_disabled         = try(var.cosmosdb.local_authentication_disabled, false)
  network_acl_bypass_for_azure_services = try(var.cosmosdb.network_acl_bypass_for_azure_services, false)
  is_virtual_network_filter_enabled     = try(var.cosmosdb.network_filter, false)
  public_network_access_enabled         = try(var.cosmosdb.public_network_access, true)
  analytical_storage_enabled            = try(var.cosmosdb.analytical_storage, false)
  key_vault_key_id                      = try(var.cosmosdb.key_vault_key_id, null)
  partition_merge_enabled               = try(var.cosmosdb.partition_merge_enabled, false)
  default_identity_type                 = try(var.cosmosdb.default_identity_type, "FirstPartyIdentity")
  tags                                  = try(var.cosmosdb.tags, var.tags, null)

  dynamic "identity" {
    for_each = contains(keys(var.cosmosdb), "identity") ? [var.cosmosdb.identity] : []

    content {
      type = identity.value.type
      identity_ids = contains(["UserAssigned", "SystemAssigned, UserAssigned"], identity.value.type) ? concat(
        try([azurerm_user_assigned_identity.identity["identity"].id], []),
        try(lookup(identity.value, "identity_ids", []), [])
      ) : []
    }
  }

  dynamic "capabilities" {
    for_each = try(var.cosmosdb.capabilities, [])

    content {
      name = capabilities.value
    }
  }

  dynamic "backup" {
    for_each = try(var.cosmosdb.backup, null) != null ? [1] : []

    content {
      tier                = try(var.cosmosdb.backup.tier, null)
      type                = var.cosmosdb.backup.type
      retention_in_hours  = try(var.cosmosdb.backup.retention_in_hours, null)
      interval_in_minutes = try(var.cosmosdb.backup.interval_in_minutes, null)
      storage_redundancy  = try(var.cosmosdb.backup.storage_redundancy, null)
    }
  }

  dynamic "restore" {
    for_each = try(var.cosmosdb.restore, null) != null ? [1] : []

    content {
      tables_to_restore          = try(var.cosmosdb.restore.tables_to_restore, [])
      restore_timestamp_in_utc   = var.cosmosdb.restore.restore_timestamp_in_utc
      source_cosmosdb_account_id = var.cosmosdb.restore.source_cosmosdb_account_id

      dynamic "database" {
        for_each = try(var.cosmosdb.restore.database, {})

        content {
          name             = database.value.name
          collection_names = try(database.value.collection_names, [])
        }
      }

      dynamic "gremlin_database" {
        for_each = try(var.cosmosdb.restore.gremlin_database, {})

        content {
          name = gremlin_database.value.name
        }
      }
    }
  }

  dynamic "geo_location" {
    for_each = var.cosmosdb.geo_location
    content {
      location          = geo_location.value.location
      failover_priority = geo_location.value.failover_priority
      zone_redundant    = try(geo_location.value.zone_redundant, false)
    }
  }

  consistency_policy {
    consistency_level       = try(var.cosmosdb.consistency_policy.level, "BoundedStaleness")
    max_interval_in_seconds = try(var.cosmosdb.consistency_policy.max_interval_in_seconds, 300)
    max_staleness_prefix    = try(var.cosmosdb.consistency_policy.max_staleness_prefix, 100000)
  }

  ip_range_filter = try(var.cosmosdb.ip_range_filter, null)

  dynamic "virtual_network_rule" {
    for_each = try(var.cosmosdb.network_rules, {})
    content {
      id                                   = virtual_network_rule.value.id
      ignore_missing_vnet_service_endpoint = try(virtual_network_rule.value.ignore_missing_vnet_service_endpoint, false)
    }
  }
}

# mongo databases
resource "azurerm_cosmosdb_mongo_database" "mongodb" {
  for_each = try(var.cosmosdb.databases.mongo, {})

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
  for_each = try(var.cosmosdb.tables, {})

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
  for_each = try(var.cosmosdb.databases.sql, {})

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
  partition_key_path    = "/definition/id"
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

  unique_key {
    paths = each.value.unique_key
  }
}

resource "azurerm_user_assigned_identity" "identity" {
  for_each = contains(["UserAssigned", "SystemAssigned, UserAssigned"], try(var.cosmosdb.identity.type, "")) ? { "identity" = var.cosmosdb.identity } : {}

  name                = try(each.value.name, "uai-${var.cosmosdb.name}")
  resource_group_name = coalesce(lookup(var.cosmosdb, "resourcegroup", null), var.resourcegroup)
  location            = coalesce(lookup(var.cosmosdb, "location", null), var.location)
  tags                = try(each.value.tags, var.tags, null)
}
