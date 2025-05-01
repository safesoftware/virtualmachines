:: ::ONSTART ONLY!::::
:: These are things that should always be done ONSTART
:: We call this instead of just using UserData so that we can update this while machines are running
:: This file is for things we want in AWS and Strigo

:: Set all the required variables
   set TEMP=c:\temp
   set LOG=%TEMP%\OnstartConfiguration.log
   md %TEMP%
   pushd %TEMP%

:: Indicate the Start of the log file.
   echo ==== Onstart Configuration starting at %DATE% %TIME% ==== > %LOG%

 

:: Call the different sections and log them
   call :fmeserverhoops >>%LOG%
   call :writefmelicense >>%LOG%
   call :urls >>%LOG%
   call :fmedatadownload >>%LOG%
   call :emptyRecycleBin >>%LOG%

:: Indicate the end of the log file.
   echo ==== Onstart Configuration completed at %DATE% %TIME% ==== >>%LOG%
   exit /b 0

:emptyRecycleBin
	echo ==== Emptying the Recycle Bin at %TIME% ==== 
	del /s /q %systemdrive%\$Recycle.bin
goto :eof

:urls
	:: Adding URLs to the desktop is the preferred way of giving students their manuals. Ensures that everyone is using the same manuals
	:: Add the URLs to c:\users\public\desktop. That way everyone gets it.
	:: FME Desktop Course Resources
		echo ==== Adding URLs to Desktop at %TIME% ==== 
		del /s /q c:\users\public\desktop\*.url

		echo [InternetShortcut] > "c:\users\public\desktop\FMEData File List.url"
		echo URL=https://s3.amazonaws.com/FMEData/FMEData/index.html  >>"c:\users\public\desktop\FMEData File List.url"


goto :eof

:fmeserverhoops
	:: FME Server sometimes doesn't like to start properly. Halt it and try again here
	aria2c https://s3.amazonaws.com/FMETemp/Server_January.fmelic --dir="c:\ProgramData\Safe Software\FMEFlow\licenses" --out=fme_server.fmelic --allow-overwrite=true
	
	echo ==== Starting FME Flow Service at %TIME% ==== 
	echo. | call "C:\Program Files\FMEFlow\Server\WindowsService\startFMEFlowWindowsService.bat" > "c:\temp\fmeflow_start.log" 2>>&1


goto :eof

:writefmelicense
	:: Create or overwrite the FME floating license file
	set LICENSE_FILE=C:\ProgramData\Safe Software\FME\Licenses\fme_license.dat

	:: Make sure the folder exists
	if not exist "C:\ProgramData\Safe Software\FME\Licenses" (
		md "C:\ProgramData\Safe Software\FME\Licenses"
	)

	:: Write contents to the file
	(
		echo SERVER 52.39.248.214 Any
		echo USE_SERVER
	) > "%LICENSE_FILE%"

	:: Log it
	echo ==== FME Floating License written at %TIME% ==== >> %LOG%

goto :eof


:fmedatadownload
	echo ==== Starting FMEData Download at %TIME% ==== 

	pushd %TEMP%

	aria2c https://s3.amazonaws.com/FMEData/FMEData.zip ^
  		--allow-overwrite=true ^
  		--max-connection-per-server=16 ^
  		--split=16 ^
  		--min-split-size=1M ^
  		--enable-http-pipelining=true ^
  		--summary-interval=1

	for %%f in (FMEData*.zip) do 7z x -oc:\ -aoa %%f

goto :eof

