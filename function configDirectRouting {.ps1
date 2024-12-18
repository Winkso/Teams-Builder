function configDirectRouting {

    $trunkFullID01 = 500006.msteams01.aspiresip.com
    $trunkFullID02 = 500006.msteams02.aspiresip.com
    
    write-host 'Set-CsOnlinePstnUsage -Identity Global -Usage @{Add="UK National"}'
    write-host 'Set-CsOnlinePstnUsage -Identity Global -Usage @{Add="International"}'
    write-host 'New-CsOnlineVoiceRoute -Identity UK-SUB-NATIONAL -Priority 3 -NumberPattern "^(\+44\d*)$" -OnlinePstnGatewayList $trunkFullID01, $trunkFullID02 -OnlinePstnUsages "UK National"'


}
