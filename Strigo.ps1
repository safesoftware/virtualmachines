<powershell>
# This is for use in Strigo User Data for individual courses.
# This file should only contain configuration that should be done class-by-class.
# === Configuration ===
$OpenWorkspace = $true    ### Set to $false if you don't want to open the .fmw file
$fmwURL = "https://s3.amazonaws.com/FMEData/FMEData/Resources/FMEAccelerator/FoodVendors-Start.fmw"    ### This is the URL to download the fmw from. Don't leave blank.
$fmwDIR = "C:\FMEData\Resources\FMEAccelerator"   ### This is the local folder for the workspace.
$fmw =  "FoodVendors-Start.fmw"   ### Name of the workspace to open. Must match URL name.

$StartFolder = "C:\FMEData\Resources\FMEAccelerator"  ### This is the default folder to open in FME Workbench.
$SharedConnectionsFolder = "C:\FMEData\Resources\FMEAccelerator" ### Where the shared connections database is stored

#=== Do Stuff ===
# Download the workspace
# Open Workbench
# Set Default Workbench paths for workspaces and datasets
# Configure shared connections database

# Always download the FMW file
$line1 = 'aria2c "{0}" --dir="{1}" --allow-overwrite=true' -f $fmwURL, $fmwDIR

# Always launch Workbench, optionally open the workspace
if ($OpenWorkspace) {
    $line2 = 'start "" /MAX "C:\Program Files\FME\FMEWorkbench.exe" "{0}\{1}" ' -f $fmwDIR, $fmw
} else {
    $line2 = 'start "" /MAX "C:\Program Files\FME\FMEWorkbench.exe"'
}

#We do it this way because it'll handle spaces in filenames.
$startup = @($line1, $line2)


# Create the batch file to run automatically.
Set-Content -Path 'C:\temp\startup.bat' -Value $startup

# copy the file to the startup folder. This is so you can also run the file from c:\temp.
Copy-Item 'c:\temp\startup.bat' "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\startup.bat"

# Set Starting Folder for when you open a workspace or dataset location.
$Registry = "HKCU:\SOFTWARE\Safe Software Inc.\Feature Manipulation Engine\GUI"

# Create the key if it doesn't exist
If (-Not (Test-Path $Registry)) {
    New-Item -Path $Registry -Force
}

# Set the two registry values
Set-ItemProperty -Path $Registry -Name "MostRecentDataPath" -Value $StartFolder
Set-ItemProperty -Path $Registry -Name "MostRecentWorkspacePath" -Value $StartFolder

# Fix the Shared Connections stuff. Terrible workaround. Unnecessary if I remember to do this when creating the AMI.

 $RegPath = "HKCU:\Software\Safe Software Inc.\Feature Manipulation Engine"  

  New-ItemProperty -Path "${RegPath}\Security" -Name "FME_SECURITY_CONNECTION_STORAGE_SHARED_DATABASE_FOLDER_PATH" -PropertyType String -Value "$SharedConnectionsFolder" -Force
  New-ItemProperty -Path "${RegPath}\Security" -Name "FME_SECURITY_CONNECTION_STORAGE_SHARED_KEY_FOLDER_PATH" -PropertyType String -Value "$SharedConnectionsFolder" -Force

  # Below, we can't use fme APPLY_SETTINGS as an empty-string argument is not valid
  New-ItemProperty -Path "${RegPath}\Security" -Name "FME_SECURITY_CONNECTION_STORAGE_SHARED_KEY_FOLDER_PASSWORD" -PropertyType String -Value "" -Force


</powershell>
<<persist>true</persist>
