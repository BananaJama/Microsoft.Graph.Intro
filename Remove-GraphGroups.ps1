$DemoGroups = Get-MgGroup -All

$DemoGroups | ForEach-Object -Parallel {
    Remove-MgGroup -GroupId $_.Id
}