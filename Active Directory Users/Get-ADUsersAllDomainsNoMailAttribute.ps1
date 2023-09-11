# Provide the file export path and filename.
$export = Read-Host
# Get all AD Users in Forest that DO NOT have a mail attribute.
(Get-ADForest).Domains | % {Get-ADUser -filter * -Server $_ -Properties * | where-object {$_.Mail -ne $null} | Select SamAccountName, Name, Mail, DistinguishedName, UserPrincipalName} | Export-csv $export -NoTypeInformation -Append
