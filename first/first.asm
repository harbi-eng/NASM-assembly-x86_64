
global _start

section .bss

std_out			equ	1d
sys_write		equ	1d
sys_exit		equ	60d
exit_success		equ	0d
ascii_new_line		equ	10d
max_number_lines	equ	8d
max_length_line		equ	max_number_lines+1
printed_char		equ	'*'

buffer		resb	max_length_line

section .text

_start:
	_init:
		mov	r8,1

	print_init:
		mov	rax,sys_write
		mov	rdi,std_out
		mov	rsi,buffer
		mov	rdx,0

	line_writer:
		mov	byte[rsi+rdx], printed_char
		inc	rdx
		cmp	r8,rdx
		jne	line_writer

	line_reseter:
		mov	byte [rsi+rdx], ascii_new_line
		inc	r8
		inc	rdx
		syscall

		cmp	r8,max_number_lines
		jng	print_init

end:
	mov	rax,sys_exit
	xor	rdi,rdi
	syscall


