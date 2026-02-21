
                          UHDD DOS Device Driver
          ===========================================================

1. Description
   -----------

   UHDD is an improved disk-only caching driver. It works like UIDE and
   handles up to 10 BIOS disks of all sizes, including A: or B: diskettes,
   on up to four UltraDMA controllers. Because SATA controllers support
   two drives per controller, only the first 8 SATA sockets will be used
   by UHDD on a SATA-only PC. This limitation does not affect UDVD2. When
   loaded after UHDD, the UDVD2 driver (see Section 4) will call UHDD to
   cache CD/DVD data. With cachesof any size, UHDD uses Read-Ahead for its
   UltraDMA disks; and with an /O switch, disk UltraDMA and cache tasks
   will overlap. Using both gives UHDD up to 20% more caching speed than
   UIDE. UHDD's cache is in XMS memory and can hold up to 4 Gigabytes of
   data. Its /B switch also sets a basic UltraDMA disk driver (no cache)
   requiring 128K of XMS as a buffer for I-O not suited to UltraDMA. The
   basic UHDD is far smaller than UIDE's basic driver and can handle tests
   or other non-cached work. UIDE should ONLY be used by people who still
   do not have enough disk space for using UHDD and UDVD2 together on
   their boot disk (in spite of UHDD now being so small!) or if no XMS is
   available: UIDE has fewer features, but it can work without XMS without
   caching, with very limited performance (see /N3 option).

   The small CC.COM "Clear Cache" program can help verify files written by
   UIDE/UHDD. Entering CC at a command prompt makes the caching driver
   "flush" its cache. Disk data (NOT data still in cache!) can then be
   compared v.s. the original output. Note that some CompactFlash cards
   cause CC to execute very slowly.


2. NO Warranties
   -------------

   UHDD is offered at no cost, "as is", "use at your own risk", and with
   NO warranties, not even an implied warranty of FITNESS for any
   particular purpose nor of MERCHANTABILITY!


3. Switch Options
   --------------

   UHDD usually needs only a /H switch to load in the HMA, a /S switch to
   set a cache size, and a /O switch to enable DMA/Caching Overlap (best,
   for most systems!). A summary of all UHDD switches is as follows:

      /A     Requests "alternate" addressing for "legacy" IDE controllers,
             01E8h/0168h for the first one, 01F0h/0170h for the second.
             /A is rarely needed. Without /A, the first "legacy"
             controller will use 01F0h/0170h and a second uses 01E8h/0168h
             as is usual for PC mainboards.

      /B     Requests a "basic" UltraDMA disk driver (no cache) requiring
             128K of XMS as a buffer for I-O unsuited to UltraDMA.

      /E     Makes the driver call the BIOS for any hard disk I-O request.
             /E avoids setup trouble on some DOS emulators (VirtualBox,
             etc.) that do not emulate all PC hardware logic! /E also
             allows using hard disks on 1994 or older PCs which have no
             UltraDMA or no PCI/EDD BIOS. If /B is given, /E is ignored.
             UHDD automatically uses the BIOS if no UDMA is available, so
             the /E option is only useful because it saves some RAM to
             keep the whole UDMA engine unloaded if you know beforehand
             that your system will not be able to use UDMA, but it is not
             necessary to use /E and lose a lot of speed just out of
             caution.

             ***** NOTE *****

             Using /E on protected-mode systems (JEMM386 etc.) may LOSE
             much speed, as a newer BIOS may omit "Virtual DMA" support
             and force disks to run in PIO mode! If /E is required, a DOS
             system should run in real-mode (UMBPCI, etc.) whenever
             possible.

      /H     Puts most of the driver in "free HMA" space. To use /H, the
             driver must load from FDAUTO.BAT (not FDCONFIG.SYS), since
             FreeDOS provides no "free HMA" until FDAUTO is run.

      /O     Overlaps disk UltraDMA with caching tasks, for faster speed.
             Although preferred, /O may NOT work on old/odd/"cheap" PC
             mainboards unable to do UltraDMA and access XMS memory at
             the same time! Systems should be tested, using /O. If disk
             errors occur, but CD/DVD input via UDVD2 works fine, /O must
             NOT be used!

      /Q     Awaits "data request" before starting UltraDMA I-O transfers.
             /Q is rarely needed, only for old systems where the driver
             loads O.K. but seems unable to transfer data. /Q is NOT for
             use with Sabrent or other SATA-to-IDE adapters that do not
             emulate "data request"!

      /R15   "Reserves" 15-MB or 63-MB of XMS, for old DOS "game" programs
      /R63   which require XMS memory below 16- or 64-MB. The drivers must
             be able to reserve this memory, reserve their own XMS memory
             beyond that, and then "free" the 15/63-MB XMS. If not, the
             drivers display "XMS init error" and abort! /R for UDVD2 is
             ignored if it loads after UHDD, as UDVD2 will then "share"
             UHDD's XMS memory.

      /Snn   Specifies the desired cache size in megabytes of XMS memory.
             Values for /S may be any number from 5 through 4093 (four
             Gigabytes). If /S is omitted or invalid, a 20-MB cache is set.
             UHDD displays "XMS init error" and aborts, when not-enough
             XMS is free! If so, request a smaller cache.

      /Z     Moves protected-mode XMS data in 8K blocks (not 64K) for 486+
             CPUs and 4K blocks for slower 386 CPUs. With JEMM386, /Z is
             unneeded. When other EMM/VCPI/DPMI drivers are used, PCs must
             be tested to find if /Z is needed. BAD schemes, that allow
             not-enough interrupts during an XMS move, could still be in
             use!

   For all switches, a dash may replace the slash and lower case letters
   may be used if desired.


4. Example Configuration Files
   ---------------------------

   A) Small real-mode systems that need only XMS may use this FDCONFIG.SYS
      example file:

          ..
          ..
      DOS=HIGH
      DEVICE=C:\BIN\XMGR.SYS
          ..
          ..  Etc.
          ..

   B) Real-mode systems with V3.70+ UMBPCI and XMGR do not need the LOWDMA
      driver, as XMGR sets an "I-O Catcher" for UMBPCI. This scheme uses
      NO low memory, if /W is given; XMGR and other drivers go directly to
      UMBPCI "Shadow RAM" upper memory! An example FDCONFIG.SYS file is:

          ..
          ..
      DOS=HIGH,UMB
      DOSDATA=UMB
      DEVICE=C:\BIN\UMBPCI.SYS
      DEVICE=C:\BIN\XMGR.SYS /W
          ..
          ..  Etc.
          ..

   C) A protected-mode system with XMGR and JEMM386 can use XMGR's "boot",
      taking only 384 low memory bytes as its 32-entry "XMS Handles" table
      (used early by JEMM386). See Section 6 below for other notes about
      protected-mode! An example FDCONFIG.SYS file is:

          ..
          ..
      DOS=HIGH,UMB
      DOSDATA-UMB
      DEVICE=C:\BIN\XMGR.SYS /B /N32             ;32 Handle XMGR "boot"
      DEVICE=C:\BIN\JEMM386.EXE I=B000-B7FF ...
      DEVICEHIGH=C:\BIN\XMGR.SYS                 ;Loads the runtime XMGR
          ..
          .. Etc.
          ..

   When all above drivers are loaded, other needed FDCONFIG.SYS files such
   as SETVER, ANSI.SYS, etc. can then load in any desired order.

   For each of the above examples, FDAUTO.BAT can then load UHDD and UDVD2
   (or just UIDE) using the DEVLOAD program. This permits the drivers to
   use "free HMA" and save low memory. UDVD2 must load after UHDD, so it
   will find UHDD in memory and "link" to it for CD/DVD data file caching.
   The /O switch can also be used if desired; see Section 3 above for more
   details on why you may want to do this.
   Example FDAUTO command lines are:

          ..
          ..  Int 13h drivers cached thru UHDD/UIDE
          ..  load now and can load in upper memory.
          ..
      DEVlOAD /H C:\BIN\UHDD.SYS /S500 /H /O     ;Or UIDE alone
      DEVLOAD /H C:\BIN\UDVD2.SYS /D:BLURAY1 /H
      LH C:\BIN\RDISK.COM /S250                  ;Optional
          ..
          ..  Etc.
          ..


5. Revision History
   ------------------------

   30-Oct-2021   UHDD uses mostly caching logic  even for noncached work,
                 saving 650+ bytes on disk! UHDD.SYS is now less than 5K,
                 suitable even for crowded "boot diskettes" etc. All UHDD
                 features, switches and cache speeds do remain UNCHANGED!
                 [The /B noncached UHDD,  not often used,  now uses ~ 300
                 bytes of additional RAM compared to the previous version].

    8-Jun-2021   UHDD.SYS is now 5601 bytes, down 140 bytes and taking 
                 only 11 sectors (not 12) for "boot" disks or other
                 small systems.

                 UHDD runs up to 10 BIOS fixed disks using up to 4 
                 UltraDMA controllers. This saves 96 bytes of "free HMA"
                 and may help with really "loaded" PCs.

                 UHDD now permits ALL cache sizes, from 5 MB to 4093 MB
                 (4 Gigabytes), so old PCs with <= 16-MB can set 
                 5/6/7/8/9-MB caches as needed.

                 All cache sizes now do Read-Ahead and can do DMA/Caching
                 Overlap (with /O) giving improved "full speed" for the
                 small caches below 10-MB. If FreeDOS users want only a
                 5-MB cache, it is now ~ 6% faster in protected mode.
                 Those using 8- or 9-MB caches gain even MORE speed!

                 "VDS" calls (for protected-mode JEMM386/etc. moves) now
                 test the BIOS "VDS" flag at 40:7B before issuing such
                 calls. No help for protected-mode, but it totally AVOIDS
                 the calls in real-mode, for faster speed.



   14-Jul-2020   UHDD's /O switch now enables DMA/Caching Overlap! That
                 and Read-Ahead allow UHDD up to 20% faster caching speed
                 than UIDE on V6.22 MS-DOS and similar speed gains for
                 FreeDOS. See the comments about UHDD /O in Section 3,
                 above. Due to Overlap, UHDD now runs up to 20 BIOS disks
                 (was 22).



    7-Jul-2020   All 10-MB+ caches are added to help old small-memory PCs.
                 
                 For 10-MB+ caches, Read-Ahead is used for UltraDMA disks.
                 
                 Default cache size is 20-MB, if /S is omitted or invalid.
                 
                 BUG fix:  Controller-number masks are now 03Ch (not 01Ch),
                 to handle 9 controllers properly.
                 
                 BUG fix:  Init logic does not clobber disk "LBA48" flags.



   31-Mar-2019   UHDD now uses Read-Ahead for its UltraDMA disks with
                 20-MB+ caches (10% more speed than UIDE). The caching
                 UHDD now uses 2752 bytes (720 upper/DOS memory + 2032
                 HMA); the /B non-cached UHDD is unchanged. README file
                 updated.



   16-Mar-2019   README file updated. UHDD.ASM changed to note UDVD2 must
                 load AFTER the UHDD driver (not before!) to cache CD/DVD
                 data. No code changes, UHDD still dated 15-Feb-2019.



   15-Feb-2019   2576 bytes (720 upper/DOS memory, 1856 HMA) for the
                 caching driver and still 1328 bytes (576 + 752) for the
                 /B non-cached driver.

                 10-MB and all 20-MB+ cache sizes added, for old systems
                 with small memory. Default is still 80-MB if UHDD's /S
                 switch is omitted or invalid.

                 The 5-MB cache has 16K cache blocks, the 10- and 15-MB
                 caches have 32K blocks, and the 20-MB+ caches use 64K
                 blocks for faster speed.

                 Maximum cache size is still 4 Gigabytes (really 4093-MB;
                 3-MB held for UHDD's cache tables [max. 1-MB] and
                 mainboard control regs.).

                 The 5-Mar-2015 UDVD2 can still call this UHDD to cache
                 CD/DVD data files; no UDVD2 changes needed.

                 If LBACache is wanted, the non-cached UHDD /B can still
                 load first to provide disk UltraDMA.

                 The "80386 errata" commands used by Ninho on his 386/SX
                 are added.

                 SSDs and CompactFlash cards with an ATAPI flag are run
                 as UltraDMA disks, not as slower "Call the BIOS" drives
                 like in UIDE.

                 Disks over 128-GB now use only LBA48 commands, to stop
                 disk ERRORS at exactly 128-GB when an LBA28 command
                 "crosses OVER" that limit. All disks less than 128-GB
                 still use LBA28 commands.

                 NOTE: UIDE has not been so updated but can still be
                 used on older systems. For newer systems, UHDD + UDVD2
                 are preferred.



    5-Mar-2015   UHDD now handles 9 controllers, 22 BIOS disks or
                 diskettes, 4 CD/DVD drives. UHDD binary-search buffer
                 is again 512 bytes. UHDD "CD/DVD" cache deleted. Other
                 drivers unchanged (re-dated only).



   24-Nov-2014   UHDD "User" caches deleted, due to non-use.



   14-Nov-2014   UHDD now "overlaps" UltraDMA disk input AND output with as
                 many caching tasks as possible, for much improved speed!



   19-Oct-2014   UHDD "overlaps" cache work during UltraDMA disk output and
                 disk sector "gaps" at I-O end, for more speed! UHDD /M
                 switch deleted, 256-byte search buffer is now permanent.



   27-Sep-2014   New UHDD /M switch sets a 512-byte binary search buffer.



   26-Jan-2014   UHDD offers "Common" & "CD/DVD" caches.



   12-Jan-2014   "Stand alone" UHDD re-added, for use as needed.



   12-Dec-2013   UHDD deleted (low use).



   21-Nov-2013   UHDD old style "stand alone" driver re-added.



    9-Sep-2013   Possible but unlikely UHDD exit errors corrected.



    2-Sep-2013   UHDD /N1 size reduced.



   30-Apr-2013   UHDD can now run without XMS (lower speed) for tests and
                 FreeDOS "scripts".



   15-Oct-2012   UHDD again detects A: and B: diskettes from BIOS data, NOT
                 from "Int 13h" calls that FAIL with an LS-120 drive!



    2-Aug-2012   UHDD "disk only" caching driver added.


6. Error Reporting
   ---------------

   UHDD works as a "BIOS driver" and returns whichever codes are set
   for diskettes and hard-disks handled by the BIOS. For SATA and IDE
   hard-disks, UHDD can post the following error codes:

       Code 0Fh - DMA error.           CCh - Disk is FAULTED.
            20h - Controller busy.     E0h - Hard I-O error.
            AAh - Disk not ready.      FFh - XMS memory error.

   Many DOS programs display only "Disk Error" messages with NO code, thus
   disk errors may require running a diagnostic to get better information!


7. Technical Notes
   ---------------

   Protected-mode users must pretest "I=nnnn-nnnn" or "X=nnnn-nnnn" values
   for JEMM386, as its "I=TEST" or "X=TEST" options may fail on newer PCs.
   Protected-mode is unrecommended with old DOS games needing reserved XMS
   as JEMM386 takes some XMS memory first. Newer "cheap BIOS" mainboards
   now OMIT logic used only by DOS and need an UltraDMA disk driver loaded
   before JEMM386 sets V86 protected-mode! For such boards, FDCONFIG.SYS
   example C above requires drivers cached thru UHDD, then UHDD itself, to
   load only in LOW memory directly after XMGR sets up XMS for the system.
   UIDE is unrecommended in this case as it will take FAR more low memory!
   JEMM386 can then load and set V86 protected-mode, and UDVD2 (if wanted)
   can be loaded later from FDAUTO. 2015 or older PCs with a normal BIOS
   usually do not need this and can use example C as shown above. Use of
   JEMMEX or other "EMM" drivers but JEMM386 must now be avoided. Other
   "EMM" drivers got dropped long ago, some with leftover ERRORS! JEMMEX
   has caused crashes on newer PCs due to OBSOLETE XMS detection code, and
   it cannot work with UIDE/UHDD on a "cheap BIOS" board as neither driver
   can load O.K. if the other is absent! To run protected-mode on "cheap
   BIOS" boards, use FDCONFIG.SYS example C with UHDD/UDVD2 (not UIDE) and
   the changes noted herein, and be aware that JEMM386 will be REQUIRED!

   XMGR and UIDE/UHDD/UDVD2 will return normal XMS and CD/DVD error codes,
   as needed. They are listed in the "V3.0 XMS Specification" and in the
   Microsoft "MS-DOS CD-ROM Extensions 2.1" document. Both are available
   from Microsoft or from other Internet sources.

   UIDE and UHDD work as "BIOS drivers" and return whichever codes are set
   for diskettes and hard-disks handled by the BIOS. For their SATA and
   IDE hard-disks, UIDE/UHDD can post the following error codes:

       Code 0Fh - DMA error.           CCh - Disk is FAULTED.
            20h - Controller busy.     E0h - Hard I-O error.
            AAh - Disk not ready.      FFh - XMS memory error.

   Many DOS programs display only "Disk Error" messages with NO code, thus
   disk errors may require running a diagnostic to get better information!

   UIDE/UHDD handle only "Legacy" or "Native PCI" IDE controllers. RAID-
   only chipsets, port multiplier chips, or ADMA chipsets are unsupported.
   UIDE/UHDD must use "Legacy", "Compatibility", or "Native IDE" mode with
   AHCI controllers. For mainboards with no such controller settings, a
   Sabrent or similar SATA-to-IDE card can let UIDE/UHDD/UDVD2 handle SATA
   disks/CDs/DVDs from parallel-port IDE controllers (80-pin cable) at DMA
   speeds. "Add on" PCI-bus adapter cards that can be detected by normal
   PCI-bus routines may also be used for disks/CDs/DVDs.

   XMGR loads in UMBPCI upper memory that is not "provided" to the system.
   With UMBPCI, a "MEM" list may begin with a block having a 00A5h offset,
   or greater with 80 or 128 XMS "Handles". The upper memory skipped by
   this offset contains XMGR.

   The UMBPCI upper memory manager uses system "Shadow RAM" that cannot do
   DMA. A newer BIOS may use UltraDMA to load programs in upper memory.
   If this is "Shadow RAM", a HANG can occur! These two rules apply, if
   using UMBPCI with XMGR and UIDE/UHDD:

     A) V3.70+ UMBPCI must load before XMGR, so XMGR finds UMBPCI and sets
        its "I-O Catcher", to handle diskette "Shadow RAM" DMA forever and
        to do disk "Shadow RAM" UltraDMA until UIDE/UHDD can load. Older
        UMBPCI drivers, or other UMBPCI load schemes, are not recommended!

     B) When CHS I-O is done, each disk must have valid CHS parameters set
        in the BIOS. If not, the "I-O Catcher" or UIDE/UHDD let the BIOS
        handle CHS I-O. If BIOS UltraDMA is left enabled, a "Shadow RAM"
        HANG can occur!

   Old BIOS programs may not configure a mainboard controller when no user
   drives are on it! The drivers then display "BAD controller" and go on
   looking for others to use. If this message is given, users must check
   that all SATA/IDE drives are set "active" with the BIOS setup routines.
   If so, "BAD controller" means a chip is not using "Bus Master" and "I-O
   Space" modes, and a BIOS update is needed!

