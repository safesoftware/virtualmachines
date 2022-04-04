1. Unpin Microsoft Edge from Task Bar.
2. Open File Explorer and enable file extensions and pin FMEData to favourites.
3. Enable "show hidden files and folders"
4. Set Chrome to be default browser and pin to Task Bar.
5. Open FME Server and license it. Save username and password. Load FoodVendors-Complete.fsproject
6. Open FME Workbench and Data Inspector to ensure they are properly licensed, and pin them to Task Bar.
7. Add connections for FME Server (Training FME Server) and PostGIS (postgis.train.safe.com fmedata)
8. Add Stamen map to Workbench. Maximize view. Save a workspace and close so the setting is remembered.
9. Open Localhost in browser, and ensure that FME Server is properly licensed.
10. Open Google Earth to see if it has a DirectX vs OpenGL warning. Set appropriately.
11. Run Ec2LaunchSettings. "Shutdown without Sysprep"
12. Create new AMI--leave Description blank. After the image is complete, edit the Description to `FME 20xx.x for Strigo`.
