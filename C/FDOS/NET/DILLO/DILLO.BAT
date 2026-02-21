@echo off
REM Customize these lines for your system:
REM --------------------------------------
REM set DILLO=%DOSDIR%\DILLO

:Search
vfdutil /f %0 | set /p SELF=
if "%SELF%" == "" goto Search
if exist %SELF% goto Found
if exist %SELF%.BAT goto Found
set SELF=C:\DILLO\DILLO.BAT
:Found
vfdutil /p %SELF% | set /p DILLO=
if "%DILLO%" == "" goto Found
set SELF=

set NANOSCR=800 600 565

REM -------------------------------------------
REM You shouldn't need to edit below this line.
REM -------------------------------------------

set WATTCP.CFG=%DILLO%\ETC
set ETC=%DILLO%\ETC
set STDOUT=%DILLO%\STDOUT.TXT
set HOME=%DILLO%

%DILLO%\bin\redir.exe -o %STDOUT% -eo -t -x %DILLO%\bin\dillo.exe %1 %2 %3 %4 %5 %6 %7 %8 %9
%DILLO%\bin\vcls.exe
