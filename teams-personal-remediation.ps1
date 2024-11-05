# Script to remove the Microsoft Teams consumer app on Windows 11
try {
    # Check if the Microsoft Teams (personal) app is installed
    $teamsApp = Get-AppxPackage -Name MicrosoftTeams -ErrorAction SilentlyContinue
    if ($null -eq $teamsApp) {
        # Microsoft Teams (personal) app not found; exit with code 0 (no action needed)
        exit 0
    }
    # Remove the Microsoft Teams (personal) app
    $teamsApp | Remove-AppxPackage -ErrorAction Stop
    # Successfully removed; exit with code 0
    exit 0

} catch {
    # Error encountered while attempting to remove the app; exit with code 2
    exit 2
}
# This script is developed by Jeremiah Limpin https://github.com/jeremiah-limpin