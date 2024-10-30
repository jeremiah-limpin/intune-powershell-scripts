# Define the location of the uninstall executable file
$UninstallPath = "C:\Program Files\McAfee\WebAdvisor\uninstaller.exe"
# Execute the uninstall command
Start-Process -FilePath $UninstallPath -ArgumentList '/S' -Wait -PassThru