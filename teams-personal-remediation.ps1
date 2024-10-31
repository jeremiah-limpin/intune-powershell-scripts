#Script removes the new Microsoft Teams consumer app on Windows 11

try{
    Get-AppxPackage -Name MicrosoftTeams | Remove-AppxPackage -ErrorAction stop
    # Microsoft Teams app successfully removed
}catch{
    # Errorremoving Microsoft Teams app
    exit 2
}