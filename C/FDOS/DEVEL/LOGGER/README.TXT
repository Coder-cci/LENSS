Developer demo files for interacting with the Logger device driver.

LOG-CLR.ASM	- Turn off logging and clear the log.
LOG-OFF.ASM	- Simply turn off logging.
LOG-ON.ASM	- Simply turn on logging.
LOG-STAT.ASM	- Display the current status of logging (size/color/enabled).
LOG-MSG.ASM	- Send a message to the log. Using Red text if color is enabled.
LOG-RIO.ASM	- Redirect Standard I/O to the log. Using Purple text.
LOG-SHOW.ASM	- Display the Log text.

Of course, the driver needs to be loaded. However, it does not need to be
enabled (actively logging) for these demonstration programs to function.

Please see the LOG-API.TXT for more detailed information regarding the LOGGER
device driver API.

Included is a pre-compiled driver only version of LOGGER.SYS. It provides the
same options and functionality as the driver portion of the dual purpose binary
LOGGER.COM. On media where every byte of storage space matters (like boot
floppies), the SYS version can be used instead of the COM to conserve some
space. However, The SYS version does not contain the interface portion that is
provided in the COM binary and additional programs (like these examples) will
be needed to interact with the logging driver.