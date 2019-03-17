$param = @{
    vnets = @(
        @{
            name = "TestVnet"
            addressPrefixes = @(
                "10.0.0.0/16"
                "172.16.0.0/16"
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
                },
                @{
                    name = "thirdSubnet"
                    properties = @{
                        addressPrefix = "172.16.1.0/24"
                    }
                }
            )
        }
    )
}


$ResourceGroup = "TestVnetDeploy"
$TemplateUri = "https://raw.githubusercontent.com/dboulet01/safespace/master/vnetarray.json"