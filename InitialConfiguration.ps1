<powershell>
# InitialConfiguration.ps1
# This script performs one-time configuration of an AWS EC2 Windows instance.
# This is used in AWS, but not Strigo.
# This script is intended to be run as part of the User Data for an EC2 instance.

# === CONFIGURATION ===

$ErrorActionPreference = 'Stop'  # Halt on all non-terminating errors

# Set script-wide variables
$OnstartConfigurationURL = "https://raw.githubusercontent.com/safesoftware/virtualmachines/strigo/OnstartConfiguration.bat"
$Temp = "C:\Temp"
$Log = "$Temp\InitialConfiguration.log"
$TimeZone = "Pacific Standard Time"
$NewComputerName = "FMETraining"
$AdminPassword = "FMElearnings#1"
$EnableScheduledShutdown = $false   ### This is for interviews
$EnableFlowShortcut = $false   ### This is for interviews
$RestartRequired = $false  # Flag to trigger reboot at the end if name change is needed. Do this if using an Amazon AMI.

# Ensure temp directory exists; create if not
if (-Not (Test-Path -Path $Temp)) {
    New-Item -ItemType Directory -Path $Temp | Out-Null
}
Set-Location $Temp  # Change to working directory

# Begin logging all console output to file
Start-Transcript -Path $Log -Append

# Set the system time zone
Set-TimeZone -Id $TimeZone

# Rename computer only if needed; defer reboot until end
if ((Rename-Computer -NewName $NewComputerName -Force -PassThru).Name -ne $NewComputerName) {
    Write-Host "Computer name will be changed to $NewComputerName on next reboot."
    $RestartRequired = $true
}

# Set the Administrator account password
net user Administrator $AdminPassword

# Set Administrator password to never expire using PowerShell
Set-LocalUser -Name "Administrator" -PasswordNeverExpires $true

# Show hidden files in Explorer and show file extensions
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Hidden" -Value 1
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Value 0



# Schedule a shutdown every Friday at 5:30 PM if enabled
if ($EnableScheduledShutdown) {
    schtasks /Create /F /RU SYSTEM /TN "AutoShutdown" /SC weekly /D FRI /ST 17:30 /TR "shutdown.exe /s /f"
}

# Create a public desktop shortcut to a document if enabled
if ($EnableFlowShortcut) {
    $shortcutPath = "C:\Users\Public\Desktop\Flow Scenario.url"
    Set-Content -Path $shortcutPath -Value "[InternetShortcut]`r`nURL=https://docs.google.com/document/d/1UdCmBCnFB4dAVYKq0DKcbxD-1QxllRA19M8USibyH54/edit?usp=sharing"
}

# Log a one-liner to indicate script execution finished
Add-Content "$Temp\StartupLog.txt" "$(Get-Date): Startup script executed."

function BasicSetup {
    Write-Host "Starting Basic Setup"

    # Define a list of ports and corresponding rules to allow in the firewall
    $rules = @(
        @{Name="FMEServer80"; Port=80},
        @{Name="FMEServer443"; Port=443},
        @{Name="SMTP"; Port=25},
        @{Name="WebSockets"; Port=7078},
        @{Name="TomcatExtra"; Port=8888}
    )

    # Create firewall rules for each port
    foreach ($rule in $rules) {
        New-NetFirewallRule -DisplayName $rule.Name -Direction Inbound -LocalPort $rule.Port -Protocol TCP -Action Allow -Profile Any -ErrorAction SilentlyContinue
    }
}

function ScheduleTasks {
    Write-Host "Checking for existing startup task..."

    # Only create the scheduled task if it doesn't already exist
    if (-Not (Get-ScheduledTask -TaskName "OnstartConfiguration" -ErrorAction SilentlyContinue)) {
        Write-Host "Creating startup task"
        $Action = New-ScheduledTaskAction -Execute "cmd.exe" -Argument "/C aria2c.exe $OnstartConfigurationURL --dir=C:\Temp --allow-overwrite=true && C:\Temp\OnstartConfiguration.bat"
        $Trigger = New-ScheduledTaskTrigger -AtStartup
        Register-ScheduledTask -TaskName "OnstartConfiguration" -Action $Action -Trigger $Trigger -User "SYSTEM" -RunLevel Highest -Force
    } else {
        Write-Host "Startup task 'OnstartConfiguration' already exists. Skipping creation."
    }
}

function HelpfulApps {
    Write-Host "Installing Chocolatey and essential apps"

    # Install Chocolatey only if not already present
    if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
        Set-ExecutionPolicy Bypass -Scope Process -Force
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    } else {
        choco upgrade chocolatey -y  # Upgrade existing installation
    }

    # Update PATH and install minimal tools
    $env:Path += ";$env:ALLUSERSPROFILE\chocolatey\bin"
    choco install aria2 7zip -y
}

function ChocoMoreApps {
    Write-Host "Installing additional Chocolatey packages"

    # Define desired packages
    $packages = @(
        "dotnet-desktopruntime",
        "sqlitebrowser",
        "notepadplusplus",
        "googlechrome",
        "firefox",
        "adobereader",
        "googleearth",
        "windirstat",
        "git",
        "github-desktop",
        "python",
        "eclipse",
        "postman",
        "openoffice",
        "sql-server-express",
        "ollama",
        "sql-server-management-studio"
    )

    # Install each package if it's not already installed
    foreach ($pkg in $packages) {
        if (-not (choco list --localonly | Select-String "^$pkg ")) {
            Write-Host "Installing $pkg..."
            choco install $pkg -y --ignore-checksums
        } else {
            Write-Host "$pkg is already installed. Skipping."
        }
    }
}

# === Main Execution ===
BasicSetup         # Setup firewall and other system configurations
ScheduleTasks      # Register startup task for future configuration
HelpfulApps        # Ensure core utilities are installed
ChocoMoreApps      # Install broader set of development and productivity tools

# End logging
Stop-Transcript

# If reboot is needed (e.g., due to hostname change), do it now
if ($RestartRequired) {
    Write-Host "Restarting computer to apply system changes..."
    Restart-Computer -Force
}

</powershell>
<persist>true</persist>