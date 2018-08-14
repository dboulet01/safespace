function Add-AllUsersGroup
{

$tenantcreds = Get-Credential

$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $tenantcreds -Authentication Basic -AllowRedirection
Import-PSSession $Session -DisableNameChecking -AllowClobber
Connect-MsolService -Credential $tenantcreds

$newusers = Get-MsolUser | Where-Object {$_.whencreated -gt (Get-Date).AddDays(-1)}

If (-not($newusers)) {

    Write-Output "No new users found"

}

else {

    foreach ($newuser in $newusers) {

        $domain = $newuser.userprincipalname.Substring($newuser.userprincipalname.IndexOf('@')+1)
        $group = Get-MsolGroup | Where-Object {$_.emailaddress -like "allusers@$($domain)"}
        $membershipcheck = Get-MsolGroup | Where-Object {$_.emailaddress -like "allusers@$($domain)"} | ForEach-Object {Get-MsolGroupMember -GroupObjectId $_.objectid} | Where-Object {$_.EmailAddress -eq $newuser.userprincipalname}

        If (-not($membershipcheck)) {         
                
                InlineScript {
                    
                    Do {
                        
                        Write-Host "Getting user from Exchange Online..."
                        $user = Get-User | Where-Object {$_.userprincipalname -eq $newuser.userprincipalname}

                    } Until ($user)

                    Add-DistributionGroupMember -Identity $group.displayname -Member $newuser.userprincipalname

                    }
            

                Write-Output "$($newuser.userprincipalname) has been added to $($group.displayname) group"
                
    }

        else {

                Write-Output "$($newuser.UserPrincipalName) is already in the $($group.displayname) group"

                }
    }
}

Remove-PSSession -Session $Session

}