
section .data
    welcome db "Welcome to Caesar Cipher!", 10, 10
    welcome_len equ $ - welcome

    menu db "Select an operation:", 10
         db "1 - Encrypt", 10
         db "2 - Decrypt", 10
         db "Choice: "
    menu_len equ $ - menu

    shift_prompt db "Enter shift (0-25): "
    shift_prompt_len equ $ - shift_prompt

    message_prompt db "Enter a message: "
    message_prompt_len equ $ - message_prompt

    result db "Result: "
    result_len equ $ - result

    error_choice db "Error: Invalid operation.", 10
    error_choice_len equ $ - error_choice

    error_shift db "Error: Shift must be between 0 and 25.", 10
    error_shift_len equ $ - error_shift

section .bss
    choice resb 8
    shift_input resb 16
    buffer resb 256

section .text
    global _start

_start:
    ; Display welcome message
    mov rsi, welcome
    mov rdx, welcome_len
    call print_text

    ; Display operation menu
    mov rsi, menu
    mov rdx, menu_len
    call print_text

    ; Read operation (one digit + Enter)
    mov rax, 0
    mov rdi, 0
    mov rsi, choice
    mov rdx, 8
    syscall

    cmp rax, 2
    jne invalid_choice

    cmp byte [choice + 1], 10
    jne invalid_choice

    ; Check if choice is 1 or 2
    mov r14b, [choice]

    cmp r14b, '1'
    je read_shift

    cmp r14b, '2'
    jne invalid_choice

read_shift:
    ; Ask for shift value
    mov rsi, shift_prompt
    mov rdx, shift_prompt_len
    call print_text

    ; Read shift as text
    mov rax, 0
    mov rdi, 0
    mov rsi, shift_input
    mov rdx, 16
    syscall

    cmp rax, 0
    jle invalid_shift

    ; Store number of bytes read
    mov r9, rax

    ; Convert ASCII digits to a number
    xor r8, r8
    xor rcx, rcx

parse_shift:
    cmp rcx, r9
    jae invalid_shift

    mov al, [shift_input + rcx]

    ; Newline means end of number
    cmp al, 10
    je shift_done

    ; Validate digit (0-9)
    cmp al, '0'
    jb invalid_shift

    cmp al, '9'
    ja invalid_shift

    ; Convert ASCII character to digit
    sub al, '0'
    movzx rax, al

    ; number = number * 10 + digit
    imul r8, r8, 10
    add r8, rax

    ; Shift must not exceed 25
    cmp r8, 25
    ja invalid_shift

    inc rcx
    jmp parse_shift

shift_done:
    ; Reject an empty shift
    cmp rcx, 0
    je invalid_shift

    ; Store shift value
    mov r13, r8

    ; Ask for the message
    mov rsi, message_prompt
    mov rdx, message_prompt_len
    call print_text

    ; Read user message
    mov rax, 0
    mov rdi, 0
    mov rsi, buffer
    mov rdx, 256
    syscall

    ; Exit if no input or read error
    cmp rax, 0
    jle exit_program

    ; Save length of message
    mov r12, rax

    ; Initialize loop counter
    xor rcx, rcx

cipher_loop:
    cmp rcx, r12
    jae show_result

    mov al, [buffer + rcx]

    ; Check uppercase A-Z
    cmp al, 'A'
    jb check_lowercase

    cmp al, 'Z'
    ja check_lowercase

    ; Choose encryption or decryption
    cmp r14b, '1'
    je encrypt_upper

    ; Decrypt uppercase
    sub al, r13b
    cmp al, 'A'
    jae save_character
    add al, 26
    jmp save_character

encrypt_upper:
    add al, r13b
    cmp al, 'Z'
    jbe save_character
    sub al, 26
    jmp save_character

check_lowercase:
    ; Check lowercase a-z
    cmp al, 'a'
    jb next_character

    cmp al, 'z'
    ja next_character

    cmp r14b, '1'
    je encrypt_lower

    ; Decrypt lowercase
    sub al, r13b
    cmp al, 'a'
    jae save_character
    add al, 26
    jmp save_character

encrypt_lower:
    add al, r13b
    cmp al, 'z'
    jbe save_character
    sub al, 26

save_character:
    ; Replace original character
    mov [buffer + rcx], al

next_character:
    inc rcx
    jmp cipher_loop

show_result:
    ; Print result label
    mov rsi, result
    mov rdx, result_len
    call print_text

    ; Print modified buffer
    mov rsi, buffer
    mov rdx, r12
    call print_text

    jmp exit_program

invalid_choice:
    mov rsi, error_choice
    mov rdx, error_choice_len
    call print_text
    jmp exit_error

invalid_shift:
    mov rsi, error_shift
    mov rdx, error_shift_len
    call print_text

exit_error:
    mov rax, 60
    mov rdi, 1
    syscall

exit_program:
    mov rax, 60
    xor rdi, rdi
    syscall

; Print bytes from RSI with length RDX
print_text:
    mov rax, 1
    mov rdi, 1
    syscall
    ret
