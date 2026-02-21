@echo off
echo Send the entire directory to the log, view it, then continue processing
echo the directory list to return just the volume string.
echo Logging can be on or off.
logger message -- directory list --
dir /-p | logger thru view m -- end directory -- | vstr /l 1
echo Logging will remain on or off.


