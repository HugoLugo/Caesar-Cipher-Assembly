section .data
    message db "Welcome to Caesar Cipher!", 10
    message_len equ $ - message

section .text
    global _start

_start:
    ; Print welcome message
    mov rax, 1
    mov rdi, 1
    mov rsi, message
    mov rdx, message_len
    syscall

    ; Exit the program
    mov rax, 60
    xor rdi, rdi
    syscall
