::::ONSTART ONLY!::::
:: These are things that should always be done ONSTART
:: We call this instead of just using UserData so that we can update this while machines are running

:: Set all the required variables
   set TEMP=c:\temp
   set LOG=%TEMP%\OnstartConfiguration.log
   :: ESRIDATE is MM/DD/YYYY. Terrible I know, but that's how it is. Enter course date here
   set ESRIDATE=10/21/2020
   set ESRINUM=ESU141956354
   md %TEMP%
   pushd %TEMP%

:: Call the different sections and log them
   call :emptyRecycleBin >>%LOG%
   call :urls >>%LOG%
   call :fmedatadownload >>%LOG%
   if %date:~4%==%ESRIDATE% call :esri >>%LOG%


:: Indicate the end of the log file.
   echo "Onstart Configuration complete" >>%LOG%
   exit /b

:emptyRecycleBin
	del /s /q %systemdrive%\$Recycle.bin
goto :eof	

:urls
	:: Adding URLs to the desktop is the preferred way of giving students their manuals. Ensures that everyone is using the same manuals
	:: Add the URLs to c:\users\public\desktop. That way everyone gets it.
	:: FME Desktop Course Resources
	
		echo [InternetShortcut] > "c:\users\public\desktop\Integrate Your Data with the FME Platform Manual.url"
		echo URL=http://fme.ly/integrate-with-fme  >>"c:\users\public\desktop\Integrate Your Data with the FME Platform Manual.url"
	
		:: echo [InternetShortcut] > "c:\users\public\desktop\CityWorks and FME Manual.url"
		:: echo URL=https://tinyurl.com/fmecw2020  >>"c:\users\public\desktop\CityWorks and FME Manual.url"
		
		:: echo [InternetShortcut] > "c:\users\public\desktop\CityWorks Connection.url"
		:: echo URL=https://tinyurl.com/cityworks-ip  >>"c:\users\public\desktop\CityWorks Connection.url"
	
		:: echo [InternetShortcut] > "c:\users\public\desktop\Introduction to FME Desktop.url"
		:: echo URL=https://s3.amazonaws.com/gitbook/Desktop-Intro-2020/index.html  >>"c:\users\public\desktop\Introduction to FME Desktop.url"
		
		echo [InternetShortcut] > "c:\users\public\desktop\FME Training Course Resources.url"
		echo URL=https://knowledge.safe.com/articles/55282/fme-training-course-resources.html  >>"c:\users\public\desktop\FME Training Course Resources.url"
		
		:: echo [InternetShortcut] > "c:\users\public\desktop\Getting Started with FME Desktop.url"
		:: echo URL=https://community.safe.com/s/article/getting-started-with-fme-desktop-translate-data-be  >>"c:\users\public\desktop\Getting Started with FME Desktop.url"
		
		echo [InternetShortcut] > "c:\users\public\desktop\My IP Address.url"
		echo URL=https://www.google.com/search?q=my+ip+address  >>"c:\users\public\desktop\My IP Address.url"
		
		echo [InternetShortcut] > "c:\users\public\desktop\FME Server Authoring Manual.url"
		echo URL=https://s3.amazonaws.com/gitbook/Server-Authoring-2020/index.html  >>"c:\users\public\desktop\FME Server Authoring Manual.url"
goto :eof


:fmedatadownload
	::download and install the current FMEData from www.safe.com/download
	aria2c https://raw.githubusercontent.com/rjcragg/AWS/master/FMEInstalls/FMEDataDownloadInstall.bat --out=FMEDataDownloadInstall.bat --allow-overwrite=true
	CALL FMEDataDownloadInstall.bat
goto :eof

:esri
	call :prvc>course.prvc
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

:: get any extra Chocolatey apps
::	choco install postman -y
::	choco install openoffice -y

::Update Firewall
::netsh firewall add portopening TCP 8888 "Extra Tomcat webservice port"

