# Resource type for storage accounts
$resourceType = "Microsoft.Storage/storageAccounts"

# Subscription
$account = "12f38dd9-8e4f-4697-96aa-c3d2ccd1793c"

# Get the list of storage accounts and their resource groups
$storageAccounts = & az resource list --resource-type $resourceType --query "[].{ResourceGroup:resourceGroup, StorageAccount:name}" --output json | ConvertFrom-Json

# Create an empty array to store the results
$results = @()

# loop each storage account
foreach ($account in $storageAccounts) {
    # Get the diagnostic settings for the storage account
    $diagnosticSettings = & az monitor diagnostic-settings list --resource $account.StorageAccount --resource-type $resourceType --resource-group $account.ResourceGroup --query "[].name" --output json | ConvertFrom-Json

    # Get the diagnostic setting name or set it to "N/A" if no diagnostic setting is attached
    $settingName = if ($diagnosticSettings) { $diagnosticSettings } else { "N/A" }

    # Create a custom object to store the result
    $result = [PSCustomObject]@{
        "Storage Account" = $account.StorageAccount
        "Resource Group" = $account.ResourceGroup
        "Diagnostic Setting" = $settingName
    }

    # Add the result to the array
    $results += $result
}

# Display the results in a table format
$results | Format-Table -AutoSize
