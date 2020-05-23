param(
    [string]$subscriptionID = $(az account show --output json | ConvertFrom-Json | select -ExpandProperty id)
)

try {
    Write-Output "Creating app registration..."
    az ad sp create-for-rbac --name CloudSkillsRBAC --role="Contributor" --scopes="/subscriptions/$subscriptionID"
}

catch {
    Write-Warning "An error has occurred"
    $PSCmdlet.ThrowTerminatingError($_)
}