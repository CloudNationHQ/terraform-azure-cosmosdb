output "account" {
  description = "cosmosdb account"
  value       = azurerm_cosmosdb_account.this["this"]
}

output "mongo_databases" {
  description = "mongo databases"
  value       = azurerm_cosmosdb_mongo_database.this
}

output "mongo_collections" {
  description = "mongo collections"
  value       = azurerm_cosmosdb_mongo_collection.this
}

output "tables" {
  description = "cosmosdb tables"
  value       = azurerm_cosmosdb_table.this
}

output "sql_databases" {
  description = "sql databases"
  value       = azurerm_cosmosdb_sql_database.this
}

output "sql_containers" {
  description = "sql containers"
  value       = azurerm_cosmosdb_sql_container.this
}
