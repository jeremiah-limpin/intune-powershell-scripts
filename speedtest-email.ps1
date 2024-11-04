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
    }
}

# Download Speedtest CLI
try {
    if (-Not (Test-Path $speedtestExe)) {
        Write-Host "Speedtest CLI not found. Downloading..."
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
        Write-Host "Speedtest CLI found, proceeding to test."
    }
}
catch {
    Write-Error "Error downloading or extracting Speedtest CLI: $_"
    "[$(Get-Date)] Error: $_" | Out-File -FilePath $logFile -Append
    return
}

# Run Speedtest and output results
try {
    & $speedtestExe --accept-license --accept-gdpr | Out-File -FilePath $resultsFilePath -Encoding UTF8
    Write-Host "Speedtest results saved to: $resultsFilePath"
}
catch {
    Write-Error "Error running Speedtest: $_"
    "[$(Get-Date)] Error: $_" | Out-File -FilePath $logFile -Append
    return
}

# Send email with results
try {
    # Create a new Outlook application instance silently
    $OutlookApp = New-Object -ComObject Outlook.Application
    $Mail = $OutlookApp.CreateItem(0)  # 0 refers to a MailItem in Outlook

    $Mail.Subject = "Speedtest Results for $env:COMPUTERNAME"
    $Mail.Body = "Attached is the Speedtest result for $env:COMPUTERNAME."
    $Mail.To = "helpdesk@thebackroomop.com"
    $Mail.Attachments.Add($resultsFilePath)
    $Mail.Send()
        
    Write-Host "Email sent successfully."
    
} catch {
    Write-Error "Error sending email: $_"
    "[$(Get-Date)] Error: $_" | Out-File -FilePath $logFile -Append
}

# Clean up temporary files
if (Test-Path "$speedtestFolder\speedtest\*.tmp") {
    Remove-Item "$speedtestFolder\speedtest\*.tmp" -Force -ErrorAction SilentlyContinue
}