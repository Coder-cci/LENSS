@echo off

set _LINK.BLKDROP=%DOSDRV%\GAMES\BLKDROP\BLKDROP.EXE
if exist %_LINK.BLKDROP% goto StartProgram
set _LINK.BLKDROP=%FDRAMDRV%\GAMES\BLKDROP\BLKDROP.EXE
if exist %_LINK.BLKDROP% goto StartProgram
set _LINK.BLKDROP=%CDROM%\GAMES\BLKDROP\BLKDROP.EXE
if exist %_LINK.BLKDROP% goto StartProgram

echo Could not locate BLKDROP
goto Done

:StartProgram
%_LINK.BLKDROP% %1 %2 %3 %4 %5 %6 %7 %8 %9

:Done
set _LINK.BLKDROP=