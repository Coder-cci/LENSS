@echo off
rem run vsbhda16 without jhdpmi
jload -q qpiemu.dll
jload -q -u jhdpmi.dll
lh hdpmi16i -x2
rem set blaster=A220 I7 D1 T3
rem set blaster=A220 I7 D1 T4
set blaster=A220 I7 D1 H5 T6
vsbhda16.exe
