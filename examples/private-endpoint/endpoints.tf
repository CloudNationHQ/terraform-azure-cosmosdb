locals {
  endpoints = {
    mongo = {
      name                           = module.naming.private_endpoint.name
      subnet_id                      = module.network.subnets.sn1.id
      private_connection_resource_id = module.cosmosdb.account.id
      private_dns_zone_ids           = [module.private_dns.zones.mongo.id]
      subresource_names              = ["MongoDB"]
    }
  }
}
