@echo off
echo Erase the current log which turns off logging. Then turn logging on.
echo So, this text will not appear in the log.
vpause /d 30
logger clear on
vecho /bRed /fWhite Starting new log. /e /a 0x07
date /d
time /t
echo.
echo Send the entire directory to the log, view it, then continue processing
echo the directory list to return just the volume string.
echo Logging can be on or off.
logger message -- directory list --
dir /-p | logger thru view m -- end directory -- | vstr /l 1
echo Logging will remain on or off.
vecho /fRed Turn off logging now. /fGray
logger off
echo logging is turned off
echo so these lines are not logged.
logger on
vecho /fGreen logging is back on, again. /fGray
echo type "logger" to see what went into the log. :-)

