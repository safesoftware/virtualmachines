::::ONSTART ONLY!::::
:: These are things that should always be done ONSTART, but are too big to fit into a Scheduled Task.

:: Set the VM password. That way you don't need to create a new VM just to update the password.
:: Fix the PostGres bug that breaks FME Server
:: Kill postgres.exe that is being run by SYSTEM. That is the cause of FME Server failing on first boot.
:: https://technet.microsoft.com/en-us/library/bb491009.aspx
:: Restart FME Server Database, because it doesn't start properly 1 time in 5 when first booting

:: Set all the required variables
	set TEMP=c:\temp
	set LOG=%TEMP%\OnstartConfiguration.log
md %TEMP%
pushd %TEMP%


call :main >>%LOG%
call :urls >>%LOG%
call :fmedatadownload >>%LOG%

exit /b


:main


:: get any extra Chocolatey apps
::	choco install postman -y
::	choco install openoffice -y

::Update Firewall
netsh firewall add portopening TCP 8888 "Extra Tomcat webservice port"


:: Indicate the end of the log file.
	echo "Onstart Configuration complete"
goto :eof



:urls
	::Adding URLs to the desktop is the preferred way of giving students their manuals. Ensures that everyone is using the same manuals
	:: Add the URLs to c:\users\public\desktop. That way everyone gets it.
	::Database Connections URL
		echo [InternetShortcut] > "c:\users\public\desktop\Database Connection Parameters.url"
		echo URL=http://fme.ly/database >>"c:\users\public\desktop\Database Connection Parameters.url"
	:: FME Desktop Course Resources
		echo [InternetShortcut] > "c:\users\public\desktop\FME Training Course Resources.url"
		echo URL=https://knowledge.safe.com/articles/55282/fme-training-course-resources.html  >>"c:\users\public\desktop\FME Training Course Resources.url"
goto :eof


:fmedatadownload
	::download and install the current FMEData from www.safe.com/download
	aria2c https://raw.githubusercontent.com/rjcragg/AWS/master/FMEInstalls/FMEDataDownloadInstall.bat --out=FMEDataDownloadInstall.bat --allow-overwrite=true
	CALL FMEDataDownloadInstall.bat
goto :eof


