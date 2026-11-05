	.assume adl=1
	jp start
	.align 0x40
	.db "MOS",0,1
start:
	push iy

	ld hl,msg
	ld bc,[msg_end-msg]
	ld de,callback
	ld a,0x25 ; mos_api_uart0_async_send
	rst.lil 8

	@@:
	ld a,(is_done)
	or a
	jr z,@b

	ld hl,0
	pop iy
	ret

msg: .db "Hello world! This message was sent with TX interrupts!\r\n"
msg_end:

is_done: db 0

callback:
	ld a,1
	ld (is_done),a
	ret
