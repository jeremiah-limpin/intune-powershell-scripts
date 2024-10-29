$val = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore" -Name "RPSessionInterval"
if($val.RPSessionInterval -ne 1){
    exit 1
} else{
    exit 0
}
