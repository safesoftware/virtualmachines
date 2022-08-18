   set TEMP=c:\temp
   set LOG=%TEMP%\OnstartConfiguration.log
   :: ESRIDATE is MM/DD/YYYY. Terrible I know, but that's how it is. Enter course date here
   set ESRIDATE=08/23/2021
   set ESRINUM=ESU250963400
   md %TEMP%
   pushd %TEMP%

:: Call the different sections and log them
   if %date:~4%==%ESRIDATE% call :esri >>%LOG%
   call :emptyRecycleBin >>%LOG%
   call :urls >>%LOG%
   call :fmeserverhoops >>%LOG%
   call :fmedatadownload >>%LOG%


:emptyRecycleBin
	del /s /q %systemdrive%\$Recycle.bin
goto :eof

:: Indicate the end of the log file.
   echo "Onstart Configuration complete" >>%LOG%
   exit /b
   
   
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
