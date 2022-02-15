$AllUsers = Get-MgUser -Property Department, Id -All
$Groups = $AllUsers | Group-Object Department | Select-Object -ExpandProperty Name

$Groups | Where-Object {$_.Length -ne 0} | ForEach-Object {
    $Group = Get-MgGroup -Filter "DisplayName eq '$_'"
    $Users = $AllUsers | Where-Object {$_.Department -eq $($Group.DisplayName)}

    $Users | ForEach-Object {
        New-MgGroupMember -GroupId $Group.Id -DirectoryObjectId $_.Id
    }
}