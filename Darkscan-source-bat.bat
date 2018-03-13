@echo off
:: echo is set off, not showing all the console output to the users.
:: Setting up the .onion link to scan, using user input. Name and url.
    
set v1=%1
set v2=%2
set v3=%3
set version=1.0
set SAVE=0
    echo.  
    echo.  DarkScan %version% - © Erik Zijlstra 2018
    echo.  Curl for the dark side of the web. Windows command line tool.
    echo.
:: Check if arguments are not empty
IF [%1] == [] GOTO HELP
IF [%1] == [/?] GOTO HELP
IF [%1] == [/v] echo.  Darkscan %version%
IF [%2] == [/v] echo.  Darkscan %version%
IF [%2] == [] GOTO HELP
IF [%3] == [/saveoutput] SET SAVE=1
IF [%3] == [/savemore] SET SAVE=2
set onionname=%1
set oniondomain=%2
GOTO TIME

:HELP
    echo.   USAGE:
    echo.   Darkscan.exe "Name of the website" "Onion domain" 
    echo.
    echo.  /?, --help           shows this help
    echo.  /v, --version        shows the version
    echo.  /saveoutput          export status header to txt file
    echo.  /savemore            export full html page to txt file
    echo.
    echo.   Example usage: Darkscan.exe DuckDuckGo https://3g2upl4pq6kufc4m.onion
    echo.
cmd /k
exit

:: Set local date and time for folder output

:TIME
for /F "tokens=2-4 delims=/ " %%i in ('date /t') do SET CurrentDate=%%k%%i%%j
cd Outputscan
mkdir %CurrentDate% > NUL 2>&1
cd..
GOTO CHECKCURL


:: Check if third party binaries are found in the Bin folder, if TOR and CURL are not found then send the user to EXITBIN.
:: If binaries are found in the Bin folder, send the user to SETUPPATH, the start of the DarkScan progress.

:CHECKCURL
if exist "%cd%\Bin\curl.exe" (
    GOTO CHECKTOR
) else (
    GOTO EXITBIN
)

:CHECKTOR
if exist "%cd%\Bin\Tor\Tor\tor.exe" (
    GOTO SETUPPATH
) else (
    GOTO EXITBIN
)

:EXITBIN
echo.  
echo.  DarkScan can't be launched! There seems to be an error with missing binaries.
echo.  DarkScan needs third party binaries TOR and CURL to function (both should come bundled with the DarkScan application).
echo.  Please try to re-download the DarkScan application from the official download source.
echo.  
echo.  Github: https://github.com/thatsailorman
echo.  
cmd /k
exit


:: Adding a temp link to path for quick access to third party binaries used by DarkScan APP (not having to include the full path each time we make a call).
:: Our custom TORRC file uses an alternative SOCKS port so it won't interfene with other running TOR processes such as TOR browser.


:SETUPPATH
SET darkscandir="%cd%"
SET tordir="%cd%\Bin\Tor\Tor"
SET curldir="%cd%\Bin"
GOTO STARTTOR


:: We need to start TOR before we can use CURL to scan hidden dark web .onion domains.

:STARTTOR
cd "%tordir%"
start "" "tor.exe" -f torrc
echo.  
echo.  Connecting to the TOR network...
echo.  
timeout /t 5 /nobreak >NUL 2>&1
GOTO CURL


:: If TOR is launched with success, we can now use CURL to see if hidden onion TOR services are online or offline.
:: We use CURL to check if the Onion domain can be accessed with the Tor socks proxy port set in the Torrc file.

:CURL
cd %darkscandir%
@"%curldir%\curl.exe" --socks5-hostname 127.0.0.1:11109 %oniondomain% --dump-header "%cd%\Outputscan\%CurrentDate%\%onionname%.txt" >NUL 2>&1
timeout /t 3 /nobreak >NUL 2>&1
if %SAVE%==2 (
@"%curldir%\curl.exe" --socks5-hostname 127.0.0.1:11109 %oniondomain% >"%cd%\Outputscan\%CurrentDate%\%onionname%_more.txt"
timeout /t 3 /nobreak >NUL 2>&1
)
@findstr /m "200" "%cd%\Outputscan\%CurrentDate%\%onionname%.txt"
if %errorlevel%==0 (
echo %onionname% ^(%oniondomain%^) is online >"%darkscandir%\Scanresults\scanresults-%onionname%.txt"
echo.  
echo.  DarkScan results:
echo.  %onionname% ^(%oniondomain%^) is online - HTTP 200 status
echo.
) else (
echo %onionname% ^(%oniondomain%^) is offline >"%darkscandir%\Scanresults\scanresults-%onionname%.txt"
echo.  
echo.  DarkScan results:
echo.  %onionname% ^(%oniondomain%^) is offline.
echo.  
)
GOTO KILLTOR


:: We need to stop the TOR service from running before we exit DarkScan.
:: And we need to cleanup all temp txt files by deleting them.

:KILLTOR
@Taskkill /IM tor.exe /f >NUL 2>&1
if %SAVE%==0 (
del "%cd%\Outputscan\%CurrentDate%\%onionname%.txt"
)
cmd /k
exit


