Import-Module ActiveDirectory

$path = $PSScriptRoot
Write-Output $path
$props=[ordered]@{
     PSComputerName=''
     Name=''
     PrincipalSource=''
     ObjectClass=''
     
}

$ADUsers = Get-ADUser -filter {Enabled -eq $True -and PasswordNeverExpires -eq $False -and mail -like "*"} –Properties DisplayName, mail,SamAccountName, LastLogonDate, "msDS-UserPasswordExpiryTimeComputed" | Sort-Object -Property "msDS-UserPasswordExpiryTimeComputed" | where { 
$timespan = New-TimeSpan (Get-Date) ([datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed"))
$timespan.Days -lt 7 -and $timespan.Days -ge 0 } | select DisplayName,mail,SamAccountName,LastLogonDate ,@{Name="ExpiryDate";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}} | Export-Csv -Path $path\ADUsers-ExpiryList.csv -NoTypeInformation

$file = "$path\ADUsers-ExpiryList.csv"
$date = Get-Date -Format "MM/dd/yyyy"
$dateAdd = (get-date).AddDays(7).ToString("MM/dd/yyyy")

#variable for users email
$Email = "helpdeskna@valmont.com"
#Variable for users Display Name
$Name = $User.DisplayName

 #Variable for the server name
$emailSmtpServer = "smtp.na.valmont.com"

#Variable for server port
$emailSmtpServerPort = "25"
 
#This is where the email will be sent from
$emailFrom = "NoReply@valmont.com"

#this is the variable which will store the email that the message will be sent to. 
$emailTo = $Email
#The email that will be CC'd
$emailcc="David.VanVleet@valmont.com, Shawn.Greisen@valmont.com"
 
# ??? Question
$emailMessage = New-Object System.Net.Mail.MailMessage( $emailFrom , $emailTo )

# ?? Question
$emailMessage.cc.add($emailcc)
$emailMessage.Subject = "NA Users Password Expiry List" 

$att = new-object Net.Mail.Attachment($file)

$emailMessage.Attachments.Add($att)

# The standard email the end user will receive.
$body = @"
This is a list of users within the NA domain that have passwords expiring within the next 7 days starting from ${date} and ending on ${dateAdd}.
"@
$emailMessage.Body = $body
 
$SMTPClient = New-Object System.Net.Mail.SmtpClient( $emailSmtpServer , $emailSmtpServerPort )
$SMTPClient.EnableSsl = $False
#$SMTPClient.Credentials = New-Object System.Net.NetworkCredential( $emailSmtpUser , $emailSmtpPass )
$SMTPClient.Send( $emailMessage )