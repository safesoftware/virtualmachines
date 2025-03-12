1. Open File Explorer and enable file extensions and pin FMEData to favourites.
3. Enable "show hidden files and folders" and Show File Extensions.
4. Install G5 drivers
5. Download and install FME Form
6. Download and install FME Flow. FME Flow database user/user/pwd is fmeflow
7. Set Firefox to be default browser and pin to Task Bar. Disable search suggestions. Set FME Flow as homepage
9. Open FME Flow and license it. Save username and password. Load FoodVendors-Complete.fsproject
10. Open FME Workbench and Data Inspector to ensure they are properly licensed, and pin them to Task Bar.
11. Open SQL Server Management Studio
12. Set Connections to be Shared.
13. Add Web Connections for:
 FME Flow (Training FME Flow) and 
PostGIS (postgis.train.safe.com fmedata) as `FME Training PostGIS Database'
14. Add a connection for Microsoft SQL Server. `Localhost FMEData` `FMETRAINING\SQLEXPRESS`. Create an `fmedata` database.
15. Open Localhost in browser, and ensure that FME Flow is properly licensed. Check that Form and Flow licenses won't expire for at least 1 year.
16. Set the FME Flow engines to 4.
17. Disable auto-start for FME Flow.
18. Install the Mouse Powertoy.
19. Load the FoodVendors-Complete.fsproject project. May need encryption file in same folder.
20. Open Google Earth to see if it has a DirectX vs OpenGL warning. Set appropriately.
21. Run Ec2LaunchSettings. "Shutdown without Sysprep"
22. Create new AMI--leave Description blank. After the image is complete, edit the Description to `FME 20xx.x for Strigo`.

## FME 2025 Updates ##
1. Remove the old Business Licenses CSV reader from the FME Accelerator workspace
2. Place a copy of the BusinessLicenses SQLite database into the FME Accelerator data folder, and update the workspace.
