##############################################
# THIS SCRIPT REQUIRES Sites.FullControl.All #
##############################################

$tenantId = ""
$clientId = ""
$clientSecret = ""
$clientDisplayName = "Test Application"

# Set the SharePoint site URL and file path
$siteUrl = "https://XXXX.sharepoint.com/sites/MSFT"
$sharepointID = ""

# Get an access token for the Microsoft Graph API
$body = @{
    client_id = $clientId
    client_secret = $clientSecret
    scope = "https://graph.microsoft.com/.default"
    grant_type = "client_credentials"
}
$tokenUrl = "https://login.microsoftonline.com/$tenantId/oauth2/v2.0/token"
$tokenResponse = Invoke-RestMethod -Method Post -Uri $tokenUrl -Body $body
$accessToken = $tokenResponse.access_token

# Use the access token to access the Microsoft Graph API
$headers = @{
    "Authorization" = "Bearer $accessToken"
    "Content-Type" = "application/json"
}

# Define permissions to set
$perms = @{
    roles = @("write")
    grantedToIdentities = @(
        @{
            application = @{
                id = $clientId
                displayName = $clientDisplayName
            }
        }
    )
} | ConvertTo-Json -depth 10

# Set permissions for the site
$permsEndpoint = "https://graph.microsoft.com/v1.0/sites/$sharepointID/permissions/" 
Invoke-RestMethod -Method Post -Uri $permsEndpoint -Headers $headers -Body $perms |  ConvertTo-Json -depth 10
