package main

import (
    "context"
    "strings"
    "testing"
		"time"

    "github.com/Azure/azure-sdk-for-go/sdk/azidentity"
    "github.com/Azure/azure-sdk-for-go/sdk/resourcemanager/cosmos/armcosmos"
    "github.com/cloudnationhq/terraform-azure-cosmosdb/shared"
    "github.com/gruntwork-io/terratest/modules/terraform"
    "github.com/stretchr/testify/require"
)

type CosmosDbAccountDetails struct {
    ResourceGroupName string
    AccountName       string
}

type CosmosClient struct {
    subscriptionId string
    cosmosClient   *armcosmos.DatabaseAccountsClient
}

func NewCosmosDbClient(t *testing.T, subscriptionId string) *CosmosClient {
    cred, err := azidentity.NewDefaultAzureCredential(nil)
    require.NoError(t, err, "Failed to create credential")

    cosmosClient, err := armcosmos.NewDatabaseAccountsClient(subscriptionId, cred, nil)
    require.NoError(t, err, "Failed to create cosmos client")

    return &CosmosClient{
        subscriptionId: subscriptionId,
        cosmosClient:   cosmosClient,
    }
}

func (c *CosmosClient) GetDatabaseAccount(ctx context.Context, t *testing.T, details *CosmosDbAccountDetails) *armcosmos.DatabaseAccountGetResults {
    resp, err := c.cosmosClient.Get(ctx, details.ResourceGroupName, details.AccountName, nil)
    require.NoError(t, err, "Failed to get database account")
    return &resp.DatabaseAccountGetResults
}

func InitializeTerraform(t *testing.T) *terraform.Options {
    tfOpts := shared.GetTerraformOptions("../examples/complete")
    terraform.InitAndApply(t, tfOpts)
    return tfOpts
}

func CleanupTerraform(t *testing.T, tfOpts *terraform.Options) {
    shared.Cleanup(t, tfOpts)
}

func TestCosmosDbAccount(t *testing.T) {
    tfOpts := InitializeTerraform(t)
    defer CleanupTerraform(t, tfOpts)

    subscriptionId := terraform.Output(t, tfOpts, "subscription_id")
    cosmosClient := NewCosmosDbClient(t, subscriptionId)

    cosmosDbAccountMap := terraform.OutputMap(t, tfOpts, "account")
    cosmosDbAccountDetails := &CosmosDbAccountDetails{
        ResourceGroupName: cosmosDbAccountMap["resource_group_name"],
        AccountName:       cosmosDbAccountMap["name"],
    }

    ctx, cancel := context.WithTimeout(context.Background(), 5*time.Minute)
    defer cancel()

    cosmosDbAccount := cosmosClient.GetDatabaseAccount(ctx, t, cosmosDbAccountDetails)

    verifyCosmosDbAccount(t, cosmosDbAccountDetails, cosmosDbAccount)
}

func verifyCosmosDbAccount(t *testing.T, details *CosmosDbAccountDetails, databaseAccount *armcosmos.DatabaseAccountGetResults) {
    t.Helper()

    require.Equal(
        t,
        details.AccountName,
        *databaseAccount.Name,
        "Database account name does not match expected value",
    )

    require.Equal(
        t,
        "Succeeded",
        string(*databaseAccount.Properties.ProvisioningState),
        "Database account provisioning state is not Succeeded",
    )

    require.True(
        t,
        strings.HasPrefix(details.AccountName, "cosmos"),
        "Database account name does not start with the right abbreviation",
    )
}
