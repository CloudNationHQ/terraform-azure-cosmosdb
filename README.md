# Cosmos DB

This Terraform module streamlines the creation and administration of Cosmos DB resources on Azure, offering customizable options for database accounts, consistency levels, throughput settings, and more, to ensure a highly scalable, globally distributed, and secure data management platform in the cloud.

## Goals

The main objective is to create a more logic data structure, achieved by combining and grouping related resources together in a complex object.

The structure of the module promotes reusability. It's intended to be a repeatable component, simplifying the process of building diverse workloads and platform accelerators consistently.

A primary goal is to utilize keys and values in the object that correspond to the REST API's structure. This enables us to carry out iterations, increasing its practical value as time goes on.

A last key goal is to separate logic from configuration in the module, thereby enhancing its scalability, ease of customization, and manageability.

## Features

- supports multiple mongodb databases and collections for efficient data organization
- enables management of multiple sql databases and containers
- utilization of terratest for robust validation.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.61 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 3.61 |

## Resources

| Name | Type |
| :-- | :-- |
| [azurerm_cosmosdb_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_account) | resource |
| [azurerm_cosmosdb_mongo_database](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_mongo_database) | resource |
| [azurerm_cosmosdb_mongo_collection](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_mongo_collection) | resource |
| [azurerm_cosmosdb_sql_database](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_sql_database) | resource |
| [azurerm_cosmosdb_sql_container](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_sql_container) | resource |
| [azurerm_cosmosdb_table](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_table) | resource |
| [azurerm_subscription](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Required |
| :-- | :-- | :-- | :-- |
| `cosmosdb` | describes cosmosdb related configuration | object | yes |

## Outputs

| Name | Description |
| :-- | :-- |
| `account` | contains all cosmosdb account config |
| `subscriptionId` | contains the current subscription id |
| `mongodb` | contains mongodb configuration |
| `mongodb_collection` | contains mongodb collections |
| `tables` | contains cosmosdb tables |
| `sqldb` | contains sql databases |
| `sql_container` | contains sql containers |

## Testing

As a prerequirement, please ensure that both go and terraform are properly installed on your system.

The [Makefile](Makefile) includes two distinct variations of tests. The first one is designed to deploy different usage scenarios of the module. These tests are executed by specifying the TF_PATH environment variable, which determines the different usages located in the example directory.

To execute this test, input the command ```make test TF_PATH=default```, substituting default with the specific usage you wish to test.

The second variation is known as a extended test. This one performs additional checks and can be executed without specifying any parameters, using the command ```make test_extended```.

Both are designed to be executed locally and are also integrated into the github workflow.

Each of these tests contributes to the robustness and resilience of the module. They ensure the module performs consistently and accurately under different scenarios and configurations.

## Notes

Using a dedicated module, we've developed a naming convention for resources that's based on specific regular expressions for each type, ensuring correct abbreviations and offering flexibility with multiple prefixes and suffixes

Full examples detailing all usages, along with integrations with dependency modules, are located in the examples directory

## Authors

Module is maintained by [these awesome contributors](https://github.com/cloudnationhq/terraform-azure-cosmosdb/graphs/contributors).

## License

MIT Licensed. See [LICENSE](https://github.com/cloudnationhq/terraform-azure-cosmosdb/blob/main/LICENSE) for full details.

## Reference

- [Documentation](https://learn.microsoft.com/en-us/azure/cosmos-db/)
- [Rest Api](https://learn.microsoft.com/en-us/rest/api/cosmos-db/)
- [Rest Api Specs](https://github.com/Azure/azure-rest-api-specs/tree/main/specification/cosmos-db)
