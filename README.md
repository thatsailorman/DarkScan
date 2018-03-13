# DarkScan
Command line tool (Windows) to _ping_ dark web domains using Curl. With this simple tool you can quickly & easily check if an *.onion (hidden tor service) domain is online or not.

![Preview](https://github.com/thatsailorman/DarkScan/blob/master/DarkscanGIF.gif)

Since we can't simply ping a TOR hidden service domain the normal way (like we would with any regular http website), we first need to connect to the TOR network, configure the TCP proxy port and then use CURL (instead of the ping command) to check if the website is up or not.
And that's exactly what this command line tool does (out of the box). :+1:


## DarkScan usage:
Darkscan.exe _TitleOfWebsite_ _OnionDomain_

Example:
_**Darkscan.exe DuckDuckGo https://3g2upl4pq6kufc4m.onion**_

DarkScan will then output the http status for the given *.onion domain.

Output example:

_**DuckDuckGo (https://3g2upl4pq6kufc4m.onion) is online - HTPP 200 status**_



## Downloads


### Compiled executable
Simply looking to use DarkScan right away?

**You can download DarkScan v1.0 here: https://github.com/thatsailorman/DarkScan/blob/master/DarkScan-package.exe**

DarkScan comes with TOR and CURL bundled in the package. The TOR config file (TORRC) has been set to use an alternative socks port so it won't interfere with your other running TOR services.
DarkScan works without any configuration. Simply start Darkscan.exe and you're ready to go!

_Hint: DarkScan is portable! You can put it on an USB stick and use it on any Windows PC right away._

### Build your own exe?

STEP 1:
Download the binary version: https://github.com/thatsailorman/DarkScan/blob/master/DarkScan-package.exe (which bundles the needed third party tools TOR and CURL) and extract all files on your Windows PC.
You can delete the Darkscan.exe file from the extracted folder, because we're going to replace that with our own custom build version.

STEP 2:
Download the BAT file from this GITHUB page and place it inside your DarkScan folder. Link to bat file: https://github.com/thatsailorman/DarkScan/blob/master/Darkscan-source-bat.bat

STEP 3:
Open the BAT file with any text editing tool such as the standard Windows software: Notepad. Make your custom changes, and save the BAT file.

STEP 4:
Use any free BAT converter/compiler for Windows to convert your .BAT file to .EXE. 
A freeware BAT to EXE software tool, I recommend (and used): http://www.f2ko.de/en/b2e.php

## TODO
- Add support to curl a full list of onion domains at once. (Read a text file with a long list of onion domains line by line, and export the output).
- Build an UI versio.


### License
_**MIT**_. In other words: Do whatever you want with it. :wink:
