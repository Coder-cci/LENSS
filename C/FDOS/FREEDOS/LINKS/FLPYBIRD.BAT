@echo off

set _LINK.FLPYBIRD=%DOSDRV%\GAMES\FLPYBIRD\FLPYBIRD.COM
if exist %_LINK.FLPYBIRD% goto StartProgram
set _LINK.FLPYBIRD=%FDRAMDRV%\GAMES\FLPYBIRD\FLPYBIRD.COM
if exist %_LINK.FLPYBIRD% goto StartProgram
set _LINK.FLPYBIRD=%CDROM%\GAMES\FLPYBIRD\FLPYBIRD.COM
if exist %_LINK.FLPYBIRD% goto StartProgram

echo Could not locate FLPYBIRD
goto Done

:StartProgram
%_LINK.FLPYBIRD% %1 %2 %3 %4 %5 %6 %7 %8 %9

:Done
set _LINK.FLPYBIRD=
