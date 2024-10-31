# Script detects the new Microsoft Teams consumer app on Windows 11

if ($null -eq (Get-AppxPackage -Name MicrosoftTeams)) {
    # Microsoft Teams (personal) client not found
    exit 0
} else {
    # Microsoft Teams (personal) client found
    exit 1
}