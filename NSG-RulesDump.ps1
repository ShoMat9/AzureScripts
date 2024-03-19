## You know what to edit!!

$SubscriptionName = "sub1" 
$nsgname = "myNSG" 
$ShoReport = Get-Date -UFormat "C:\X-Sho\Scripts\Reports\NSG-rules-%Y%b%d@%I%M%p.csv" 

Set-AzContext -SubscriptionName $SubscriptionName
$outputfinal=@()
$nsg=Get-AzNetworkSecurityGroup -Name $nsgname
$securityrules=$nsg.SecurityRules
foreach ($securityrule in $securityrules)
{
$outputtemp = "" | SELECT  NSGName,NSGLocation,RGName,Direction,Priority,RuleName,DestinationPort,Protocol,SourceAddress,SourcePort,DestinationAddress,Action,Description
$outputtemp.NSGName=$nsg.name
$outputtemp.NSGLocation=$nsg.location
$outputtemp.RGName=$nsg.ResourceGroupName
$outputtemp.Direction=$securityrule.direction
$outputtemp.Priority=$securityrule.Priority
$outputtemp.RuleName=$securityrule.Name
$outputtemp.DestinationPort=$securityrule.DestinationPortRange -join ", "
$outputtemp.Protocol=$securityrule.Protocol -join ", "
$outputtemp.SourceAddress=$securityrule.SourceAddressPrefix -join ", "
$outputtemp.SourcePort=$securityrule.SourcePortRange -join ", "
$outputtemp.DestinationAddress=$securityrule.DestinationAddressPrefix -join ", "
$outputtemp.Action=$securityrule.Access
$outputtemp.Description=$securityrule.Description
$outputfinal += $outputtemp
}

$outputfinal | Export-Csv -Path $ShoReport -NoTypeInformation
