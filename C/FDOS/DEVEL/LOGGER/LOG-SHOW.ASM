; BSD 3-Clause License
; Copyright (c) 2023, Jerome Shidel

; Redistribution and use in source and binary forms, with or without
; modification, are permitted provided that the following conditions are met:

; 1. Redistributions of source code must retain the above copyright notice, this
;    list of conditions and the following disclaimer.

; 2. Redistributions in binary form must reproduce the above copyright notice,
;    this list of conditions and the following disclaimer in the documentation
;    and/or other materials provided with the distribution.

; 3. Neither the name of the copyright holder nor the names of its
;    contributors may be used to endorse or promote products derived from
;    this software without specific prior written permission.

; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
; AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
; IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
; DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
; FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
; DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
; SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
; CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
; OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
; OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

; NASM 2.15.05, or later

; -----------------------------------------------------------------------------

%define FOREWARD	; read the log from start to end, undefine to read
			; the log from end to start.

use16

cpu 8086

org 0x0100

section .text

; At start up, these are not required under DOS and can be assumed.
	; push 	cs
	; pop	ds	; DS = CS
	; push	cs
	; pop   es	; ES = CS
	; cld		; can be assumed

; -----------------------------------------------------------------------------
; Check if Logger device driver is loaded and set it Multiplex ID number

Driver_Locate:
	xor		bx, bx		; initialize BH/BL to zero
	; cld				; not needed
.Scanning:
	mov		ax, bx		; set AH to next multiplex number, and
					; AL=0 for install function check

	int		0x2d		; Multiplexer

	; AMIS (Interrupt 0x2d) install check function 0, will return either
	; AL=0x00 for not in use or AL=0xFF when in use. When in use, it
	; will also return, CX=Version Number and DX:DI->Signature

	cmp		al, 0xff	; if AL=0x00, multiplex is not in use
					; if AL=0xff, multiplex is in use
	jne		.Next		; other values are an invalid response

	mov		si, LOGGER_SIG	; DS:SI->Logger signature
	mov		es, dx		; ES:DI->Returned multiplex signature
	; mov		dx, cx		; Could save version in DX for later
	mov		cx, 0x0008	; 16 bytes for comparing the signatures
	repe		cmpsw		; Compare the signatures
	je		.Found		; If matched, we found the driver
.Next:
	inc		bh		; inc BH for next multiplex to check
					; when wraps back to zero, ZF is set
					; and we tested all 256 numbers
	jnz		.Scanning	; if BH != 0, check the new multiplex

	mov		dx, NOT_FOUND	; DS:DX->Not found string
	mov		ah, 0x09	; Write string to StdOut
	int		0x21
	mov		ax, 0x4c01	; Terminate with exit code 1
	int		0x21

.Found:
	; AH & BH = Logger Multiplex ID number.
	; ES = Driver Segment

; -----------------------------------------------------------------------------
; Get far call pointer to Logger function dispatch

	; AH is still multiplex number, required for all INT 0x2d calls
	mov		al, 0x01	; Get Private Entry Point
	int		0x2d
	; if AL=0 it is not supported, AL=0xff it is supported. The current
	; Logger version and all future versions will support this function.
	; So, there is no need to check AL for support.
	; DX:BX->Point to driver's far call function dispatcher

	; The dispatcher supports all functions that are not specific to AMIS.
	; That would be all functions starting at AL=0x10 or higher.
	; They can be called through AMIS or directly through the far call to
	; the dispatcher. They provide the same return values in the same
	; registers. There could be many other programs that are hooked into
	; INT 0x2d and performance could be impacted.
	mov		[LOGGER_FC], bx
	mov		[LOGGER_FC+2], dx

; -----------------------------------------------------------------------------
; Flush the log buffers and Turn off logging

	; You absolutely need to flush the log buffer before writing to the log!
	; The driver uses multiple capture methods to record text and has
	; internal buffering. If you do not perform a flush, it is very probable
	; that text will be recorded out of sequence in the log or even
	; corrupted by the read process.

	; However, calling the Set Enable function ALWAYS flushes the buffers
	; so we do not need to make a special call to the Flush Log.

	; We need to turn off logging so this programs output is not written
	; back to the log. Otherwise, the log would continue to grow as we
	; displayed it's contents. Also, the read/write buffers in the driver
	; are shared and would write corrupted data into the log.

	mov		al, 0x11	; Set Logging Enabled
	xor		bl, bl		; 0, turn off
	call far	[LOGGER_FC]	; bypass INT 0x2d multiplexer
	mov		[LOGGER_STATE], bl ; save the previous state for later

; -----------------------------------------------------------------------------
; Fetch position of first character in the log

	mov		al, 0x16	; Read Log
	%ifdef FOREWARD
		mov	bl, 0x05	; sub-function, Get first char position
					; in first whole line.
					;
					; we could use sub-function 0x03. But,
					; if the log has reached capacity and
					; is overwriting old messages, the
					; first character will probably start
					; mid-line. Unless there is a good
					; reason to display that partial line,
					; sub-fn 0x05 is preferable.
	%else
		mov	bl, 0x04	; sub-function, Get last char position
	%endif
	call far	[LOGGER_FC]	; bypass INT 0x2d multiplexer
					; DX:CX is position data
	cmp		dx, -1		; DX=0xffff (-1) if log is empty
	jne		DisplayLog
	mov		dx, LOG_EMPTY	; DS:DX->Not found string
	mov		ah, 0x09	; Write string to StdOut
	int		0x21
	jmp		RestoreState

; -----------------------------------------------------------------------------
; Display the log contents

; DO NOT manually set, increment or decrement the DX:CX position data.
; The data in the log can be bytes or words and the start and end points can
; have any value. Future versions may include additional data or methods to
; increase capacity. Let the driver handle DX:CX.

DisplayLog:
	mov		al, 0x16	; Read Log
	%ifdef FOREWARD
		mov	bl, 0x01	; sub-function, Get Character/Color and
					; update DX:CX for next position
	%else
		mov	bl, 0x02	; sub-function, Get Character/Color and
					; update DX:CX for previous position
	%endif
	call far	[LOGGER_FC]	; bypass INT 0x2d multiplexer
					; DX:CX is new position data or -1 (end)
					; BL is character
					; BH is color (if log is mono, BH=0x07)
	push		dx		; save high word of position data
	mov		ah, 0x02
	mov		dl, bl		; set character for DOS StdOut
	int		0x21
	pop		dx		; restore high word of position data
	cmp		dx, -1		; Are we at the end?
	jne		DisplayLog	; if not repeat the process

; -----------------------------------------------------------------------------
; If logging was enabled, turn it back on.

RestoreState:
	mov		al, 0x11	   ; Set Enabled
	mov		bl, [LOGGER_STATE] ; Restore previous enabled state
	call far	[LOGGER_FC]	   ; bypass INT 0x2d multiplexer

; -----------------------------------------------------------------------------
; End program

	mov		ax, 0x4c00	; Terminate with exit code 0
	int		0x21

; -----------------------------------------------------------------------------

section .data

LOGGER_SIG:	db 'J.SHIDEL'	; 8 character manufacturer ID
		db 'LOGGERxx'	; 8 character product ID

NOT_FOUND:	db 'Logging driver not found.$'		; $ terminated string

LOG_EMPTY:	db 'Log is empty.$'

CRLF:		dw 0x0d,0x0a,'$'

; -----------------------------------------------------------------------------

section .bss

LOGGER_FC:	resd 1		; Far call to driver dispatch function
LOGGER_STATE:	resb 1		; Original Logger enabled/disabled state
