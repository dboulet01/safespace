$arguments = @{
    VNetMetadata = @(
        @{
            name = "VnetName"
            addressPrefixes = @(
                "192.168.0.0/16"
            )
            dnsServers = @(
                "192.168.1.100"
                "192.168.1.101"
            )
            subnets = @(
                @{
                    name = "SubnetName"
                    properties = @{
                        addressPrefix = "192.168.1.0/24"
                        networkSecurityGroup = @{}
                        routeTable = @{}
                        serviceEndpoints = @()
                    }
                }
            )
        }
    )
    # Resource group to deploy vnet to
    ResourceGroup = "ResourceGroupName"
    
    # Will accept Subscription Name or Subscription Id
    Subscription = "SubscriptionNameorId"
    
    # Peer to hub (True) - Standalone vnet (False)
    PeerToHub = $true
}