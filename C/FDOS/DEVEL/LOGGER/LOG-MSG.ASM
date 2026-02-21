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

	push		ds
	pop		es 		; ES=DS, Later on, add ASCIIZ uses ES:DI

; -----------------------------------------------------------------------------
; Flush the log buffers

	; You absolutely need to flush the log buffer before writing to the log!
	; The driver uses multiple capture methods to record text and has
	; internal buffering. If you do not perform a flush, it is very probable
	; that text will be recorded out of sequence in the log.

	; AH is still multiplex number, required for all INT 0x2d calls
	mov		al, 0x12	; flush log
	int		0x2d

; -----------------------------------------------------------------------------
; Print the command line as a message into the log


	mov		si, 0x0081	; DS:SI->Command Line Option Text
	; cld				; not needed
	mov		bh, 0x0c	; Bright Red on Black. If logging is
					; loaded using the Monochrome option,
					; then the color is simply ignored.
PrintLoop:
	lodsb				; AL=Character, Increment DI
	cmp		al, 0x20	; check if space character
	jne		.NotSpace
	cmp		si, 0x82	; if SI is not at the second character
					; in the command line, we will keep the
					; space as intended indentation.
					; Otherwise, we will ignore it as
					; simple spacing between the executable
					; name and the command line options.
	je		PrintLoop
.NotSpace:
	cmp		al, 0x0d
	jbe		.LoopDone
	mov		bl, al		; BL=Character, BH=Color
	mov		al, 0x14	; add Character to log
	int		0x2d
	jmp		PrintLoop

.LoopDone:
	mov		di, CRLF	; ES:DI->CRLF ASCIIZ String
	mov		bh, 0x07	; Gray on Black
	mov		al, 0x15	; add AsciiZ to log
	int		0x2d

; -----------------------------------------------------------------------------
; End program

	mov		ax, 0x4c00	; Terminate with exit code 0
	int		0x21

; -----------------------------------------------------------------------------

section .data

LOGGER_SIG:	db 'J.SHIDEL'	; 8 character manufacturer ID
		db 'LOGGERxx'	; 8 character product ID

NOT_FOUND:	db 'Logging driver not found.$'		; $ terminated string

CRLF:		db 0x0d, 0x0a, 0x00
