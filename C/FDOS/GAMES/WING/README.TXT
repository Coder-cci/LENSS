Project: WING (Wing Is Not Galaga)
Authors: Adam Hiatt (cthulhu@grex.org), Anil Shrestra
Date: 6/12/00
Version: 0.7
Webpage: wing.sourceforge.net


Description:

WING is a galaga knock-off, arcade game. It features high quality prerendered
graphics, dynamically generated stars in background, single player game against
computer controlled opponents, 6 levels of play, digital sound effects, digital
music streams, and a high score list.


Compiling:

The code compiles without modifications in both DOS and Linux (the two platforms
we have tested so far) and theoretically on any platform that is supported by
the Allegro library (www.tabula.co.uk). This means that in the future we might
have BeOS and Windows releases (simply recompiles actually, if you want to try
to compile these, please tell us your results). At any rate, makefiles are
included that compile the program (no make install yet) with the correct
libraries linked.


Release Notes:

v0.7 (6/12/00) - AI and levels have finally been added. The game is getting more
polished, but we aren't quite there yet. This release is noteworthy because it is
the first with a truely playable game. We will add powerups to the next release
and the game should almost be complete (we might skip an 0.9 release if we feel
we are ready). With luck we will also have new menu art by the next release.

Even though there is "streaming audio" (essentially a .wav file with a
couple changes, read the README in the sound/ directory) the audio that needs
to be streamed is in an uncompressed format (remember, just modified .wavs) and
is thus too large to post for download. This does not mean that you can't have
audio, you just have to follow the instructions given in the sound/ README.
Currently, 'WING' segfaults upon exit if you don't have a sound file to play.
This problem will be resolved in future releases.


v0.6 (5/31/00) - This is the initial release. AI is not coded in yet and will be
done shortly. There are no-known bugs in the features currenly implemented.
Interface is going to get a make over, hopefully new art for the game will be
done (we just got an artist on the team). Collision detection is in (though still
partially incomplete). Quite a bit more needs to be done.
