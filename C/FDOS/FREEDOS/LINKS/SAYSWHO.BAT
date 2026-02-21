@echo off

set _LINK.SAYSWHO=%DOSDRV%\GAMES\SAYSWHO\SAYSWHO.EXE
if exist %_LINK.SAYSWHO% goto StartProgram
set _LINK.SAYSWHO=%FDRAMDRV%\GAMES\SAYSWHO\SAYSWHO.EXE
if exist %_LINK.SAYSWHO% goto StartProgram
set _LINK.SAYSWHO=%CDROM%\GAMES\SAYSWHO\SAYSWHO.EXE
if exist %_LINK.SAYSWHO% goto StartProgram

echo Could not locate SAYSWHO
goto Done

:StartProgram
%_LINK.SAYSWHO% %1 %2 %3 %4 %5 %6 %7 %8 %9

:Done
set _LINK.SAYSWHO=