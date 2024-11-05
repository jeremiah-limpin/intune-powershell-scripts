# Script to remove the Microsoft Teams consumer app on Windows 11
$teamsApp = Get-AppxPackage -Name MicrosoftTeams -ErrorAction SilentlyContinue

if ($teamsApp) {
    # Attempt to remove the Microsoft Teams (personal) app
    try {
        $teamsApp | Remove-AppxPackage -ErrorAction Stop
    } catch {
        # If removal fails, exit with code 2 (indicating an error occurred)
        exit 2
    }
    # Re-check if the app is still installed
    $teamsApp = Get-AppxPackage -Name MicrosoftTeams -ErrorAction SilentlyContinue
}

# Determine final exit code
if ($teamsApp) {
    # Microsoft Teams (personal) client is still found, indicating removal failure
    exit 2
} else {
    # Microsoft Teams (personal) client not found, removal successful
    exit 0
}
# This script is developed by Jeremiah Limpin https://github.com/jeremiah-limpin