Function New-GraphToken {
    [CmdletBinding()]
    Param(
        $TenantName = 'cvshealth.onmicrosoft.com'
    )

    try{
        Enable-AzureRmAlias -ErrorAction Stop
    }
    catch{
        Write-Error 'Cannot load AzureRM aliases.'
        break
    }

    $clientId = "1950a258-227b-4e31-a9cf-717495945fc2" #PowerShell ClientID
    $redirectUri = "urn:ietf:wg:oauth:2.0:oob"
    $resourceAppIdURI = "https://graph.windows.net"
    $authority = "https://login.windows.net/$TenantName"
    $authContext = New-Object "Microsoft.IdentityModel.Clients.ActiveDirectory.AuthenticationContext" -ArgumentList $authority
    $platformParams = New-Object "Microsoft.IdentityModel.Clients.ActiveDirectory.PlatformParameters" -ArgumentList "Always"
    #$authResult = $authContext.AcquireToken($resourceAppIdURI, $clientId,$redirectUri, "Auto")
    $authResult = $authContext.AcquireTokenAsync($resourceAppIdURI,$clientId,[Uri]$redirectUri,$platformParams).Result
    @{
       'Content-Type'='application\json'
       'Authorization'=$authResult.CreateAuthorizationHeader()
    }
}