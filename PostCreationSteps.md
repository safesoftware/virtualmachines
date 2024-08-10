1. Open File Explorer and enable file extensions and pin FMEData to favourites.
2. Enable "show hidden files and folders" and Show File Extensions.
3. Set Firefox to be default browser and pin to Task Bar. Disable search suggestions. Set FME Flow as homepage
4. Open FME Flow and license it. Save username and password. Load FoodVendors-Complete.fsproject
5. Open FME Workbench and Data Inspector to ensure they are properly licensed, and pin them to Task Bar.
6. Add connections for FME Flow (Training FME Server) and PostGIS (postgis.train.safe.com fmedata) as `FME Training PostGIS Database'
7. Add a connection for Microsoft SQL Server. `Localhost FMEData` `FMETRAINING\SQLEXPRESS`. Create an `fmedata` database.
9. Open Localhost in browser, and ensure that FME Flow is properly licensed. Check that Form and Flow licenses won't expire for at least 1 year.
10. Load the FoodVendors-Complete.fsproject project. May need encryption file in same folder.
11. Open Google Earth to see if it has a DirectX vs OpenGL warning. Set appropriately.
12. Run Ec2LaunchSettings. "Shutdown without Sysprep"
13. Create new AMI--leave Description blank. After the image is complete, edit the Description to `FME 20xx.x for Strigo`.
