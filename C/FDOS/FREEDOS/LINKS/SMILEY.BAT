@echo off

set _LINK.SMILEY=%DOSDRV%\GAMES\SMILEY\SMILEY.EXE
if exist %_LINK.SMILEY% goto StartProgram
set _LINK.SMILEY=%FDRAMDRV%\GAMES\SMILEY\SMILEY.EXE
if exist %_LINK.SMILEY% goto StartProgram
set _LINK.SMILEY=%CDROM%\GAMES\SMILEY\SMILEY.EXE
if exist %_LINK.SMILEY% goto StartProgram

echo Could not locate Smiley
goto Done

:StartProgram
%_LINK.SMILEY% %1 %2 %3 %4 %5 %6 %7 %8 %9

:Done
set _LINK.SMILEY=