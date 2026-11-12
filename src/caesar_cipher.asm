
section .data
    ; Messages displayed in the terminal
    welcome db "Welcome to Caesar Cipher!", 10
    welcome_len equ $ - welcome

    prompt db "Enter a message: "
    prompt_len equ $ - prompt

    result db "You entered: "
    result_len equ $ - result

section .bss
    ; Reserve 256 bytes for user input
    buffer resb 256

section .text
    global _start

_start:
    ; Display welcome message
    mov rax, 1
    mov rdi, 1
    mov rsi, welcome
    mov rdx, welcome_len
    syscall

    ; Ask the user to enter a message
    mov rax, 1
    mov rdi, 1
    mov rsi, prompt
    mov rdx, prompt_len
    syscall

    ; Read the user's input
    mov rax, 0
    mov rdi, 0
    mov rsi, buffer
    mov rdx, 256
    syscall

    ; Save the number of bytes read
    mov r12, rax

    ; Display "You entered: "
    mov rax, 1
    mov rdi, 1
    mov rsi, result
    mov rdx, result_len
    syscall

    ; Display the user's message
    mov rax, 1
    mov rdi, 1
    mov rsi, buffer
    mov rdx, r12
    syscall

    ; Exit the program
    mov rax, 60
    xor rdi, rdi
    syscall
