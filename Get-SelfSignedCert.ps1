$Splat = @{
    FilePath = 'C:\git-personal\Microsoft.Graph.Intro\SelfSignedCert.pfx' 
    Password = (ConvertTo-SecureString -AsPlainText -Force -String 'SecurePassword')
}
$Cert = Get-PfxCertificate @Splat
$Cert | Format-List