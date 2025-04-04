## File Explorer ##
1. Open File Explorer and enable file extensions and pin FMEData to favourites.
3. Enable "show hidden files and folders" and Show File Extensions.

## Install Graphics Drivers ##   
1. Install G5 drivers

## Configure SQL Server ##
1. Open SQL Server Management Studio
2. Create fmedata database
3. Add [NT AUTHORITY\SYSTEM] to fmedata

## Install FME Platform ##
7. Download and install FME Form
8. Download and install FME Flow. FME Flow database user/user/pwd is fmeflow
9. Set Firefox to be default browser and pin to Task Bar. Disable search suggestions. Set FME Flow as homepage
10. Open FME Flow and license it. Save username and password. Load FoodVendors-Complete.fsproject
11. Open FME Workbench and Data Inspector to ensure they are properly licensed, and pin them to Task Bar.

13. Set Connections to be Shared. Save to `C:\Users\Administrator\Documents\FME\Workspaces`. Password is `fmedata`
14. 20. Open c:\FMEData\Resources\FMEAccelerator\FoodVendors-Start.fmw and install required packages.
15. Add Web Connections for:
 FME Flow (Training FME Flow) and 
PostGIS (postgis.train.safe.com fmedata) as `FME Training PostGIS Database'
16. Add a connection for Microsoft SQL Server. `Localhost FMEData` `FMETRAINING\SQLEXPRESS`. Create an `fmedata` database.
17. Open Localhost in browser, and ensure that FME Flow is properly licensed. Check that Form and Flow licenses won't expire for at least 1 year.
18. Set the FME Flow engines to 4.
19. Disable auto-start for FME Flow.
20. Install the Mouse Powertoy.
21. Load the FoodVendors-Complete.fsproject project. May need encryption file in same folder.
22. Open Google Earth to see if it has a DirectX vs OpenGL warning. Set appropriately.
23. Run Ec2LaunchSettings. "Shutdown without Sysprep"
24. Create new AMI--leave Description blank. After the image is complete, edit the Description to `FME 20xx.x for Strigo`.

## FME 2025 Updates ##
2. Place a copy of the BusinessLicenses SQLite database into the FME Accelerator data folder, and update the workspace.
