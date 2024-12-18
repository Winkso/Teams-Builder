$applicationInstanceDDIs = @( Get-CsOnlineApplicationInstance )
$userDDIs = @( Get-CsOnlineUser )


Write-host ""
Write-host "###############"
Write-host "###USER DDIS###"
Write-host "###############"
$userDDIs | Format-Table -Property @{label="Name"; Expression={$_.DisplayName}; Alignment="Left"; Width=50}, `
                                @{label="UserPrincipalName"; Expression={$_.UserPrincipalName}; Alignment="Left"; Width=70}, `
                                @{label="Phone Number"; Expression={$_.LineURI}; Alignment="left"; Width=20}, `
                                @{label="Enabled For Voice?"; Expression={$_.EnterpriseVoiceEnabled}; Alignment="Center"; Width=15}



Write-host ""
Write-host "################"
Write-host "## QUEUE DDIS ##"
Write-host "################"

write-host $applicationInstanceDDIs

$applicationInstanceDDIs | Format-Table -Property @{label="Name"; Expression={$_.DisplayName}; Alignment="Left"; Width=50}, `
                                                                @{label="UserPrincipalName"; Expression={$_.UserPrincipalName}; Alignment="Left"; Width=70}, `
                                                                @{label="Phone Number"; Expression={$_.PhoneNumber}; Alignment="left"; Width=20}