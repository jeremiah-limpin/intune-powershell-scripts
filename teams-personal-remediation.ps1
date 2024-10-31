#Script removes the new Microsoft Teams consumer app on Windows 11.

try{
    Get-AppxPackage -Name MicrosoftTeams | Remove-AppxPackage -ErrorAction stop
    Write-Host "Microsoft Teams app successfully removed"
}catch{
    Write-Error "Errorremoving Microsoft Teams app"
    exit 2
}