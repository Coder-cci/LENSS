@echo off
echo Print directory to log and screen.
echo using "dir /-p" to ensure directory does not pause. 
echo Logging can be on or off.
logger m -- directory list --
dir /-p | logger thru m -- end directory --
echo Logging will remain on or off.


