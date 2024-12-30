:: ::ONSTART ONLY!::::
:: These are things that should always be done ONSTART
:: We call this instead of just using UserData so that we can update this while machines are running

:: Set all the required variables
   set TEMP=c:\temp
   set LOG=%TEMP%\OnstartConfiguration.log
   :: ESRIDATE is MM/DD/YYYY. Terrible I know, but that's how it is. Enter course date here
   set ESRIDATE=03/23/2021
   set ESRINUM=ESU250963400
   md %TEMP%
   pushd %TEMP%

:: Call the different sections and log them
   if %date:~4%==%ESRIDATE% call :esri >>%LOG%
   call :fmeserverhoops >>%LOG%
   call :urls >>%LOG%
   call :fmedatadownload >>%LOG%
   call :fmeserverhoops >>%LOG%
   call :emptyRecycleBin >>%LOG%



:: Indicate the end of the log file.
   echo "Onstart Configuration complete" >>%LOG%
   exit /b

:emptyRecycleBin
	:: For 2024, we need to delete "C:\Users\Administrator\AppData\Roaming\Safe Software\FME\fme_userconnection.data"
	:: del /s /q "C:\Users\Administrator\AppData\Roaming\Safe Software\FME\fme_userconnection.data"
	choco install powertoys -y
	del /s /q %systemdrive%\$Recycle.bin
goto :eof

:urls
	:: Adding URLs to the desktop is the preferred way of giving students their manuals. Ensures that everyone is using the same manuals
	:: Add the URLs to c:\users\public\desktop. That way everyone gets it.
	:: FME Desktop Course Resources
		del /s /q c:\users\public\desktop\*.url

		echo [InternetShortcut] > "c:\users\public\desktop\FMEData File List.url"
		echo URL=https://s3.amazonaws.com/FMEData/FMEData/index.html  >>"c:\users\public\desktop\FMEData File List.url"



		:: echo [InternetShortcut] > "c:\users\public\desktop\Getting Started with FME Desktop.url"
		:: echo URL=https://community.safe.com/s/article/getting-started-with-fme-desktop-translate-data-be  >>"c:\users\public\desktop\Getting Started with FME Desktop.url"

		:: echo [InternetShortcut] > "c:\users\public\desktop\My IP Address.url"
		:: echo URL=https://www.google.com/search?q=my+ip+address  >>"c:\users\public\desktop\My IP Address.url"

		:: echo [InternetShortcut] > "c:\users\public\desktop\FME Server Authoring Manual.url"
		:: echo URL=https://s3.amazonaws.com/gitbook/Server-Authoring-2020/index.html  >>"c:\users\public\desktop\FME Server Authoring Manual.url"

		:: echo [InternetShortcut] > "c:\users\public\desktop\FME Desktop Overview.url"
		:: echo URL=https://tinyurl.com/yypz3xh8  >>"c:\users\public\desktop\FME Desktop Overview.url"
goto :eof

:fmeserverhoops
	:: FME Server sometimes doesn't like to start properly. Halt it and try again here
	:: aria2c https://raw.githubusercontent.com/safesoftware/virtualmachines/strigo/LicenseArcGIS.bat --out=LicenseArcGIS.bat --allow-overwrite=true
	:: copy LicenseArcGIS.bat c:\users\public\desktop\ /Y
	:: aria2c https://s3.amazonaws.com/FMETemp/Server_July.fmelic --dir="c:\ProgramData\Safe Software\FME Server\licenses" --out=fme_server.fmelic --allow-overwrite=true
	aria2c https://s3.amazonaws.com/FMETemp/Server_January.fmelic --dir="c:\ProgramData\Safe Software\FMEFlow\licenses" --out=fme_server.fmelic --allow-overwrite=true
	
	:: CALL "C:\Program Files\FMEServer\Server\WindowsService\restartFMEServerWindowsService.bat"
	CALL "C:\Program Files\FMEFlow\Server\WindowsService\restartFMEServerWindowsService.bat"

goto :eof

:fmedatadownload
	:: download and install the current FMEData from www.safe.com/download
	:: aria2c https://raw.githubusercontent.com/safesoftware/virtualmachines/strigo/FMEInstalls/FMEDataDownloadInstall.bat --out=FMEDataDownloadInstall.bat --allow-overwrite=true
	:: CALL FMEDataDownloadInstall.bat
	pushd %TEMP%

	aria2c https://s3.amazonaws.com/FMEData/FMEData.zip --allow-overwrite=true

	:: aria2c https://s3.amazonaws.com/FMEData/FMEData2022.zip --allow-overwrite=true

	:: aria2c https://s3.amazonaws.com/FMEData/FMEData2019.zip --allow-overwrite=true
	for %%f in (FMEDATA*.zip) do 7z x -oc:\ -aoa %%f
	:: aria2c https://s3.amazonaws.com/FMEData/FMEData2021.zip --allow-overwrite=true
	:: aria2c https://s3.amazonaws.com/FMEData/FMEData2020.zip --allow-overwrite=true
	
	:: aria2c https://s3.amazonaws.com/FMEData/FMEData/Resources/Interagency/CreateDowntownParksSQLServer.fmw --allow-overwrite=true
	:: start "" "C:\Program Files\FME\fme.exe" CreateDowntownParksSQLServer.fmw
	
	:: Unzip FMEData
	:: 7z x -oc:\ -aoa FMEData2021.zip
	:: 7z x -oc:\ -aoa FMEData2020.zip

goto :eof

:esri
	call :prvc>course.prvc
	del /s /q /A:H c:\programdata\flexnet\*.*
	del /s /q c:\programdata\flexnet\*.*
	"%ProgramFiles%\ArcGIS\Pro\bin\SoftwareAuthorizationPro.exe" /LIF course.prvc /s

goto :eof



:prvc
@echo off

echo // User Information
echo First Name=ESRI
echo Last Name=Partner
echo Organization=SAFE
echo Department=Dev
echo Email=train@safe.com
echo Address 1=380 New York St.
echo City=Redlands
echo State/Province=CA
echo Location=United States
echo Location Code=US
echo Zip/Postal Code=92373
echo Phone Number=909-793-2853
echo Your Organization=Commercial/Private Business
echo Your Industry=Other
echo Yourself=Other
echo.
echo // Features and authorization numbers
echo ArcGIS Pro Advanced=%ESRINUM%

@echo on
@goto :eof


:: Update Firewall
:: netsh firewall add portopening TCP 8888 "Extra Tomcat webservice port"
