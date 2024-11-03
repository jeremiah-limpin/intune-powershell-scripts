# Script removes the new Microsoft Teams consumer app on Windows 11

try {
    Get-AppxPackage -Name MicrosoftTeams | Remove-AppxPackage -ErrorAction Stop
    # Microsoft Teams (personal) app successfully removed
    exit 0
} catch {
    # Error removing Microsoft Teams (personal) app
    exit 2
}