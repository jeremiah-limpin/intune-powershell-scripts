# Check if Microsoft Teams (personal) client is installed
if ($null -eq (Get-AppxPackage -Name MicrosoftTeams)) {
    # Microsoft Teams (personal) client not found, exit with code 0
    exit 0
} else {
    # Microsoft Teams (personal) client found, exit with code 1
    exit 1
}
