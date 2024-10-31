#Script detects the new Microsoft Teams consumer app on Windows 11

if ($null -eq (Get-AppxPackage -Name MicrosoftTeams)) {
    # Microsoft Teams client not found
    exit 0
} else {
    # Microsoft Teams client found
    exit 1
}