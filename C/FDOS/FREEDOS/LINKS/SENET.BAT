@echo off

set _LINK.SENET=%DOSDRV%\GAMES\SENET\SENET.EXE
if exist %_LINK.SENET% goto StartProgram
set _LINK.SENET=%FDRAMDRV%\GAMES\SENET\SENET.EXE
if exist %_LINK.SENET% goto StartProgram
set _LINK.SENET=%CDROM%\GAMES\SENET\SENET.EXE
if exist %_LINK.SENET% goto StartProgram

echo Could not locate SENET
goto Done

:StartProgram
%_LINK.SENET% %1 %2 %3 %4 %5 %6 %7 %8 %9

:Done
set _LINK.SENET=