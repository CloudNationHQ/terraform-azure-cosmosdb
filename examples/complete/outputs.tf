output "account" {
  value     = module.cosmosdb.account
  sensitive = true
}

output "subscription_id" {
  value = module.cosmosdb.subscription_id
}
