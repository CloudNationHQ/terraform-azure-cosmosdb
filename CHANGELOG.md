# Changelog

## [3.3.1](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/compare/v3.3.0...v3.3.1) (2025-03-06)


### Bug Fixes

* fix typo analytical storage enabled on cosmosdb accounts ([#81](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/issues/81)) ([14cc70c](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/commit/14cc70cd70270827251ce884906a30ee4236e940))
* fix typo public network access enabled ([#83](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/issues/83)) ([196541d](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/commit/196541d3280df153c03997d611a04a6546d3149f))

## [3.3.0](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/compare/v3.2.0...v3.3.0) (2025-03-05)


### Features

* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#78](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/issues/78)) ([2b53e13](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/commit/2b53e130c606c4ba47db1abb007bb1abf313f137))


### Bug Fixes

* make throughput sql containers and databases optional and set a default for partition key version ([#79](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/issues/79)) ([4401969](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/commit/44019693d2dd31bf3c34e047b27dcd4d7994166f))

## [3.2.0](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/compare/v3.1.0...v3.2.0) (2025-01-20)


### Features

* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#71](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/issues/71)) ([4ac2868](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/commit/4ac28681ff34381ce0f57f6557422bc1e96cf608))
* **deps:** bump golang.org/x/crypto from 0.29.0 to 0.31.0 in /tests ([#74](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/issues/74)) ([43e1b35](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/commit/43e1b35c735af5e50544392dfa38d5df9ff3643f))
* **deps:** bump golang.org/x/net from 0.31.0 to 0.33.0 in /tests ([#75](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/issues/75)) ([9e361ef](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/commit/9e361ef11741e419dc49d4745a8395bb7c22b639))
* remove temporary files when deployment tests fails ([#72](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/issues/72)) ([b34b21c](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/commit/b34b21c7679e8a3f71f754b84077f069b2914147))

## [3.1.0](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/compare/v3.0.0...v3.1.0) (2024-12-06)


### Features

* add type definitions all usages ([#68](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/issues/68)) ([3b0ea42](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/commit/3b0ea420c53728e144135aef467960cf51353848))

## [3.0.0](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/compare/v2.2.1...v3.0.0) (2024-11-25)


### ⚠ BREAKING CHANGES

* Data structure mongo databases has changed.

### Features

* allow multiple indexes on mongodb collections ([#66](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/issues/66)) ([a6b131c](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/commit/a6b131c2138ae75a29820203f625d7edb8344a2e))

### Upgrade from v2.2.1 to v3.0.0:

- Update module reference to: `version = "~> 3.0"`
- If using mongodb collection the data structure is slightly changed :
  - see [examples](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/blob/main/examples/mongodb/main.tf) for the correct usage

## [2.2.1](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/compare/v2.2.0...v2.2.1) (2024-11-20)


### Bug Fixes

* bounced all modules to latest version in usages and removed unneeded outputs ([#64](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/issues/64)) ([69dc760](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/commit/69dc76093c2fbb3a564a4403fef41893621efa27))

## [2.2.0](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/compare/v2.1.0...v2.2.0) (2024-11-12)


### Features

* enhance testing with sequential, parallel modes and flags for exceptions and skip-destroy ([#62](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/issues/62)) ([be76ed9](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/commit/be76ed9fe793cab3142e548cef60040be17bad33))

## [2.1.0](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/compare/v2.0.0...v2.1.0) (2024-10-11)


### Features

* auto generated docs and refine makefile ([#60](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/issues/60)) ([ca7dc04](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/commit/ca7dc0421ece13c2dc5d1409e7eca4a63e6e3ec7))
* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#59](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/issues/59)) ([b42252d](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/commit/b42252dd2faef54d03da9fdd910b0b42fed6c245))

## [2.0.0](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/compare/v1.1.0...v2.0.0) (2024-09-24)


### ⚠ BREAKING CHANGES

* Version 4 of the azurerm provider includes breaking changes.

### Features

* upgrade azurerm provider to v4 ([#57](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/issues/57)) ([bc9a26e](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/commit/bc9a26e6e23ac01047f8460ec3691f5c8ece6210))

### Upgrade from v1.1.0 to v2.0.0:

- Update module reference to: `version = "~> 2.0"`

## [1.1.0](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/compare/v1.0.0...v1.1.0) (2024-08-28)


### Features

* add question template ([#54](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/issues/54)) ([10642a2](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/commit/10642a231cdd77a0ccce4e64348b07c55ca868c4))

## [1.0.0](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/compare/v0.11.0...v1.0.0) (2024-08-14)


### ⚠ BREAKING CHANGES

* data structure has changed due to renaming of properties and output variables.

### Features

* aligned several properties ([#52](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/issues/52)) ([eae958d](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/commit/eae958d3a21710ab4a1d79d4a18d4701ff3aa751))

### Upgrade from v0.11.0 to v1.0.0:

- Update module reference to: `version = "~> 1.0"`
- cosmosdb object name has changed to account
- Rename properties in account object:
  - resourcegroup -> resource_group
  - unique_key_paths -> partition_key_paths
- Rename variable (optional):
  - resourcegroup -> resource_group
- Rename output variable:
  - subscriptionId -> subscription_id'
- Support for multiple unique_key configurations
  - The static unique_key block has been replaced with a dynamic block to support multiple unique_key configurations in cosmosdb sql containers.

## [0.11.0](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/compare/v0.10.0...v0.11.0) (2024-08-14)


### Features

* added code of conduct and security documentation ([#49](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/issues/49)) ([98cd2b6](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/commit/98cd2b615e1acd8748333d907be760430ef18cdc))

## [0.10.0](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/compare/v0.9.0...v0.10.0) (2024-08-14)


### Features

* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#47](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/issues/47)) ([71d2ab4](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/commit/71d2ab4abf11244218825c4b197371f9c63321fd))
* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#48](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/issues/48)) ([17ec059](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/commit/17ec0596f830aed714fe96d88568bf5e1b3684fa))
* update contribution docs ([#45](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/issues/45)) ([7c0670f](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/commit/7c0670f850cad43a60d9616c3b5bea77dc5f9c9d))

## [0.9.0](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/compare/v0.8.0...v0.9.0) (2024-07-02)


### Features

* add issue template ([#41](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/issues/41)) ([06088e0](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/commit/06088e087ce4a708a06a2a339b4d3649f85591ca))
* **deps:** bump github.com/Azure/azure-sdk-for-go/sdk/azidentity ([#39](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/issues/39)) ([8cc2c72](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/commit/8cc2c72d0dbaa32e486e541cf75daa1b8542fb5f))
* **deps:** bump github.com/Azure/azure-sdk-for-go/sdk/azidentity ([#40](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/issues/40)) ([92ea749](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/commit/92ea7496d60bd1ee0c75d1c381125833e2dfc015))

## [0.8.0](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/compare/v0.7.0...v0.8.0) (2024-06-07)


### Features

* add pull request template ([#37](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/issues/37)) ([1d29b90](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/commit/1d29b906cc251b2958ce835147fc4c0bb93bb08a))

## [0.7.0](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/compare/v0.6.0...v0.7.0) (2024-05-16)


### Features

* add backup support ([#36](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/issues/36)) ([0be1da9](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/commit/0be1da9be1b173c89b1fc575bedfd289d3c88637))
* **deps:** bump github.com/Azure/azure-sdk-for-go/sdk/azidentity ([#28](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/issues/28)) ([282a4b4](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/commit/282a4b46485a3f761b538419f319d2c913929413))
* **deps:** bump golang.org/x/net from 0.19.0 to 0.23.0 in /tests ([#29](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/issues/29)) ([6341e62](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/commit/6341e6230f072451b7e511e1d1620faf6416e755))
* replace deprecated properties ([#33](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/issues/33)) ([ce76014](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/commit/ce76014eb3a60476762cc208ffe9506daea4fa79))

## [0.6.0](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/compare/v0.5.0...v0.6.0) (2024-03-15)


### Features

* add private endpoint usage ([#25](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/issues/25)) ([6a9c9c1](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/commit/6a9c9c1b2997529a88c8f933c64f539e887e8f62))
* **deps:** bump google.golang.org/protobuf in /tests ([#24](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/issues/24)) ([c8089c5](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/commit/c8089c54ef45094118129d65f68cb899eb676cc3))

## [0.5.0](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/compare/v0.4.0...v0.5.0) (2024-03-07)


### Features

* **deps:** bump github.com/Azure/azure-sdk-for-go/sdk/azidentity ([#18](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/issues/18)) ([ec9d952](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/commit/ec9d952f0b58424d10a41a2180861b379d9b5611))
* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#17](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/issues/17)) ([b2f2c3e](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/commit/b2f2c3ec83ffb31f60d6408e0f5f32ad661816c7))
* **deps:** bump github.com/stretchr/testify in /tests ([#19](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/issues/19)) ([cd17959](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/commit/cd1795952a28ba697fad57b2392396e0229d3043))
* improved alignment for several properties ([#22](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/issues/22)) ([af32c64](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/commit/af32c6423aa27b21ed885d0c88abae3765377a8d))
* optimized dynamic identity blocks ([#23](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/issues/23)) ([39d2eae](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/commit/39d2eae51182f54a9be0278f404658a67bba4daf))
* update documentation ([#20](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/issues/20)) ([83189d7](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/commit/83189d754e611135a3868f3c54bd09a8a53d154a))

## [0.4.0](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/compare/v0.3.0...v0.4.0) (2024-01-19)


### Features

* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#14](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/issues/14)) ([51eab00](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/commit/51eab008982318d745faf1c342f671552631dfed))
* small refactor workflows ([#15](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/issues/15)) ([ec20b88](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/commit/ec20b88cd0d4526d1ce45c44fcdc258e8c130398))

## [0.3.0](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/compare/v0.2.0...v0.3.0) (2023-12-20)


### Features

* add support for network rules ([#8](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/issues/8)) ([ff925b0](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/commit/ff925b0cf1992b5afbb5e8e20c46ea0059c7ed51))
* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#10](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/issues/10)) ([937ba18](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/commit/937ba1857c294830f3ecf69180426eccf4e4306e))
* **deps:** bump golang.org/x/crypto from 0.14.0 to 0.17.0 in /tests ([#13](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/issues/13)) ([f2170e1](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/commit/f2170e1113bf8fa24047daa320a983bd82779882))

## [0.2.0](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/compare/v0.1.0...v0.2.0) (2023-11-26)


### Features

* small refactor extended tests ([#3](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/issues/3)) ([e4b5d7f](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/commit/e4b5d7f9ff32bcee5b0d973a8e97f7ce990a4436))

## 0.1.0 (2023-11-24)


### Features

* add initial resources ([#1](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/issues/1)) ([58d11cc](https://github.com/CloudNationHQ/terraform-azure-cosmosdb/commit/58d11ccd8721aecb5a3a4d03109ca32753165442))
