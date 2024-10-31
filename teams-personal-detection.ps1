# Script detects the new Microsoft Teams consumer app on Windows 11

if ((Get-AppxPackage -Name MicrosoftTeams) -eq $null) {
    # Microsoft Teams (personal) client not found
    exit 0
} else {
    # Microsoft Teams (personal) client found
    exit 1
}