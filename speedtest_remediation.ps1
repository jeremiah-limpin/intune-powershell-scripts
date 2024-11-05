# Get the file path of Documents folder of OneDrive
$oneDriveDocuments = Join-Path $env:OneDrive "Documents"

# Create a folder for speedtest
$speedtestFolder = "$oneDriveDocuments\Speedtest"
$speedtestExe = Join-Path $speedtestFolder "speedtest.exe"

# Get device name
$computerName = $env:COMPUTERNAME

# Set the file name and path of the output
$resultsFilePath = Join-Path $speedtestFolder "speedtest_result_of_$computerName.txt"
$logFile = Join-Path $speedtestFolder "error_log.txt"

# Ensure speedtest folder exists
if (-Not (Test-Path $speedtestFolder)) {
    New-Item -Path $speedtestFolder -ItemType Directory
    if (-Not (Test-Path $speedtestFolder)) {
        throw "Failed to create Speedtest folder: $speedtestFolder"
        exit 2
    }
}

# Download Speedtest CLI
try {
    if (-Not (Test-Path $speedtestExe)) {
        # Speedtest CLI not found, proceeds to download the app
        $retryCount = 0
        $maxRetries = 3
        while ($retryCount -lt $maxRetries) {
            try {
                Invoke-WebRequest -Uri "https://install.speedtest.net/app/cli/ookla-speedtest-1.0.0-win64.zip" -OutFile "$speedtestFolder\speedtest.zip"
                Expand-Archive -Path "$speedtestFolder\speedtest.zip" -DestinationPath $speedtestFolder
                Remove-Item "$speedtestFolder\speedtest.zip" -Force  # Cleanup
                break
            }
            catch {
                $retryCount++
                if ($retryCount -eq $maxRetries) {
                    throw
                }
                Start-Sleep -Seconds 5  # Wait before retry
            }
        }
    }
    else {
        # Speedtest CLI found, proceeding to test
    }
} catch {
    # Error downloading or extracting Speedtest CLI
    "[$(Get-Date)] Error: $_" | Out-File -FilePath $logFile -Append
    # Clean up temporary files
    if (Test-Path "$speedtestFolder\speedtest\*.tmp") {
        Remove-Item "$speedtestFolder\speedtest\*.tmp" -Force -ErrorAction SilentlyContinue
    }
    exit 2
}

# Run Speedtest and output results
try {
    & $speedtestExe --accept-license --accept-gdpr | Out-File -FilePath $resultsFilePath -Encoding UTF8
    # Speedtest results saved to: $resultsFilePath
} catch {
    # Error running Speedtest
    "[$(Get-Date)] Error: $_" | Out-File -FilePath $logFile -Append
    # Clean up temporary files
    if (Test-Path "$speedtestFolder\speedtest\*.tmp") {
        Remove-Item "$speedtestFolder\speedtest\*.tmp" -Force -ErrorAction SilentlyContinue
    }
    exit 2
}

# Update the timestamp file after remediation runs successfully
(Get-Date) | Out-File -FilePath "$oneDriveDocuments\Speedtest\last_run_timestamp.txt" -Force

# Send email with results
try {
    # Create a new Outlook application instance silently
    $OutlookApp = New-Object -ComObject Outlook.Application
    $Mail = $OutlookApp.CreateItem(0)  # 0 refers to a MailItem in Outlook

    $Mail.Subject = "Speedtest Result for $env:COMPUTERNAME"
    $Mail.Body = "Attached is the Speedtest result for $env:COMPUTERNAME."
    $Mail.To = "helpdesk@thebackroomop.com"
    $Mail.Attachments.Add($resultsFilePath)
    $Mail.Send()
    # Email sent successfully

    # Clean up temporary files
    if (Test-Path "$speedtestFolder\speedtest\*.tmp") {
        Remove-Item "$speedtestFolder\speedtest\*.tmp" -Force -ErrorAction SilentlyContinue
    }
    exit 0
} catch {
    # Error sending email
    "[$(Get-Date)] Error: $_" | Out-File -FilePath $logFile -Append
    # Clean up temporary files
    if (Test-Path "$speedtestFolder\speedtest\*.tmp") {
        Remove-Item "$speedtestFolder\speedtest\*.tmp" -Force -ErrorAction SilentlyContinue
    }
    exit 2
}

# This script is developed by Jeremiah Limpin https://github.com/jeremiah-limpin