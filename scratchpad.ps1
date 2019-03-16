$param = @{
    vnets = @(
        @{
            name = "TestVnet"
            addressPrefixes = @(
                "10.0.0.0/16"
                "172.16.0.0/16"
            )
            subnets = @(@{
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
            },
            @{
                name = "thirdSubnet"
                properties = @{
                    addressPrefix = "172.16.1.0/24"
                }
            }
        )},
        @{
            name = "TestVnet2"
            addressPrefixes = @(
                "192.168.0.0/16"
            )
            subnets = @(@{
                name = "firstSubnet"
                properties = @{
                    addressPrefix = "192.168.1.0/24"
                }
            },
            @{
                name = "secondSubnet"
                properties = @{
                    addressPrefix = "192.168.2.0/24"
                }
            })
        }
    )
}