bits 64
default rel



;;;;;;;;;;;;;;;;;;;;;;;;;;	inclueds	      ;;;;;;;;;;;;;;;;;;;;;;;;;;;

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
;;;;;;;;;;;;;;;;;;;;;;;;;;      includes       ;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;         data        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
section .rodata

app_id:			db	"org.gtk.minimal",0
activate:		db	"activate",0
window_title:		db	"welcome",0
button_action_id:	db	"clicked",0
button_lable:		db	10,"WELCOM TO NASM!!!!",10,0

section .bss

app_ptr		RESQ 1
window_ptr 	RESQ 1
button_ptr	RESQ 1

section .data

GTK_ALIGN_CENTER	equ	3
;;;;;;;;;;;;;;;;;;;;;;;;;	 data 	     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;

section .text


global main

; =============================================================================
;	                     BUTTON_ACTION FUNCTION
; =============================================================================
button_action:

	button_action_stack_setup:
        	push    rbp
                mov     rbp, rsp
                sub     rsp, 16
                mov     [rsp + 0], rdi
                mov     [rsp + 8], rsi

	button_print:
		lea	rdi, [button_lable]
		call g_print WRT ..plt

	button_action_return:
		mov	rsp, rbp
		pop	rbp
		ret

; =============================================================================
;	                   WINDOW_ACTIVATION FUNCTION
; =============================================================================
window_activation:

	window_activation_stack_setup:
		push	rbp
		mov	rbp, rsp
		sub	rsp, 16
		mov	[rsp + 0], rdi
		mov	[rsp + 8], rsi

	create_new_window:
		call gtk_application_window_new WRT ..plt
		mov	[window_ptr], rax

	set_window_title:
		mov	rdi, rax
		lea	rsi, [window_title]
		call 	gtk_window_set_title WRT ..plt

	creat_new_button:
		lea	rdi, [button_lable]
		call	gtk_button_new_with_label WRT ..plt
		mov	[button_ptr], rax

	align_button_location:
		mov	rdi, rax
		mov	rsi, GTK_ALIGN_CENTER
		call	gtk_widget_set_valign WRT ..plt
		mov	rdi, [button_ptr]
		mov	rsi, GTK_ALIGN_CENTER
		call	gtk_widget_set_halign WRT ..plt

	connect_action_to_button:
                mov     rdi,[button_ptr]
                lea     rsi,[button_action_id]
                lea     rdx,[button_action]
                xor     rcx,rcx
                xor     r8,r8
                xor     r9,r9
                call    g_signal_connect_data WRT ..plt

	connect_button_to_window:
		mov	rdi, [window_ptr]
		mov	rsi, [button_ptr]
		call	gtk_window_set_child

	gtk_present:
		mov	rdi, [window_ptr]
		call gtk_window_present WRT ..plt

	window_activation_return:
		mov	rsp, rbp
		pop	rbp
		ret

; =============================================================================
; 				   MAIN FUNCTION
; =============================================================================
main:

	main_stack_setup:
		push rbp
		mov rbp, rsp

	get_window_pointer:
		lea	rdi, [app_id]
		xor	rsi,rsi
		call	gtk_application_new WRT ..plt
		mov	[app_ptr], rax

	gtk_signal_connect:
		mov	rdi,rax
		lea	rsi,[activate]
		lea	rdx,[window_activation]
		xor	rcx,rcx
		xor	r8,r8
		xor	r9,r9
		call	g_signal_connect_data WRT ..plt

	gtk_run_window:
		xor rdx,rdx
		xor rsi,rsi
		mov rdi,[app_ptr]
		call g_application_run WRT ..plt

	handle_close_window:
		mov	rdi,[app_ptr]
		call	g_object_unref	WRT ..plt

	main_return:
		xor	rax,rax
		mov	rsp, rbp
		pop	rbp
		ret
