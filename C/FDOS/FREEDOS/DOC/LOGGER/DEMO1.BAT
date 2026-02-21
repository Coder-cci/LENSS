@echo off
echo Print volume information only to log. 
echo Logging can be on or off.
logger m -- volume info --
vol | logger m -- end volume --
echo Logging will remain on or off.


