Import-Module ActiveDirectory

$path = $PSScriptRoot

$DClist = @("na.valmont.com", "as.valmont.com", "sa.valmont.com", "eu.valmont.com", "af.valmont.com", "valmont.com")

ForEach ($DC in $DClist) {

    $userList = Get-ADUser -Filter * -server $DC -Properties * | select-object -ExpandProperty samaccountname

    foreach ($user in $userList) {

            #$user | Out-file C:\temp\Users.txt -Append

            $managerOne = $null

            $managerOne = Get-aduser -Identity $user -server $DC -Properties * | select-object -ExpandProperty manager

            $DC2 = "valmont.com"

            if ($managerOne -like "*DC=as*") {

                $DC2 = "as.valmont.com"
    
                $managerOneSAM = Get-ADUser -Identity $managerOne -Server $DC2 -Properties * | Select -ExpandProperty samaccountname 
            }

            if ($managerOne -like "*DC=na*") {

                $DC2 = "na.valmont.com"
    
                $managerOneSAM = Get-ADUser -Identity $managerOne -Server $DC2 -Properties * | Select -ExpandProperty samaccountname 
            }

            if ($managerOne -like "*DC=eu*") {

                $DC2 = "eu.valmont.com"
    
                $managerOneSAM = Get-ADUser -Identity $managerOne -Server $DC2 -Properties * | Select -ExpandProperty samaccountname 
            }

            if ($managerOne -like "*DC=sa*") {

                $DC2 = "sa.valmont.com"
    
                $managerOneSAM = Get-ADUser -Identity $managerOne -Server $DC2 -Properties * | Select -ExpandProperty samaccountname 
            }

            if ($managerOne -like "*DC=af*") {

                $DC2 = "af.valmont.com"
    
                $managerOneSAM = Get-ADUser -Identity $managerOne -Server $DC2 -Properties * | Select -ExpandProperty samaccountname 
            }

            $managerInfoOne = $null

            $managerInfoOne = get-aduser -Identity $managerOneSAM -server $DC2 -Properties * | select samaccountname, name, title

            $managerTwo = $null

            $managerTwo = get-aduser -Identity $managerOne -server $DC2 -Properties * | Select-Object -ExpandProperty manager

            $DC2 = "valmont.com"

            if ($managerTwo -like "*DC=as*") {

                $DC2 = "as.valmont.com"
    
                $managerTwoSAM = Get-ADUser -Identity $managerTwo -Server $DC2 -Properties * | Select -ExpandProperty samaccountname 
            }

            if ($managerTwo -like "*DC=na*") {

                $DC2 = "na.valmont.com"
    
                $managerTwoSAM = Get-ADUser -Identity $managerTwo -Server $DC2 -Properties * | Select -ExpandProperty samaccountname 
            }

            if ($managerTwo -like "*DC=eu*") {

                $DC2 = "eu.valmont.com"
    
                $managerTwoSAM = Get-ADUser -Identity $managerTwo -Server $DC2 -Properties * | Select -ExpandProperty samaccountname 
            }

            if ($managerTwo -like "*DC=sa*") {

                $DC2 = "sa.valmont.com"
    
                $managerTwoSAM = Get-ADUser -Identity $managerTwo -Server $DC2 -Properties * | Select -ExpandProperty samaccountname 
            }

            if ($managerTwo -like "*DC=af*") {

                $DC2 = "af.valmont.com"
    
                $managerTwoSAM = Get-ADUser -Identity $managerTwo -Server $DC2 -Properties * | Select -ExpandProperty samaccountname 
            }

            $managerInfoTwo = $null

            $managerInfoTwo = get-aduser -Identity $managerTwoSAM -server $DC2 -Properties * | select samaccountname, name, title

            $managerThree = $null

            $managerThree = get-aduser -Identity $managerTwo -server $DC2 -Properties * | Select-Object -ExpandProperty manager

            $DC2 = "valmont.com"

            if ($managerThree -like "*DC=as*") {

                $DC2 = "as.valmont.com"
    
                $managerThreeSAM = Get-ADUser -Identity $managerThree -Server $DC2 -Properties * | Select -ExpandProperty samaccountname 
            }

            if ($managerThree -like '*DC=na*') {

                $DC2 = "na.valmont.com"
    
                $managerThreeSAM = Get-ADUser -Identity $managerThree -Server $DC2 -Properties * | Select -ExpandProperty samaccountname 
            }

            if ($managerThree -like "*DC=eu*") {

                $DC2 = "eu.valmont.com"
    
                $managerThreeSAM = Get-ADUser -Identity $managerThree -Server $DC2 -Properties * | Select -ExpandProperty samaccountname 
            }

            if ($managerThree -like "*DC=sa*") {

                $DC2 = "sa.valmont.com"
    
                $managerThreeSAM = Get-ADUser -Identity $managerThree -Server $DC2 -Properties * | Select -ExpandProperty samaccountname 
            }

            if ($managerThree -like "*DC=af*") {

                $DC2 = "af.valmont.com"
    
                $managerThreeSAM = Get-ADUser -Identity $managerThree -Server $DC2 -Properties * | Select -ExpandProperty samaccountname 
            }

            $managerInfoThree = $null

            $managerInfoThree = get-aduser -Identity $managerThreeSAM -server $DC2 -Properties * | select samaccountname, name, title
    
            get-aduser -identity $user -server $DC -properties samaccountname, name, sn, givenName, Enabled, passwordneverexpires, whenCreated, whenChanged, AccountExpirationDate, Title, mail, extensionAttribute2, physicalDeliveryOfficeName, l, st, co, description, distinguishedName, LastLogonTimeStamp | select @{n='Domain';e={$DC}}, @{n='AD ID';e={$_.samaccountname}}, @{n='AD Name';e={$_.name}}, @{n='Last Name';e={$_.sn}}, @{n='First Name';e={$_.givenName}}, @{n='AD Status Enabled';e={$_.Enabled}}, @{n='Pwd Never Expires';e={$_.passwordneverexpires}}, @{n='AD Create Date';e={$_.whenCreated}}, @{n='AD Modify Date';e={$_.whenChanged}}, @{n='Account Expiry';e={$_.AccountExpirationDate}}, @{n='AD Title';e={$_.Title}}, @{n='AD Email Address';e={$_.mail}}, @{n='Division';e={$_.extensionAttribute2}}, @{n='AD Office';e={$_.physicalDeliveryOfficeName}}, @{n='AD City';e={$_.l}}, @{n='AD State';e={$_.st}}, @{n='AD Country';e={$_.co}}, @{n='AD Description';e={$_.description}}, @{n='AD Pathname';e={$_.distinguishedName}}, @{n='AD Mgt-1 ID';e={$managerInfoOne.samaccountname}}, @{n='AD Mgt-1 Name';e={$managerInfoOne.name}}, @{n='AD Mgt-1 Title';e={$managerInfoOne.title}}, @{n='AD Mgt-2 ID';e={$managerInfoTwo.samaccountname}}, @{n='AD Mgt-2 Name';e={$managerInfoTwo.name}}, @{n='AD Mgt-2 Title';e={$managerInfoTwo.title}}, @{n='AD Mgt-3 ID';e={$managerInfoThree.samaccountname}}, @{n='AD Mgt-3 Name';e={$managerInfoThree.name}}, @{n='AD Mgt-3 Title';e={$managerInfoThree.title}}, @{n='AD Domain';e={$_.UserPrincipalName.split("@")[1]}} ,@{N='LastLogon'; E={[DateTime]::FromFileTime($_.LastLogonTimeStamp)}} | Export-csv \\usomadcfs1.na.valmont.com\Server_Engineering\Automate\IT-Internal-Audit\Audit-ADUserAccounts.csv -NoTypeInformation -Append
         
    }
}
