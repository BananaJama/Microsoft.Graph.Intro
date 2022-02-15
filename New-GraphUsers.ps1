# Functions
function ConstructUPN ($FirstName, $MiddleName, $LastName) {
    if ($MiddleName) {
        $UPN = "{0}.{1}.{2}@Chrimeny.com" -f $FirstName, $MiddleName.Substring(0,1), $LastName
    }
    else {
        $UPN = "{0}.{1}@Chrimeny.com" -f $FirstName, $LastName
    }
    $UPN = $UPN.replace(' ','').replace('''','')

    if (Get-MgUser -filter "UserPrincipalName eq '$UPN'") {
        $UpnSplit = $UPN.Split('@')
        $DuplicatesCount = (Get-MgUser -Filter "startswith(UserPrincipalName, '$UpnSplit')").count
        $UPN = "{0}@{1}" -f ($UpnSplit[0] + ($DuplicatesCount + 1)).ToString(), $UpnSplit[1]
    }
    
    $UPN
}

function ConstructName ($Name) {
    $Name = $Name.Trim()
    
    if ($Name -match '-') {
        $NameSplit = $Name.Split('-')
        $CorrectedNameSplit = @()
        foreach ($Hyphenation in $NameSplit) {
            $CaseCorrection = $Hyphenation.Substring(0,1).ToUpper() + $Hyphenation.Substring(1).ToLower()
            $CorrectedNameSplit += $CaseCorrection
        }
        $Name = $CorrectedNameSplit -join '-'
    }
    else {
        $Name = $Name.Substring(0,1).ToUpper() + $Name.Substring(1).ToLower()
    }

    if ($Name -match "'") {
        $Name = $Name.replace("'","")
    }

    $Name
}

# Main Script
$Users = Invoke-RestMethod -Uri 'https://genident.azurewebsites.net/api/newIdentity?UserCount=20'

foreach ($User in $Users) {
    $Fn = ConstructName -Name $User.GivenName
    $Ln = ConstructName -Name $User.Surname

    if ($User.GivenName.Length -le 3) {
        $FnPrefix = $User.GivenName
    }
    else {
        $FnPrefix = $User.GivenName.Substring(0,3)
    }

    if ($User.Surname.Length -le 3) {
        $LnPrefix = $User.Surname
    }
    else {
        $LnPrefix = $User.Surname.Substring(0,3)
    }

    $PasswordProfile = @{
        Password = "{0}{1}{2}" -f $FnPrefix, $LnPrefix, (Get-Date).Year
    }

    $Splat = @{
        DisplayName = "{0}, {1}" -f $Ln, $Fn
        GivenName = $Fn
        Surname = $Ln
        MailNickName = "{0}{1}" -f $FnPrefix, $LnPrefix
        UserPrincipalName = ConstructUPN -FirstName $User.GivenName -LastName $User.Surname
        PasswordProfile = $PasswordProfile
        AccountEnabled = $true
        CompanyName = 'Chrimeny Toys'
        Department = $User.Dept
        City = $User.City
        State = $User.StateId
        JobTitle = 'Temp'
    }
    New-MgUser @Splat
}