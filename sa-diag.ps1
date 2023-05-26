# Resource type for storage accounts
$resourceType = "Microsoft.Storage/storageAccounts"

# Subscription ID
$subscriptionId = "xxxxxxx-xxx-xxx-xxx-xxxx"

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

    # Initialize variable for attached item
    $attachedItem = "N/A"

    # Get the attached item from the diagnostic setting if a setting is attached
    if ($settingName -ne "N/A") {
        $diagnosticSetting = & az monitor diagnostic-settings show --name $settingName --resource $storageAccount.StorageAccount --resource-type $resourceType --resource-group $storageAccount.ResourceGroup --subscription $subscriptionId --output json | ConvertFrom-Json

        if ($diagnosticSetting.workspaceId) {
            # Get the Log Analytics workspace ID
            $logAnalyticsWorkspaceId = $diagnosticSetting.workspaceId

            # Get the Log Analytics workspace name using the resource ID
            $logAnalyticsWorkspace = & az resource show --ids $logAnalyticsWorkspaceId --subscription $subscriptionId --query "name" --output tsv
            $attachedItem = "Log Analytics Workspace: $logAnalyticsWorkspace"
        } elseif ($diagnosticSetting.eventHubAuthorizationRuleId) {
            # Extract the Event Hub namespace name from the authorization rule ID
            $eventHubNamespaceName = $diagnosticSetting.eventHubAuthorizationRuleId.Split("/")[-3]
            $attachedItem = "Event Hub Namespace: $eventHubNamespaceName"
        }
    }

    # Create a custom object to store the result
    $result = [PSCustomObject]@{
        "Storage Account" = $storageAccount.StorageAccount
        "Resource Group" = $storageAccount.ResourceGroup
        "Diagnostic Setting" = $settingName
        "Attached Item" = $attachedItem
    }

    # Add the result to the array
    $results += $result
}

# Display the results in a table format
$results | Format-Table -AutoSize
