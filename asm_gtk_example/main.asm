bits 64
default rel



;;;;;;;;;;;;;;;;;;;;;;;;;;	inclues	      ;;;;;;;;;;;;;;;;;;;;;;;;;;;

extern gtk_application_new
extern g_signal_connect_data
extern g_object_unref
extern g_print
extern g_application_run
extern gtk_application_window_new
extern gtk_window_set_title
extern gtk_window_set_child
extern gtk_window_present

extern gtk_set_default_size
extern gtk_widget_set_halign
extern gtk_widget_set_valign
extern gtk_button_new_with_label

;;;;;;;;;;;;;;;;;;;;;;;;;;      inclues       ;;;;;;;;;;;;;;;;;;;;;;;;;;;

section .rodata

app_id:		db	"org.gtk.minimal",0
activate:	db	"activate",0
window_title:	db	"welcome",0
button_lable:	db	"welcome to nasm",0

section .bss

app_ptr		RESQ 1
window_ptr 	RESQ 1
button_ptr	RESQ 1

section .data


section .text


global main


button_action:
	push	rbp
	mov	rbp, rsp

	pop	rbp
	ret


window_activation:
	push	rbp
	mov	rbp, rsp

	call gtk_application_window_new WRT ..plt
	mov	rdi, [app_ptr]
	call gtk_window_present WRT ..plt
	pop	rbp
	ret


main:
	push rsp
	push rdi
	push rsi
	get_window_ptr:
		lea	rdi, [app_id]
		xor	rsi,rsi
		call gtk_application_new WRT ..plt
		mov	[app_ptr], rax

	gtk_signal_connect:
		mov	rdi,rax
		lea	rsi,[activate]
		lea	rdx,[window_activation]
		xor	rcx,rcx
		xor	r10,r10
		xor	r8,r8
		xor	r9,r9
		call	g_signal_connect_data WRT ..plt

		pop rdi
		pop rsi

		mov rdx,rsi
		mov rsi,rdi
		mov rdi,[app_ptr]
		call g_application_run
	gtk_end:
		mov	rdi,app_ptr
		call	g_object_unref	WRT ..plt

	end:
		xor	rax,rax
		pop	rsp
		ret
