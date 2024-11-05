# Check if Microsoft Teams (personal) client is installed
if ((Get-AppxPackage -Name MicrosoftTeams -ErrorAction SilentlyContinue)) {
    # Microsoft Teams (personal) client found, exit with code 1
    exit 1
} else {
    # Microsoft Teams (personal) client not found, exit with code 0
    exit 0
}
# This script is developed by Jeremiah Limpin https://github.com/jeremiah-limpin