		.assume adl=1
		.org $40000
		jp start
		.align $40

		.db "MOS"
		.db 0 ; version
		.db 1 ; ADL enabled (24-bit addressing)

	.macro putch char
		ld a,char
		rst.lil 0x10
	.endmacro

start:
		push iy

		ld hl,startmsg
		ld bc,0
		xor a
		rst.lil 0x18

	@loop:
		ld a,0x62		; mos_api_pollkeyboardevent
		ld de,eventbuf
		rst.lil 8

		and a
		jr z,@loop		; no event yet...

		ld hl,msg
		ld bc,0
		xor a
		rst.lil 0x18

		ld a,(e_ascii)
		call print_hexbyte
		putch ','
		ld a,(e_kmod)
		call print_hexbyte
		putch ','
		ld a,(e_vkey)
		call print_hexbyte
		putch ','
		ld a,(e_isdown)
		call print_hexbyte
		putch '\r'
		putch '\n'

		ld a,(e_ascii)
		cp 'q'
		jr nz,@loop

		ld hl, 0
		pop iy
		ret

eventbuf:
e_ascii:	.db 0
e_kmod:		.db 0
e_vkey:		.db 0
e_isdown:	.db 0
startmsg:
		.db "Press q to quit...\r\n", 0
msg:
		.db "Key ascii,kmod,vkey,isdown: ", 0

print_hexbyte:
		push af
		srl a
		srl a
		srl a
		srl a
		; print high nibble
		call @print_hexnibble
		pop af
		and $f
		; print low nibble
	@print_hexnibble:
		add a, 48
		cp 58
		jr c, @f
		add a, 7
	@@:	rst.lil $10
		ret
