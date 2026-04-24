:: ::ONSTART ONLY!::::
:: These are things that should always be done ONSTART
:: We call this instead of just using UserData so that we can update this while machines are running
:: This file is for things we want in AWS and Strigo
@echo off
:: Set all the required variables
   set TEMP=c:\temp
   set LOG=%TEMP%\OnstartConfiguration.log

	if not exist "%TEMP%" (
		md "%TEMP%"
	)

   pushd %TEMP%
   attrib +s +h "%TEMP%"
echo ==== Log file writing to %LOG% ====

:: Indicate the Start of the log file.
   echo ==== Onstart Configuration starting at %DATE% %TIME% ==== > %LOG%

:: Call the different sections and log them
	echo ==== Making FME Flow Happy ====
   call :fmeserverhoops >>%LOG%
	echo ==== Making FME Form Happy ====   
  :: call :writefmelicense >>%LOG%
	echo ==== Putting Links on the Desktop ====      
   call :urls >>%LOG%
	echo ==== Getting FMEData ====   
   call :fmedatadownload >>%LOG%
	echo ==== Taking out the Trash ====      
   call :emptyRecycleBin >>%LOG%

:: Indicate the end of the log file and exit
   echo ==== Onstart Configuration completed at %DATE% %TIME% ==== >>%LOG%
   exit /b 0

:emptyRecycleBin
	echo ==== Emptying the Recycle Bin at %TIME% ==== 
	del /s /q %systemdrive%\$Recycle.bin
goto :eof

:urls
	:: Adding URLs to the desktop is the preferred way of giving students their manuals. Ensures that everyone is using the same manuals
	:: Add the URLs to c:\users\public\desktop. That way everyone gets it.
	:: FME Course Resources
		echo ==== Adding URLs to Desktop at %TIME% ==== 
		del /s /q c:\users\public\desktop\*.url

		(
			echo [InternetShortcut]
			echo URL=https://s3.amazonaws.com/FMEData/FMEData/index.html
		) > "c:\users\public\desktop\FMEData File List.url"

goto :eof

:fmeserverhoops
	:: FME Flow sometimes doesn't like to start properly. So we start it manually here.
	aria2c https://s3.amazonaws.com/FMETemp/FLOW_December.fmelic ^
		--dir="c:\ProgramData\Safe Software\FMEFlow\licenses" ^
		--out=fme_server.fmelic ^
		--allow-overwrite=true
	aria2c https://s3.amazonaws.com/FMETemp/FORM_December.fmelic ^
		--dir="c:\ProgramData\Safe Software\FME\licenses" ^
		--out=fme_form.fmelic ^
		--allow-overwrite=true
:: Grab the Connections file before Workbench starts.
	aria2c https://s3.amazonaws.com/FMEData/FMEData/Resources/FMEAccelerator/fme_userconnection.data ^
		--dir="C:\FMEData\Resources\FMEAccelerator" ^
		--out=fme_userconnection.data ^
		--allow-overwrite=true
	echo ==== Starting FME Flow Service at %TIME% ==== 
	echo. | call "C:\Program Files\FMEFlow\Server\WindowsService\startFMEFlowWindowsService.bat" > "c:\temp\fmeflow_start.log" 2>>&1	
	attrib +s +h "c:\ProgramData\Safe Software\FMEFlow\licenses"
	attrib +s +h "c:\ProgramData\Safe Software\FME\licenses"
	if not exist "c:\ProgramData\Safe Software\FMEFlow\licences" (
		md "c:\ProgramData\Safe Software\FMEFlow\licences"
	)
	if not exist "c:\ProgramData\Safe Software\FME\licences" (
		md "c:\ProgramData\Safe Software\FME\licences"
	)
	del /q "C:\Users\Administrator\InitialConfiguration.bat"
	del /q "C:\ProgramData\Safe Software\FME\Licenses\fme_license.dat"

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
  		--summary-interval=30
	
	echo ==== Completed FMEData Download at %TIME% ==== 
	echo ==== Unzip FMEData at %TIME% ==== 

	for %%f in (FMEDATA*.zip) do 7z x -oc:\ -aoa %%f


	echo ==== Unzipping FMEData Completed at %TIME% ==== 
goto :eof

