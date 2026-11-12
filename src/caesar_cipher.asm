
section .data
    ; Messages displayed in the terminal
    welcome db "Welcome to Caesar Cipher!", 10
    welcome_len equ $ - welcome

    prompt db "Enter a message: "
    prompt_len equ $ - prompt

    result db "Encrypted message: "
    result_len equ $ - result

section .bss
    ; Reserve memory for user input
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

    ; Ask the user for a message
    mov rax, 1
    mov rdi, 1
    mov rsi, prompt
    mov rdx, prompt_len
    syscall

    ; Read user input
    mov rax, 0
    mov rdi, 0
    mov rsi, buffer
    mov rdx, 256
    syscall

    ; Save number of bytes read
    mov r12, rax

    ; Check whether read failed or returned no data
    cmp r12, 0
    jle exit_program

    ; Set up encryption loop
    mov rcx, 0

encrypt_loop:
    ; Stop after processing all input bytes
    cmp rcx, r12
    jge encryption_done

    ; Load current character into AL
    mov al, [buffer + rcx]

    ; Check for uppercase letters (A-Z)
    cmp al, 'A'
    jl check_lowercase

    cmp al, 'Z'
    jg check_lowercase

    ; Encrypt uppercase letter
    add al, 3
    cmp al, 'Z'
    jle save_character
    sub al, 26
    jmp save_character

check_lowercase:
    ; Check for lowercase letters (a-z)
    cmp al, 'a'
    jl next_character

    cmp al, 'z'
    jg next_character

    ; Encrypt lowercase letter
    add al, 3
    cmp al, 'z'
    jle save_character
    sub al, 26

save_character:
    ; Store encrypted character in buffer
    mov [buffer + rcx], al

next_character:
    ; Move to the next character
    inc rcx
    jmp encrypt_loop

encryption_done:
    ; Display result label
    mov rax, 1
    mov rdi, 1
    mov rsi, result
    mov rdx, result_len
    syscall

    ; Display encrypted message
    mov rax, 1
    mov rdi, 1
    mov rsi, buffer
    mov rdx, r12
    syscall

exit_program:
    ; Exit successfully
    mov rax, 60
    xor rdi, rdi
    syscall
