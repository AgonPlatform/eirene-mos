	.assume adl=0
	.org 0
	jp start
	.align 0x40
	.db "MOS",0,0
start:
	ld hl,msg
	ld bc,[msg_end-msg]
	ld de,callback
	ld a,0x25 ; mos_api_uart0_async_send
	rst.lis 8

	@@:
	ld a,(is_done)
	or a
	jr z,@b

	ld hl,0
	ret.lis

msg: .db "Hello world Z80! This message was sent with TX interrupts!\r\n"
msg_end:

is_done: db 0

callback:
	ld a,1
	ld (is_done),a
	ret.lis
