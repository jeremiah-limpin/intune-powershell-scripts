$TeamViewer = Get-WmiObject -Class Win32_Product | Where-Object{$_.Name -eq "TeamViewer Host"}
$TeamViewer.Uninstall()
# This script is developed by Jeremiah Limpin https://github.com/jeremiah-limpin