::::ONSTART ONLY!::::
:: These are things that should always be done ONSTART
:: We call this instead of just using UserData so that we can update this while machines are running

:: Set all the required variables
   set TEMP=c:\temp
   set LOG=%TEMP%\OnstartConfiguration.log
   md %TEMP%
   pushd %TEMP%

:: Call the different sections and log them
   call :urls >>%LOG%
   call :fmedatadownload >>%LOG%


:: Indicate the end of the log file.
   echo "Onstart Configuration complete" >>%LOG%
   exit /b

:urls
	:: Adding URLs to the desktop is the preferred way of giving students their manuals. Ensures that everyone is using the same manuals
	:: Add the URLs to c:\users\public\desktop. That way everyone gets it.
	:: FME Desktop Course Resources
	
		echo [InternetShortcut] > "c:\users\public\desktop\Introduction to FME Desktop.url"
		echo URL=https://s3.amazonaws.com/gitbook/Desktop-Intro-2020/index.html  >>"c:\users\public\desktop\Introduction to FME Desktop.url"
		
		echo [InternetShortcut] > "c:\users\public\desktop\FME Training Course Resources.url"
		echo URL=https://knowledge.safe.com/articles/55282/fme-training-course-resources.html  >>"c:\users\public\desktop\FME Training Course Resources.url"
		
		echo [InternetShortcut] > "c:\users\public\desktop\Getting Started with FME Desktop.url"
		echo URL=https://knowledge.safe.com/articles/1012/  >>"c:\users\public\desktop\Getting Started with FME Desktop.url"
		
		echo [InternetShortcut] > "c:\users\public\desktop\Advanced Attribute and List Handling.url"
		echo URL=https://knowledge.safe.com/articles/116766/  >>"c:\users\public\desktop\Advanced Attribute and List Handling.url"
		
		echo [InternetShortcut] > "c:\users\public\desktop\FME Server Authoring Manual.url"
		echo URL=https://s3.amazonaws.com/gitbook/Server-Authoring-2020/index.html  >>"c:\users\public\desktop\FME Server Authoring Manual.url"
goto :eof


:fmedatadownload
	::download and install the current FMEData from www.safe.com/download
	aria2c https://raw.githubusercontent.com/rjcragg/AWS/master/FMEInstalls/FMEDataDownloadInstall.bat --out=FMEDataDownloadInstall.bat --allow-overwrite=true
	CALL FMEDataDownloadInstall.bat
goto :eof

:: get any extra Chocolatey apps
::	choco install postman -y
::	choco install openoffice -y

::Update Firewall
::netsh firewall add portopening TCP 8888 "Extra Tomcat webservice port"

