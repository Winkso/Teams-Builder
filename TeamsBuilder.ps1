###########################################
#                                         #
#             Alex Thompson               #
#                                         #
#    Teams Direct Routing Setup Script    #
#              18/10/2023                 #
###########################################

Clear-Host
$text = "

    _              _          _       _____                          _____           _ 
   / \   ___ _ __ (_)_ __ ___( )___  |_   _|__  __ _ _ __ ___  ___  |_   _|__   ___ | |
  / _ \ / __| '_ \| | '__/ _ \// __|   | |/ _ \/ _  |  _' '_ \/ __|   | |/ _ \ / _ \| |
 / ___ \\__ \ |_) | | | |  __/ \__ \   | |  __/ (_| | | | | | \__ \   | | (_) | (_) | |
/_/   \_\___/ .__/|_|_|  \___| |___/   |_|\___|\__,_|_| |_| |_|___/   |_|\___/ \___/|_|
            |_|                                                                        
"


for ($i=0; $i -lt $text.length; $i++) {
    switch ($i % 6) {
        0 { $c = "white" }
        2 { $c = "green" }
        4 { $c = "blue" }
        default { $c = "cyan" }
    }
write-host $text[$i] -NoNewline -ForegroundColor $c
}

write-host "This script assumes the following:"
write-host "you already have configured DNS for the customers trunk endpoint"
write-host "You have create a user and assigned both SBC Domains to a licensed test user"

write-host ""
write-host ""
write-host ""
write-host "Starting Script..."
start-sleep -Seconds 2


############# Static Variables #################

#hard-code Teams Endpoint length
$trunkLength = 6

#trunk ID Length
$lengthConfirmed = $false

#trunk ID
$teamsTrunkID = 0



############ Functions Collections ##############


#Collect Teams Trunk ID
function collectTeamsTrunkID {
    do {
        # Collect Teams Trunk ID from input
        $script:teamsTrunkID = Read-Host "Please enter Trunk ID in the following format 500XXX where XXX is the customer's Trunk ID"
        $lengthConfirmed = checkTrunkIDLength

        $script:trunkFullID01 = "$script:teamsTrunkID.msteams01.aspiresip.com"
        $script:trunkFullID02 = "$script:teamsTrunkID.msteams02.aspiresip.com"

        if (-not $lengthConfirmed) {
            Write-Host "Invalid Trunk ID. Let's try again."
        }
    } while (-not $lengthConfirmed)
}

#Check Teams Trunk ID Length

#If trunk input matches length
function checkTrunkIDLength {
    if ($script:teamsTrunkID.Length -eq $trunkLength -and $script:teamsTrunkID -match '^500\d{3}$') {
        Write-Host "TrunkID: $script:teamsTrunkID"
        return $true
    } else {
        return $false
    }
}

function checkPSConnection {
    try {
        $activePSSession = Get-CsTenant

        if ($activePSSession.DisplayName -ne "") {
            # Accessing the DisplayName property directly
            Write-Host "You're currently connected to: $($activePSSession.DisplayName)"
        } 
    } catch {
        # Display a message and prompt for login
        Write-Host "You are not currently connected. Please log in."
        LoginUser
    }

    Start-Sleep -Seconds 3
}

function loginUser {
    Write-Host "Performing login..."
    Start-Sleep -Seconds 3
    Connect-MicrosoftTeams
}

#Main Menu

function ShowMainMenu {
    Clear-Host
    Write-Host "---------- Main Menu ----------"
    Write-Output "1. Perform Diagnostics on the Tenant."
    Write-Output "2. Perform Configuration changes on the Tenant."
    Write-Output "3. subMenu3"
    Write-Output "4. subMenu4"
    Write-Output "5. subMenu5"
    Write-Output "6. exit"

    $choice = Read-Host "Select a choice Main Menu (1-6)"

    # Validate the user's input
    if ($choice -lt 1 -or $choice -gt 6) {
        Write-Output "Invalid choice. Please select a number between 1 and 6."
        return
    }

    # Call the corresponding submenu function based on the user's choice
    switch ($choice) {
        1 { ShowSubMenu1 }
        2 { ShowSubMenu2 }
        3 { ShowSubMenu3 }
        4 { ShowSubMenu4 }
    }

    #return $choice
}

function ShowSubMenu1 {
    Clear-Host
    Write-Host "---------- Sub Menu 1 - Diagnostics ----------"
    Write-Host "1. Confirm the Tenant has been configured correctly for Direct Routing."
    Write-Host "2. Export a list of all users with Enterprise Voice Enabled."
    Write-Host "3. Export a list of all call queues."
    Write-Host "4. Export a list of all Auto Attendants."
    Write-host "5. "
    Write-host "6. "

    $option = Read-Host "Select a diagnostics option(1-6)"

    # Validate the user's input
    if ($option -lt 1 -or $option -gt 6) {
        Write-Output "Invalid diagnostics option. Please select a number between 1 and 6."
        return
    }

    # Perform the corresponding action based on the user's option
    switch ($option) {
        1 { diagTenantConfirm }
        2 { diagListEVTrue }
        3 { diagExportCallQueues }
        4 { diagExportAAs }
    }

    #return $option
}

function ShowSubMenu2 {
    Clear-Host
    Write-Host "---------- Sub Menu 2 - Configuration ----------"
    Write-Host "1. Configure a Teams Tenant for Direct Routing."
    Write-Host "2. Configure a list of users for Direct Routing."
    Write-Host "3. Create new Call Queue(s)."
    Write-Host "4. Create an Auto Attendant."
    Write-host "5. Add members to a Call Queue."
    Write-host "6. Ammend Options on an Auto Attendant."

    $option = Read-Host "Select a configuration option(1-6)"

    # Validate the user's input
    if ($option -lt 1 -or $option -gt 6) {
        Write-Output "Invalid configuration option. Please select a number between 1 and 6."
        return
    }

    # Perform the corresponding action based on the user's option
    switch ($option) {
        1 { configNewTenant }
        2 { configNewUsers }
        3 { configNewCallQueue }
        4 { configNewAA }
        5 { configNewMemeberCQ }
        6 { configAAOptions }
    }

    return $option
}


function ShowSubMenu3 {
    Clear-Host
    Write-Host "---------- Sub Menu 3 - Testing ----------"
    Write-Host "1. TESTING"
    Write-Host "2. TESTING"
    Write-Host "3. TESTING"
    Write-Host "4. TESTING"
    Write-host "5. TESTING"
    Write-host "6. TESTING"

    $option = Read-Host "Select a configuration option(1-6)"

    # Validate the user's input
    if ($option -lt 1 -or $option -gt 6) {
        Write-Output "Invalid configuration option. Please select a number between 1 and 6."
        return
    }

    # Perform the corresponding action based on the user's option
    switch ($option) {
        1 { Option1Action }
        2 { Option2Action }
    }

    return $option
}

function diagTenantConfirm {

    Clear-Host
    collectTeamsTrunkID

    if ($script:lengthConfirmed = $true) {
        write-host "`n"
        write-host "########## VOICE ROUTES ############"
        write-host "`n"

        $voiceRoutes = Get-CsOnlineVoiceRoute | Select-Object Name, OnlinePstnGatewayList
        
        # Display the header with colors
        Write-Host ("{0,-20} {1}" -f "Name", "OnlinePstnGatewayList") -ForegroundColor Blue

        # Display each row with colors and check conditions
        $voiceRoutes | ForEach-Object {
            $voiceRouteName = $_.Name
            $gatewayList = $_.OnlinePstnGatewayList

            # Check if specific routes exist and their contents matches $trunkFullID01 or $trunkFullID02
            if ($voiceRouteName -eq "UK-SUBINTERNATIONAL" -or $voiceRouteName -eq "UK-SUB-NATIONAL" -or $voiceRouteName -eq "UK Emergency") {
                if ($gatewayList -contains $trunkFullID01 -or $gatewayList -contains $trunkFullID02) {
                    Write-Host ("{0,-20} {1}" -f $voiceRouteName, $gatewayList) -ForegroundColor Green
                }
            } else {
                Write-Host ("{0,-20} {1}" -f $voiceRouteName, $gatewayList) -ForegroundColor Red
            }
        } | Format-Table -AutoSize

        write-host "`n"
        write-host "############ PSTN USAGE ############" 
        write-host "`n"
        $pstnUsage = Get-CsOnlinePstnUsage -Identity Global

        if ($pstnUsage -contains "UK National" -and $pstnUsage -contains "International") {

            Write-Host "PSTN Usage Looks good!"

        } else{

            Write-host "PSTN Usage isn't configured correctly."

        }

        write-host $pstnUsage

        write-host "############ DNS RESOLUTION ############"

        Resolve-DNSName -Name $trunkFullID01

        $msteams01Result = Resolve-DNSName -Name $trunkFullID01 | Select-Object -ExpandProperty IPAddress

            if ($msteams01Result -contains "5.22.143.215") {

                    write-host ""
                    write-host "DNS for Primary Trunk looks good!" -ForegroundColor Green
                    write-host ""

             } else {

                write-host $script:teamsTrunkID".msteams01.aspiresip.com didn't resolve? Please confirm the DNS A record is configured in Go-Daddy"

             }

            Resolve-DNSName -Name  $trunkFullID02

            $msteams02Result = Resolve-DNSName -Name $trunkFullID02 | Select-Object -ExpandProperty IPAddress

            if ($msteams02Result -contains "148.253.173.215") {

                write-host "`n"
                write-host "DNS for Secondary Trunk looks good!" -ForegroundColor Green
                write-host "`n"

            } else {

                write-host $script:teamsTrunkID".msteams02.aspiresip.com didn't resolve? Please confirm the DNS A record is configured in Go-Daddy"

            }
    
    } else {

        write-host "Looks like that trunk ID isn't correct. Can you give it another blast please"
        
        collectTeamsTrunkID

    }


}

function diagListEVTrue{



}


function diagExportCallQueues{



}


function diagExportAAs {




}




          

############# Start of Script ###################
checkPSConnection

ShowMainMenu






##################################################

#Calls Function to collect TeamsTrunkID
#collectTeamsTrunkID
#checkTrunkIDLength
#write-host $trunkLength
#write-host $lengthConfirmed
#write-host $teamsTrunkID



#To Configure



# PSTN Usage
# Voice Routes
# Users (Enterprise Voice, License assignemnt + DDI Assignment)
# Queue Creation and License Assignment
# Auto Attendant Creation

#DDI Search - what is it assigned to?




#Connect to the Customer MS Teams Tenant
#Connect-MicrosoftTeams

#Setup PSTN Usage
#Set-CsOnlinePstnUsage -Identity Global -Usage @{Add="UK National"}
#Set-CsOnlinePstnUsage -Identity Global -Usage @{Add="International"}

#Create Voice Routes
#New-CsOnlineVoiceRoute -Identity UK-SUB-NATIONAL -Priority 3 -NumberPattern "^(\+44\d*)$" -OnlinePstnGatewayList 500032.msteams01.aspiresip.com, 500032.msteams02.aspiresip.com -OnlinePstnUsages ‘UK National’
#New-CsOnlineVoiceRoute -Identity UK-SUBINTERNATIONAL -Priority 1 -NumberPattern "^(\+\d*)$" -OnlinePstnGatewayList 500032.msteams01.aspiresip.com, 500032.msteams02.aspiresip.com -OnlinePstnUsages ‘International’

#Create Voice Routing Policies





