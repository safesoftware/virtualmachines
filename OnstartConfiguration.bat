::::ONSTART ONLY!::::
:: These are things that should always be done ONSTART
:: We call this instead of just using UserData so that we can update this while machines are running

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

:: Call the different sections and log them
   	call :emptyRecycleBin >>%LOG%
	call :urls >>%LOG%
	call :autoshutdown >>%LOG%
	call :fmeserverhoops >>%LOG%
	call :fmedatadownload >>%LOG%


:: Indicate the end of the log file.
	echo "Onstart Configuration complete" >>%LOG%
	exit /b

:emptyRecycleBin
	del /s /q %systemdrive%\$Recycle.bin
goto :eof

:urls
	::Adding URLs to the desktop is the preferred way of giving students their manuals. Ensures that everyone is using the same manuals
	:: Add the URLs to c:\users\public\desktop. That way everyone gets it.
	:: FME Desktop Course Resources
	
		del /s /q c:\users\public\desktop\*.url
		
		echo [InternetShortcut] > "c:\users\public\desktop\FMEData2022 File List.url"
		echo URL=https://s3.amazonaws.com/FMEData/FMEData2022/index.html  >>"c:\users\public\desktop\FMEData2022 File List.url"
		
goto :eof

:autoshutdown
	::schedule automatic shutdown.
	:: This one sets the shutdown for a specific day and time.
	:: schtasks /Create /F /RU SYSTEM /TN "AutoShutdown" /SC DAILY /st 17:30 /TR "C:\Windows\System32\shutdown.exe /s"
	schtasks /Create /F /RU SYSTEM /TN "AutoShutdown" /SC weekly /d FRI /st 17:30 /TR "C:\Windows\System32\shutdown.exe /s"

	:: This one sets the shutdown for 14 days after startup.
	::schtasks /Create /F /RU SYSTEM /TN "AutoShutdown" /SC WEEKLY /MO 2 /TR "C:\Windows\System32\shutdown.exe /s"
goto :eof

:fmeserverhoops
	:: FME Server sometimes doesn't like to start properly. Halt it and try again here
	CALL "C:\Program Files\FMEServer\Server\WindowsService\restartFMEServerWindowsService.bat"
	
	:: Set the network discoverability. This isn't related to FME Server, but it might as well go here.
	netsh advfirewall firewall set rule group=”network discovery” new enable=yes

goto :eof






:fmedatadownload
	::download and install the current FMEData
	aria2c https://s3.amazonaws.com/FMEData/FMEData2022.zip --allow-overwrite=true
	:: Unzip FMEData
	for %%f in (FMEDATA*.zip) do 7z x -oc:\ -aoa %%f
goto :eof





