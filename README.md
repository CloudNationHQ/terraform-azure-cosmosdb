# Cosmos DB Account

This Terraform module streamlines the creation and administration of Cosmos DB resources on Azure, offering customizable options for database accounts, consistency levels, throughput settings, and more, to ensure a highly scalable, globally distributed, and secure data management platform in the cloud.

## Goals

The main objective is to create a more logic data structure, achieved by combining and grouping related resources together in a complex object.

The structure of the module promotes reusability. It's intended to be a repeatable component, simplifying the process of building diverse workloads and platform accelerators consistently.

A primary goal is to utilize keys and values in the object that correspond to the REST API's structure. This enables us to carry out iterations, increasing its practical value as time goes on.

A last key goal is to separate logic from configuration in the module, thereby enhancing its scalability, ease of customization, and manageability.

## Non-Goals

These modules are not intended to be complete, ready-to-use solutions; they are designed as components for creating your own patterns.

They are not tailored for a single use case but are meant to be versatile and applicable to a range of scenarios.

Security standardization is applied at the pattern level, while the modules include default values based on best practices but do not enforce specific security standards.

End-to-end testing is not conducted on these modules, as they are individual components and do not undergo the extensive testing reserved for complete patterns or solutions.

## Features

- supports multiple mongodb databases and collections for efficient data organization
- enables management of multiple sql databases and containers
- utilization of terratest for robust validation
- supports assigning multiple user assigned identities
- integrates seamlessly with private endpoint capabilities for direct and secure connectivity
- supports both system and multiple user assigned identities

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 4.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_cosmosdb_account.db](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_account) | resource |
| [azurerm_cosmosdb_mongo_collection.mongodb_collection](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_mongo_collection) | resource |
| [azurerm_cosmosdb_mongo_database.mongodb](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_mongo_database) | resource |
| [azurerm_cosmosdb_sql_container.sqlc](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_sql_container) | resource |
| [azurerm_cosmosdb_sql_database.sqldb](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_sql_database) | resource |
| [azurerm_cosmosdb_table.tables](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_table) | resource |
| [azurerm_user_assigned_identity.identity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account"></a> [account](#input\_account) | n/a | `any` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | default azure region to be used. | `string` | `null` | no |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | default resource group to be used. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | tags to be added to the resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_account"></a> [account](#output\_account) | n/a |
| <a name="output_mongodb"></a> [mongodb](#output\_mongodb) | n/a |
| <a name="output_mongodb_collection"></a> [mongodb\_collection](#output\_mongodb\_collection) | n/a |
| <a name="output_sql_container"></a> [sql\_container](#output\_sql\_container) | n/a |
| <a name="output_sqldb"></a> [sqldb](#output\_sqldb) | n/a |
| <a name="output_tables"></a> [tables](#output\_tables) | n/a |
<!-- END_TF_DOCS -->

## Testing

For more information, please see our testing [guidelines](./TESTING.md)

## Notes

Using a dedicated module, we've developed a naming convention for resources that's based on specific regular expressions for each type, ensuring correct abbreviations and offering flexibility with multiple prefixes and suffixes.

Full examples detailing all usages, along with integrations with dependency modules, are located in the examples directory.

To update the module's documentation run `make doc`

## Authors

Module is maintained by [these awesome contributors](https://github.com/cloudnationhq/terraform-azure-cosmosdb/graphs/contributors).

## Contributing

We welcome contributions from the community! Whether it's reporting a bug, suggesting a new feature, or submitting a pull request, your input is highly valued.

For more information, please see our contribution [guidelines](./CONTRIBUTING.md).

## License

MIT Licensed. See [LICENSE](./LICENSE) for full details.

## References

- [Documentation](https://learn.microsoft.com/en-us/azure/cosmos-db/)
- [Rest Api](https://learn.microsoft.com/en-us/rest/api/cosmos-db/)
- [Rest Api Specs](https://github.com/Azure/azure-rest-api-specs/tree/main/specification/cosmos-db)
