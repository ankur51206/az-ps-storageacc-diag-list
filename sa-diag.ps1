# Resource type for storage accounts
$resourceType = "Microsoft.Storage/storageAccounts"
$eventHubResourceType = "Microsoft.EventHub/namespaces/eventhubs"

# Subscription ID
$subscriptionId = "xxxxxx-xxx-xxx-xxx-xxxxx"

# Get the list of storage accounts and their resource groups
$storageAccounts = & az resource list --resource-type $resourceType --subscription $subscriptionId --query "[].{ResourceGroup:resourceGroup, StorageAccount:name}" --output json | ConvertFrom-Json

# Create an empty array to store the results
$results = @()

# Loop through each storage account
foreach ($storageAccount in $storageAccounts) {
    # Get the diagnostic settings for the storage account
    $diagnosticSettings = & az monitor diagnostic-settings list --resource $storageAccount.StorageAccount --resource-type $resourceType --resource-group $storageAccount.ResourceGroup --subscription $subscriptionId --query "[].name" --output json | ConvertFrom-Json

    # Get the diagnostic setting name or set it to "N/A" if no diagnostic setting is attached
    $settingName = if ($diagnosticSettings) { $diagnosticSettings } else { "N/A" }

    # Initialize variable for Event Hub ID
    $eventHubId = "N/A"

    # Get the attached details from diagnostic settings if a setting is attached
    if ($settingName -ne "N/A") {
        $diagnosticSetting = & az monitor diagnostic-settings show --name $settingName --resource $storageAccount.StorageAccount --resource-type $resourceType --resource-group $storageAccount.ResourceGroup --subscription $subscriptionId --output json | ConvertFrom-Json

        if ($diagnosticSetting.eventHubAuthorizationRuleId) {
            # Extract the Event Hub namespace name from the authorization rule ID
            $eventHubNamespaceName = $diagnosticSetting.eventHubAuthorizationRuleId.Split("/")[-3]
            
            # Get the Event Hub resource ID using the namespace name and storage account name
            $eventHubResourceId = & az resource show --resource-type $eventHubResourceType --name "$eventHubNamespaceName/$($storageAccount.StorageAccount)" --resource-group $storageAccount.ResourceGroup --subscription $subscriptionId --query "id" --output tsv

            # Extract the Event Hub ID from the resource ID
            $eventHubId = $eventHubResourceId.Split("/")[-1]
        }
    }

    # Create a custom object to store the result
    $result = [PSCustomObject]@{
        "Storage Account" = $storageAccount.StorageAccount
        "Resource Group" = $storageAccount.ResourceGroup
        "Diagnostic Setting" = $settingName
        "EventHubId" = $eventHubId
    }

    # Add the result to the array
    $results += $result
}

# Display the results in a table format
$results | Format-Table -AutoSize
# Resource type for storage accounts
$resourceType = "Microsoft.Storage/storageAccounts"
$eventHubResourceType = "Microsoft.EventHub/namespaces/eventhubs"

# Subscription ID
$subscriptionId = "12f38dd9-8e4f-4697-96aa-c3d2ccd1793c"

# Get the list of storage accounts and their resource groups
$storageAccounts = & az resource list --resource-type $resourceType --subscription $subscriptionId --query "[].{ResourceGroup:resourceGroup, StorageAccount:name}" --output json | ConvertFrom-Json

# Create an empty array to store the results
$results = @()

# Loop through each storage account
foreach ($storageAccount in $storageAccounts) {
    # Get the diagnostic settings for the storage account
    $diagnosticSettings = & az monitor diagnostic-settings list --resource $storageAccount.StorageAccount --resource-type $resourceType --resource-group $storageAccount.ResourceGroup --subscription $subscriptionId --query "[].name" --output json | ConvertFrom-Json

    # Get the diagnostic setting name or set it to "N/A" if no diagnostic setting is attached
    $settingName = if ($diagnosticSettings) { $diagnosticSettings } else { "N/A" }

    # Initialize variable for Event Hub ID
    $eventHubId = "N/A"

    # Get the attached details from diagnostic settings if a setting is attached
    if ($settingName -ne "N/A") {
        $diagnosticSetting = & az monitor diagnostic-settings show --name $settingName --resource $storageAccount.StorageAccount --resource-type $resourceType --resource-group $storageAccount.ResourceGroup --subscription $subscriptionId --output json | ConvertFrom-Json

        if ($diagnosticSetting.eventHubAuthorizationRuleId) {
            # Extract the Event Hub namespace name from the authorization rule ID
            $eventHubNamespaceName = $diagnosticSetting.eventHubAuthorizationRuleId.Split("/")[-3]
            
            # Get the Event Hub resource ID using the namespace name and storage account name
            $eventHubResourceId = & az resource show --resource-type $eventHubResourceType --name "$eventHubNamespaceName/$($storageAccount.StorageAccount)" --resource-group $storageAccount.ResourceGroup --subscription $subscriptionId --query "id" --output tsv

            # Extract the Event Hub ID from the resource ID
            $eventHubId = $eventHubResourceId.Split("/")[-1]
        }
    }

    # Create a custom object to store the result
    $result = [PSCustomObject]@{
        "Storage Account" = $storageAccount.StorageAccount
        "Resource Group" = $storageAccount.ResourceGroup
        "Diagnostic Setting" = $settingName
        "EventHubId" = $eventHubId
    }

    # Add the result to the array
    $results += $result
}

# Display the results in a table format
$results | Format-Table -AutoSize
