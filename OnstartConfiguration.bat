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

:: set EC2PASSWORD=pwd
:: setx /m EC2PASSWORD %EC2PASSWORD%
:: net user Administrator %EC2PASSWORD%

:: call :LaunchConfig > C:\ProgramData\Amazon\EC2-Windows\Launch\Config\LaunchConfig.json
:: call :ec2launch-config > %LOG%
call :vnc >> %LOG%
call :urls >>%LOG%
call :autoshutdown >>%LOG%
call :fmedatadownload >>%LOG%


:: Indicate the end of the log file.
	echo "Onstart Configuration complete" >>%LOG%
	exit /b


:vnc
    taskkill /f /t /fi "USERNAME eq SYSTEM" /im winvnc.exe
    net stop "uvnc_service"
    echo "C:\Program Files\uvnc bvba\UltraVNC\setpasswd.exe" safevnc safevnc2 > "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\vncpassword.bat"
    echo start "" "C:\Program Files\uvnc bvba\UltraVnc\winvnc.exe" >> "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\vncpassword.bat"
goto :eof


:urls
	::Adding URLs to the desktop is the preferred way of giving students their manuals. Ensures that everyone is using the same manuals
	:: Add the URLs to c:\users\public\desktop. That way everyone gets it.
	:: FME Desktop Course Resources
		echo [InternetShortcut] > "c:\users\public\desktop\FME Training Course Resources.url"
		echo URL=https://knowledge.safe.com/articles/55282/fme-training-course-resources.html  >>"c:\users\public\desktop\FME Training Course Resources.url"
goto :eof

:autoshutdown
	::schedule automatic shutdown.
	:: This one sets the shutdown for a specific day and time.
	schtasks /Create /F /RU SYSTEM /TN "AutoShutdown" /SC DAILY /st 16:30 /TR "C:\Windows\System32\shutdown.exe /s"

	:: This one sets the shutdown for 14 days after startup.
	::schtasks /Create /F /RU SYSTEM /TN "AutoShutdown" /SC WEEKLY /MO 2 /TR "C:\Windows\System32\shutdown.exe /s"


goto :eof

:fmedatadownload
	::download and install the current FMEData from www.safe.com/download
	aria2c https://raw.githubusercontent.com/rjcragg/AWS/master/FMEInstalls/FMEDataDownloadInstall.bat --out=FMEDataDownloadInstall.bat --allow-overwrite=true
	CALL FMEDataDownloadInstall.bat
goto :eof



::Junk section

:: fix esri license issue
::	del c:\ProgramData\FLEXnet\*.* /Q /F /A:H
::	del c:\ProgramData\FLEXnet\*.* /Q /F

:: get any extra Chocolatey apps
::	choco install postman -y
::	choco install openoffice -y

::Update Firewall
::netsh firewall add portopening TCP 8888 "Extra Tomcat webservice port"


:: Your Computer DNS Name
::	echo [InternetShortcut] > "c:\users\public\desktop\Your Computer DNS Name.url"
::	echo URL=http://169.254.169.254/latest/meta-data/public-hostname >>"c:\users\public\desktop\Your Computer DNS Name.url"

:: Configure the TaskBar
::	call :taskbarPinning >taskbarPinning.ps1
::	powershell -NoProfile -executionpolicy bypass -File taskbarPinning.ps1

:: Everything below here is deprecated stuff that might still be useful in the future.
:taskbarPinning
@echo off
echo $sa = new-object -c shell.application
echo $pn = $sa.namespace('c:\program files\fme').parsename('fmeworkbench.exe')
echo $pn.invokeverb('taskbarpin')

echo $sa = new-object -c shell.application
echo $pn = $sa.namespace('c:\program files\fme').parsename('fmedatainspector.exe')
echo $pn.invokeverb('taskbarpin')

::echo $sa = new-object -c shell.application
::echo $pn = $sa.namespace('c:\windows\system32').parsename('ServerManager.exe')
::echo $pn.invokeverb('taskbarunpin')

::echo $sa = new-object -c shell.application
::echo $pn = $sa.namespace('C:\Windows\System32\WindowsPowerShell\v1.0').parsename('powershell.exe')
::echo $pn.invokeverb('taskbarunpin')

@echo on
@goto :eof

:fmeserverhoops
:: FME Server sometimes doesn't like to start properly. Halt it and try again here
	taskkill /f /t /fi "USERNAME eq SYSTEM" /im postgres.exe
	net stop "FME Server Engines"
	net stop "FME Server Core" /y
	net stop FMEServerAppServer
	net stop "FME Server Database"

	net start FMEServerAppServer
	net start "FME Server Database"
	net start "FME Server Core"
	net start "FME Server Engines"
goto :eof
