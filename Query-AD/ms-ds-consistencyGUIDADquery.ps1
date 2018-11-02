DO {

$forest1dc = "FQDN of DC"
$forest2dc = "FQDN of DC"
$forest3dc = "FQDN of DC"
$forest4dc = "FQDN of DC"
$forests = @("Forest1","Forest2","Forest3","Forest4")
$forest = $forests | Out-GridView -OutputMode Single -Title "Please select a Forest to query"

if($forest -eq "Forest1")
    {
        $result = Get-ADObject -Filter {ms-ds-consistencyguid -like "*"} -Properties * -Server $forest1dc

        clear
        Write-host "

 There are $($result.count) objects with ms-ds-consistencyguid populated in $($forest)
        
        
        "

    }

if($forest -eq "Forest2")
    {
        $result = Get-ADObject -Filter {ms-ds-consistencyguid -like "*"} -Properties * -Server $forest2dc

        clear
        Write-host "
        
There are $($result.count) objects with ms-ds-consistencyguid populated in $($forest)
        
        
        "

    }

if($forest -eq "Forest3")
    {
        $result = Get-ADObject -Filter {ms-ds-consistencyguid -like "*"} -Properties * -Server $forest3dc

        clear
        Write-host "
        
There are $($result.count) objects with ms-ds-consistencyguid populated in $($forest)
        
        
        "

    }

if($forest -eq "Forest4")
    {
        $result = Get-ADObject -Filter {ms-ds-consistencyguid -like "*"} -Properties * -Server $forest4dc

        clear
        Write-host "
        
There are $($result.count) objects with ms-ds-consistencyguid populated in $($forest)
        
        
        "

    }


    DO{

    $end = Read-Host "Would you like to query another Forest? Y/N"

        if($end -eq "Y"){

            Write-Host "
            
            Please select a Forest"
            $quit = $false
            break

            }

        if($end -eq "N"){

               $quit = $true
               break
    
            }
        }
    While($true)
}
While ($quit -ne $true)