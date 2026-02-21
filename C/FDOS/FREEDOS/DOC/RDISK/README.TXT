
                          RDISK DOS Device Driver
          ===========================================================

1. Description
   -----------

   RDISK is a RAM-disk driver.   It creates a "fast" disk drive from up to
   2-GB of XMS memory.   Programs or data can be copied by AUTOEXEC to the
   RAM-disk and accessed at memory speeds.   RDISK works with V2.0 or V3.0
   XMS managers (60-MB maximum for V2.0).   It is a simple RAM-disk driver
   without resizing or other options.


2. NO Warranties
   -------------

   RDISK is offered at no cost, "as is", "use at your own risk", and with
   NO warranties, not even an implied warranty of FITNESS for any
   particular purpose nor of MERCHANTABILITY!


3. Switch Options
   --------------

   RDISK uses only /S size and /: drive-letter switches:

      /Sn    Specifies a desired RAM-disk size in megabytes of XMS memory.
                Values are any number from 2 to 2047.   When /S is omitted
                or invalid, a 25-MB RAM-disk is set by default.

      /:L    Specifies the DOS drive letter desired to access RDISK files.
                L may be any available drive letter from A to Z, e.g.  /:N
                assigns drive N: to all RDISK files.   If the drive letter
                is too high or already in use, RDISK will abort, and users
                may need "LASTDRIVE=" in CONFIG.SYS to set up more drives.
                If RDISK is loaded by CONFIG.SYS, or if /: is omitted, the
                next free drive letter will be used.

   For all switches, a dash may replace the slash and lower case letters
   may be used if desired.


4. Setup and Configuration
   -----------------------

   XMGR, UIDE, UHDD, and UDVD2 all load thru the CONFIG.SYS file.    RDISK
   loads via either the CONFIG.SYS or the AUTOEXEC.BAT file.   Your CONFIG
   or AUTOEXEC should contain command lines similar to these examples:

      DEVICE=C:\DOSDVRS\XMGR.SYS /N128 /B

      DEVICEHIGH=C:\DRIVERS\RDISK.COM /S200

      DEVICEHIGH=C:\SYSTEM\UIDE.SYS /D:TOSHIBA1 /S500 /H

      DEVICEHIGH=C:\USERDVRS\UHDD.SYS /S250 /H

      DEVICEHIGH=C:\MYDVRS\UDVD2.SYS /D:BLURAY1 /H

   Note that "Int 13h" BIOS drivers must be loaded first, so UIDE/UHDD can
   intercept and cache their I-O requests.   Note also that if UDVD2 is to
   share UHDD's XMS buffer and/or call it for CD/DVD data caching, it must
   load after UHDD, so UDVD2 can locate UHDD in memory and "link" with it.
   See the CONFIG.SYS examples below.

   With V3.70+ UMBPCI and XMGR, a "boot" procedure is not needed!   UMBPCI
   loads first to enable upper-memory, then XMGR loads to offer it and XMS
   to DOS, then other drivers may load.    For V6.22/V7.10 MS-DOS, JEMM386
   can also be loaded, to offer extra upper-memory in the "video graphics"
   areas, or if other JEMM386 features are desired.

   NOTE:  FreeDOS and some other DOS variants will not "add up" the memory
   found by both UMBPCI and JEMM386, like MS-DOS does!   FreeDOS users who
   desire more upper-memory or other protected-mode items must omit UMBPCI
   and load HIMEMX/JEMM386 per their instructions, or load XMGR/JEMM386 as
   shown in the third example below.

   An example CONFIG.SYS file using V3.70+ UMBPCI and XMGR is as follows:

          ..
          ..
      DOS=HIGH,UMB
      DOSDATA=UMB                               ;When available
      DEVICE=C:\BIN\UMBPCI.SYS
      DEVICE=C:\BIN\XMGR.SYS /W
      DEVICE=C:\BIN\JEMM386.EXE I=B000-B7FF X=C800-EFFF NOEMS   ;Optional
          ..
          ..  Int 13h drivers cached by UIDE/UHDD load now.
          ..
      DEVICEHIGH=C:\BIN\UHDD.SYS /S250 /H       ;Or UIDE alone.  Load via
      DEVICEHIGH=C?\BIN\UDVD2.SYS /H            ;  FDAUTO with FreeDOS
      DEVICEHIGH=C:\BIN\RDISK.COM /S125         ;Optional
          ..
          ..  Etc.
          ..

   XMGR can be used "stand alone" on a small XMS-only system.   It must be
   the first DOS system driver to load, and it must load in LOW memory, as
   in the following example:

          ..
          ..
      DOS=HIGH
      SHELL=C:\DOS\COMMAND.COM C:\DOS /E:512 /P
      DEVICE=C:\BIN\XMGR.SYS
          ..
          ..  Int 13h drivers cached by UIDE/UHDD load now.
          ..
      DEVICE=C:\BIN\UHDD.SYS /S80               ;Or UIDE alone.  Load via
      DEVICE=C:\BIN\UDVD2.SYS                   ;  FDAUTO with FreeDOS
      DEVICE=C:\BIN\RDISK.COM /S20              ;Optional
          ..
          ..  Etc.
          ..

   With JEMM386 and XMGR,  XMGR loads first in "boot" mode,  then JEMM386,
   then XMGR finally loads into upper-memory.   An example CONFIG.SYS file
   which uses the XMGR "boot" procedure is as follows:

          ..
          ..
      DOS=HIGH,UMB
      DOSDATA=UMB                               ;When available
      DEVICE=C:\BIN\XMGR.SYS /B                 ;Loads only XMGR's "boot"
      DEVICE=C:\DOS\JEMM386.EXE I=B000-B7FF ...
      DEVICEHIGH=C:\BIN\XMGR.SYS                ;Loads the runtime XMGR
          ..
          ..  Int 13h drivers cached by UIDE load now.
          ..
      DEVICEHIGH=C:\BIN\UHDD.SYS /S250 /H       ;Or UIDE alone.  Load via
      DEVICEHIGH=C?\BIN\UDVD2.SYS /H            ;  FDAUTO with FreeDOS
      DEVICEHIGH=C:\BIN\RDISK.COM /S500         ;Optional
          ..
          ..  Etc.
          ..

   After the above drivers are loaded, further CONFIG.SYS drivers (SETVER,
   ANSI.SYS, etc.) can then load in any desired order.

   FreeDOS users should load UIDE/UHDD/UDVD2 via FDAUTO.BAT (not FDCONFIG)
   using the DEVLOAD program, so the drivers can load in "free HMA" with a
   /H switch.   Example FDAUTO command lines are:

          ..
          ..
      DEVLOAD /H C:\BIN\UHDD.SYS /S20 /H        ;20-MB+ cache recommended
      DEVLOAD /H C:\BIN\UDVD2.SYS /H            ;Must load after UHDD
          ..
          ..  Etc.
          ..

   When a specific RDISK drive letter is required, RDISK can now be loaded
   by AUTOEXEC.BAT, and its /: switch can specify any "free" drive letter,
   e.g.  /:Q  assigns drive Q: for RDISK files.    Whenever RDISK is used,
   AUTOEXEC.BAT should also include commands to copy all RDISK programs or
   data up to the RAM-disk.   This is required each time DOS loads, as XMS
   memory is LOST when a system shuts down!    Such copies usually require
   little time.

   If RDISK and UIDE/UHDD are used, users must balance how much XMS memory
   the drivers use.   RDISK must take no more XMS than its files may need.
   UIDE/UHDD can take most remaining XMS for its caches.   Some XMS memory
   must be saved for other programs needing it!   As an example, on a 4-GB
   system, RDISK might use 500-MB, UIDE/UHDD might use 3-GB, and 500-MB is
   free for other programs.   These values can be adjusted, so RDISK holds
   programs and "fast" data files, while UIDE/UHDD cache "ordinary" files.
   Properly balanced use of XMS will give a VERY high-speed DOS system!

   Please be sure to set each hard disk's geometry correctly in your BIOS.
   Set it to "Auto", "LBA" or "LBA Assisted", but NOT to "None", "Normal",
   "CHS", "ECHS".   "User Cylinders/Heads/Sectors", "Revised ECHS" or "Bit
   Shift" should run but are NOT preferred.   If a BIOS has a setting like
   "UltraDMA" or "UDMA Capable" for a disk, enable it.

   "Laptop" power-saving items like a "drive spin-down timeout" should run
   O.K. but must be TESTED before use!   All these drivers allow 7 seconds
   for a disk or CD/DVD drive to spin-up, after being idle.   More DRASTIC
   power-saving items like a "drive SHUTDOWN timeout" (may require "extra"
   logic to restart the drive!) should be DISABLED, or driver I-O requests
   may time out!

   Also, be sure to use an 80-pin IDE cable with any UltraDMA drive set to
   "mode 3" ATA-44 (44 MB/sec) or higher.   When cabling a single drive to
   an IDE channel, note that you MUST use both "ends" of the cable, NOT an
   "end" and the middle connector!   This prevents ERRORS, since an unused
   cable-end can pick up "noise", like a RADIO antenna!

   Be sure to enable all CD/DVD drive(s) through the BIOS set-up routines!
   A drive that is "disabled" may cause the BIOS to clear all its UltraDMA
   flags and force the drive into "PIO mode" zero, which is terribly SLOW!


5. Revision History
   ------------------------

   25-Apr-11   BAD "code mods" init error corrected

   23-Jun-09   RDISK now a .COM file.    RDISK /: switch, RDISKON program
                 added.

   15-May-09   Added RDISK.


6. Technical Notes
   ---------------

   Protected-mode users must pretest "I=nnnn-nnnn" or "X=nnnn-nnnn" values
   for JEMM386, as its "I=TEST" or "X=TEST" options may fail on newer PCs.
   Protected-mode is unrecommended with old DOS games needing reserved XMS
   as JEMM386 takes some XMS memory first.   Newer "cheap BIOS" mainboards
   now OMIT logic used only for DOS and need a disk UltraDMA driver loaded
   before JEMM386 sets its protected-mode!    With such boards, CONFIG.SYS
   example C above will require Int 13h drivers cached via UHDD, then UHDD
   itself, to load only in LOW memory, after XMGR's "boot" provides XMS to
   the system.    JEMM386 can then load and set its protected-mode safely.
   2015 or older mainboards with a "regular" BIOS usually do not need this
   and can use example C as-is.   Use of JEMMEX or other "EMM" drivers but
   JEMM386 should now be avoided.   Other "EMM" drivers got abandoned long
   ago, some with leftover ERRORS!   JEMMEX cannot be used on "cheap BIOS"
   boards with these drivers and has caused crashes on newer PCs, probably
   due to an old XMS detection scheme.   If not updated, JEMMEX should now
   be viewed as "obsolete"!

   The drivers' /R15 or /R63 switch is for a real-mode system using UMBPCI
   and XMGR, to play old DOS games.   Game players prefer real-mode, as it
   gives higher speed.   If UIDE or UDVD2 are used alone, they can use the
   /R15 or /R63 switches with no problem.   If UDVD2 is loaded after UHDD,
   only UHDD can "reserve" XMS memory, and UDVD2 must not use a /R switch.
   Note that NO other programs or drivers that require XMS memory can load
   before the "game", so the reserved XMS cannot be re-allocated to anyone
   else!   Also note that if the "game" cannot be loaded and then "frozen"
   (not started immediately!), loading other programs and drivers AFTER it
   will be impossible!   Both of these issues make using JEMM386/EMM386 or
   other "EMM" drivers difficult, so an old "game" program which must have
   XMS memory below 16- or 64-MB will usually need to be run in real-mode.

   XMGR and UDVD2 post normal XMS or CD/DVD error codes, as needed.   They
   are listed in the "V3.0 XMS Specification" and in the Microsoft "MS-DOS
   CD-ROM Extensions 2.1" document, available from Microsoft or elsewhere.
   UHDD is a "BIOS driver" and returns the codes set by the BIOS for disks
   and diskettes run by it.   For its own SATA/IDE disks, UHDD posts these
   error codes as needed:

       Code 0Fh - DMA error.           CCh - Disk is FAULTED.
            20h - Controller busy.     E0h - Hard I-O error.
            AAh - Disk not ready.      FFh - XMS memory error.

   Many DOS programs display only "Disk Error" messages with NO code, thus
   disk errors may require running a diagnostic to get better information!

   UHDD handles only "Legacy" or "Native PCI" IDE controllers.   RAID-only
   chipsets, "port multiplier" chips, and ADMA chipsets are not supported.
   UHDD requires "Legacy", "Compatibility", or "Native IDE" mode with AHCI
   controllers.   For mainboards with no such controller settings, Sabrent
   or similar SATA-to-IDE cards will let UHDD or UDVD2 run SATA disks/CDs/
   DVDs from a parallel-port IDE controller (80-pin cable), at DMA speeds.
   "Add on" PCI-bus adapter cards, that can be detected via normal PCI-bus
   logic, may also be used for disks/CDs/DVDs.

   XMGR loads in UMBPCI upper memory that is not "provided" to the system.
   With UMBPCI, a "MEM" list may begin with a block having a 00A7h offset,
   or greater with 80 or 128 XMS "Handles".    The upper memory skipped by
   this offset contains XMGR.

   The UMBPCI upper memory manager uses system "Shadow RAM" that cannot do
   DMA.    A newer BIOS may use UltraDMA to load programs in upper memory.
   If this is "Shadow RAM", a HANG can occur!    These two rules apply, if
   using UMBPCI with XMGR and UHDD:

     A) V3.70+ UMBPCI must load before XMGR, so XMGR finds UMBPCI and sets
        its "I-O Catcher", to handle diskette "Shadow RAM" DMA forever and
        to handle disk "Shadow RAM" UltraDMA until UHDD is loaded.   Older
        UMBPCI drivers, or other UMBPCI load schemes, are not recommended!

     B) When CHS I-O is done (MS-DOS V6.22 or older), every disk must have
        valid CHS parameters set in the BIOS.    If not, the "I-O Catcher"
        and UHDD let the BIOS handle CHS I-O.   When BIOS UltraDMA is left
        enabled, a "Shadow RAM" HANG can occur!

   Old BIOS programs may not configure a mainboard controller when no user
   drives are on it!   The drivers then display "BAD controller" and go on
   looking for others to use.   If this message is given, users must check
   that all SATA/IDE drives are set "active" with the BIOS setup routines.
   If so, "BAD controller" means a chip is not using "Bus Master" and "I-O
   Space" modes, and a BIOS update is needed!
