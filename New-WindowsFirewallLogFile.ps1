Function New-WindowsFirewallLogFile {

    param (
        [Parameter(Mandatory=$true)][String]$Path,
        [Switch]$Force
    )
    
    # If the target logfile doesn't exist or it does and -Force has been passed
    If ((!(Test-Path -Path $Path)) -or ((Test-Path -Path $Path) -and $Force )) {
        
        # Remove the file we're about to recreate if there is any
        Remove-Item -Force -Verbose -Path $Path -ErrorAction SilentlyContinue
        
        # Create the new file
        New-Item -Force -Path $Path -ItemType File

        # Populate the file's DACL 
        Start-Process -NoNewWindow -Wait -FilePath "C:\Windows\System32\icacls.exe" -ArgumentList "$($Path) /inheritance:R"
        Start-Process -NoNewWindow -Wait -FilePath "C:\Windows\System32\icacls.exe" -ArgumentList "$($Path) /grant `"NT AUTHORITY\SYSTEM`":F"
        Start-Process -NoNewWindow -Wait -FilePath "C:\Windows\System32\icacls.exe" -ArgumentList "$($Path) /grant BUILTIN\Administrators:F"
        Start-Process -NoNewWindow -Wait -FilePath "C:\Windows\System32\icacls.exe" -ArgumentList "$($Path) /grant `"BUILTIN\Network Configuration Operators`":F"
        Start-Process -NoNewWindow -Wait -FilePath "C:\Windows\System32\icacls.exe" -ArgumentList "$($Path) /grant `"NT SERVICE\MpsSvc`":F"

    }

}