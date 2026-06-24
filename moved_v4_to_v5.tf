moved {
  from = azurerm_cosmosdb_account.db
  to   = azurerm_cosmosdb_account.this
}

moved {
  from = azurerm_cosmosdb_mongo_database.mongodb
  to   = azurerm_cosmosdb_mongo_database.this
}

moved {
  from = azurerm_cosmosdb_mongo_collection.mongodb_collection
  to   = azurerm_cosmosdb_mongo_collection.this
}

moved {
  from = azurerm_cosmosdb_table.tables
  to   = azurerm_cosmosdb_table.this
}

moved {
  from = azurerm_cosmosdb_sql_database.sqldb
  to   = azurerm_cosmosdb_sql_database.this
}

moved {
  from = azurerm_cosmosdb_sql_container.sqlc
  to   = azurerm_cosmosdb_sql_container.this
}
