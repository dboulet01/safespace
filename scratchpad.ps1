$arguments = @{
    VNetMetadata = @(
        @{
            name = "TestSpokeVnet"
            addressPrefixes = @(
                "10.0.0.0/16"
            )
            subnets = @(
                @{
                    name = "firstSubnet"
                    properties = @{
                        addressPrefix = "10.0.1.0/24"
                    }
                },
                @{
                    name = "secondSubnet"
                    properties = @{
                        addressPrefix = "10.0.2.0/24"
                    }
                }
            )
        }
    )
    ResourceGroup = "TestSpokeVnet"
    Subscription = ""
    PeerToNetbond = $true
}