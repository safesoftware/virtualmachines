

:: Set all the required variables
   set TEMP=c:\temp
   set LOG=%TEMP%\ArcGISLicense.log
   set ESRINUM=ESU789872986
   md %TEMP%
   pushd %TEMP%

:: Call the different sections and log them
   call :esri >>%LOG%
   call :emptyRecycleBin >>%LOG%

:: Indicate the end of the log file.
   echo "ArcGIS Licensing complete" >>%LOG%
   exit /b

:emptyRecycleBin
	del /s /q %systemdrive%\$Recycle.bin
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

