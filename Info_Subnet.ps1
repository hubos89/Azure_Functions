
$AllSubscriptions = Get-AzSubscription | Out-String
Write-Host $AllSubscriptions
$AllSubscriptions=Get-AzSubscription
$Context = Read-Host "In which context you want to proceed ? (1 first line, 2 second line etc.)"
$Context = $Context -1
if ($Context -lt $AllSubscriptions.length) {
    Set-AzContext $AllSubscriptions[$Context]
    $AllVnet = Get-AzVirtualNetwork
    $i = 0
    Write-Host
    foreach ($Vnet in $AllVnet) {
        $i = $i + 1
        Write-Host $i :  $Vnet.Name
    }
    $Vnet = Read-Host "In which Vnet you want to proceed ? (1 first line, 2 second line etc.)"
    $Vnet = $Vnet -1
    if ($Vnet -lt $AllVnet.length) {
        $TheVnet = Get-AzVirtualNetwork -Name $AllVnet[$Vnet].Name -ResourceGroupName $AllVnet[$Vnet].ResourceGroupName
        Write-Host
        $AllSubnets = $TheVnet.Subnets
        $i = 0
        foreach ($Subnet in $AllSubnets) {
            $i = $i + 1
            Write-Host $i :  $Subnet.Name
        }
        $Subnet = Read-Host "In Subnet Vnet you want to proceed ? (1 first line, 2 second line etc.)"
        $Subnet = $Subnet -1
        if ($Subnet -lt $i) {
            Get-AzVirtualNetworkSubnetConfig -ResourceId $AllSubnets[$Subnet].Id
        }else {$test = $i;Write-Host "ERROR : Subnet number not valid. must be between 0 and "$test}
    }else {$test = $AllVnet.length;Write-Host "ERROR : Vnet number not valid. must be between 0 and "$test}
}else {$test = $AllSubscriptions.length;Write-Host "ERROR : context number not valid. must be between 0 and "$test}