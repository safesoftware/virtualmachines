## File Explorer ##
1. Open File Explorer and enable file extensions and pin FMEData to favourites.
3. Enable "show hidden files and folders" and Show File Extensions.

## Set Account Lockout Threshold to 0 (No Lockout)
Open PowerShell as Administrator, then run:
`net accounts /lockoutthreshold:0`

## Install Graphics Drivers ##   
1. Install G5 drivers

## Configure SQL Server ##
1. Open SQL Server Management Studio, and execute the following:
```
CREATE DATABASE fmedata;
GO

USE fmedata;
GO

CREATE LOGIN [NT AUTHORITY\SYSTEM] FROM WINDOWS;
GO

CREATE USER [NT AUTHORITY\SYSTEM] FOR LOGIN [NT AUTHORITY\SYSTEM];
GO

ALTER ROLE db_owner ADD MEMBER [NT AUTHORITY\SYSTEM];
GO
```
## Prepare for shared connection database ##
1. From Powershell, run the following
```
# Fix the Shared Connections stuff. Terrible workaround.
 $RegPath = "HKCU:\Software\Safe Software Inc.\Feature Manipulation Engine"  

  New-ItemProperty -Path "${RegPath}\Security" -Name "FME_SECURITY_CONNECTION_STORAGE_SHARED_DATABASE_FOLDER_PATH" -PropertyType String -Value "C:\FMEData\Resources\FMEAccelerator" -Force
  New-ItemProperty -Path "${RegPath}\Security" -Name "FME_SECURITY_CONNECTION_STORAGE_SHARED_KEY_FOLDER_PATH" -PropertyType String -Value "C:\FMEData\Resources\FMEAccelerator" -Force

  # Below, we can't use fme APPLY_SETTINGS as an empty-string argument is not valid
  New-ItemProperty -Path "${RegPath}\Security" -Name "FME_SECURITY_CONNECTION_STORAGE_SHARED_KEY_FOLDER_PASSWORD" -PropertyType String -Value "" -Force
```

## Install FME Flow ##
1. Download and install FME Flow. FME Flow database user/user/pwd is fmeflow
2. Disable auto-start for FME Flow using `services.msc`
```
sc.exe config "FMEFlowAppServer" start= demand
sc.exe config "FME Flow Core" start= demand
sc.exe config "FME Flow Database" start= demand
sc.exe config "FME Flow Engines" start= demand
```
3. Set Firefox to be default browser and pin to Task Bar. Disable search suggestions. Set FME Flow as homepage
4. Open FME Flow and license it. Save username and password `admin` and `FMElearnings`.
11. Load FoodVendors-Complete.fsproject
12. Set the FME Flow engines to 4.

    
## Install FME Form ##
1. Download and install FME Form
2. Open FME Workbench and Data Inspector to ensure they are properly licensed, and pin them to Task Bar.
13. Set Connections to be Shared. Save to `C:\FMEData\Resources\FMEAccelerator`.
14. Open c:\FMEData\Resources\FMEAccelerator\FoodVendors-Start.fmw and install required packages.
15. Add Web Connections for:
 FME Flow (Training FME Flow) and 
PostGIS (postgis.train.safe.com fmedata) as `FME Training PostGIS Database'
16. Add a connection for Microsoft SQL Server. `Localhost FMEData` `FMETRAINING\SQLEXPRESS`. Create an `fmedata` database.
17. Open Localhost in browser, and ensure that FME Flow is properly licensed. Check that Form and Flow licenses won't expire for at least 1 year.
20. Install the Mouse Powertoy.
22. Open Google Earth to see if it has a DirectX vs OpenGL warning. Set appropriately.
23. Run Ec2LaunchSettings. "Shutdown without Sysprep"
24. Create new AMI--leave Description blank. After the image is complete, edit the Description to `FME 20xx.x for Strigo`.

## Update FME Flow ##
1. Download latest FME Flow
2. Download encryption key
3. Download backup
4. Stop FME Flow services
5. Uninstall FME Flow
6. Install new FME Flow
7. Disable auto-start for FME Flow using `services.msc`
```
sc.exe config "FMEFlowAppServer" start= demand
sc.exe config "FME Flow Core" start= demand
sc.exe config "FME Flow Database" start= demand
sc.exe config "FME Flow Engines" start= demand
```
8. Reboot or run Startup.bat to retrieve license
8. Update password from admin to FMElearnings
9. Change engines to 4
10. Install encryption key
11. Load backup

## Update FME Form ##
1. Download latest FME Form
2. Install over existing Form
3. Launch Form and pin to Taskar
4. Run Ec2LaunchSettings. "Shutdown without Sysprep"
5. Create new AMI--leave Description blank. After the image is complete, edit the Description to `FME 20xx.x for Strigo`.

