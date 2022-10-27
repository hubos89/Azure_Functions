$AllVnet = Get-AzVirtualNetwork
$i = 0
Write-Host
foreach ($Vnet in $AllVnet) {
    $i = $i + 1
    Write-Host $i :  $Vnet.Name
}
$Vnet = Read-Host "In which Vnet you want to proceed ? (1 first line, 2 second line etc.)"
$Vnet = $Vnet -1
$Vnet
if ($Vnet -lt $AllVnet.length) {
    Get-AzVirtualNetwork -Name $AllVnet[$Vnet].Name -ResourceGroupName $AllVnet[$Vnet].ResourceGroupName
}else {$test = $AllVnet.length;Write-Host "ERROR : context number not valid. must be between 0 and "$test}