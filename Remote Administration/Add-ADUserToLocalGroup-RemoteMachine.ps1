# Root path of the script
$path = $PSScriptRoot
# List of servers to loop through.
$servers = get-content $path\servers.csv
# Powershell credentials for Invoke command when contacting each remote machine.
[string]$username = "admin"
[string]$userPassword = "mysupersecurepassword"
[SecureString]$secureString = $userPassword | ConvertTo-SecureString -AsPlainText -Force
[PSCredential]$credentialObject = New-Object System.Management.Automation.PSCredential -ArgumentList $username,$secureString

# Loop through each server in the list provided.
foreach ($s in $servers) {
    # Invoke command with the computer name and credential used to connect to the remote machine.
    Invoke-Command -ComputerName $s -Credential $credential -ScriptBlock {
        # List the users in the Remote Desktop Users group.
        $members = Invoke-Expression -command 'Net Localgroup "GROUP"'
        $memberList = $members[6..($members.Length-3)]
        # Loop through the list of users in the Remote Desktop Users Group.
        foreach ($m in $memberList) {
            if ($m -like '*USERACCOUNT*') {
                # Display to the console the message below.
                write-host "The account already exists"
            } 
            else {
                # Add the user account within the Remote Desktop Users group on the remote machine.
                cmd.exe /c 'net localgroup "Remote Desktop Users" USERACCOUNT /add'
            }
        }

    }
}