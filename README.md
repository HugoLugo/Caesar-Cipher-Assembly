# Caesar Cipher in x86-64 Assembly

A command-line application that implements the Caesar Cipher encryption algorithm using x86-64 Assembly language.

Developed as a final project for the Programming Paradigms course at the University of Pécs, Hungary.

## Overview

The Caesar Cipher is a classical substitution cipher that encrypts text by shifting each letter a fixed number of positions in the alphabet.

This project demonstrates how encryption and decryption can be implemented using low-level programming concepts, including registers, memory addressing, loops, conditional jumps, and Linux system calls.

## Features

- Encrypt and decrypt text.
- Select a custom shift value between 0 and 25.
- Preserve uppercase and lowercase letters.
- Preserve spaces, numbers, and punctuation.
- Handle alphabet wrap-around (e.g., Z becomes C with a shift of 3).
- Validate menu selections and shift values.
- Process text directly in memory using a buffer.

## Technologies

- Language: x86-64 Assembly
- Assembler: NASM
- Operating environment: Linux (WSL on Windows)
- Editor: Visual Studio Code
- Version control: Git and GitHub

## Project Structure

```text
Caesar-Cipher-Assembly/
├── README.md
├── .gitignore
├── src/
│   └── caesar_cipher.asm
└── docs/
    └── documentation.pdf
```

## Requirements

To compile and execute the program, you need:

- A Linux x86-64 environment (or WSL on Windows)
- NASM assembler
- GNU linker (ld)

On Ubuntu, install the required tools:

```bash
sudo apt update
sudo apt install nasm binutils
```

## Compilation and Execution

From the project's root directory, execute:

```bash
nasm -f elf64 src/caesar_cipher.asm -o caesar_cipher.o
ld caesar_cipher.o -o caesar_cipher
./caesar_cipher
```

## Usage Example

### Encryption

```text
Welcome to Caesar Cipher!

Select an operation:
1 - Encrypt
2 - Decrypt
Choice: 1
Enter shift (0-25): 3
Enter a message: Hello World!
Result: Khoor Zruog!
```

### Decryption

```text
Welcome to Caesar Cipher!

Select an operation:
1 - Encrypt
2 - Decrypt
Choice: 2
Enter shift (0-25): 3
Enter a message: Khoor Zruog!
Result: Hello World!
```

## How It Works

The Caesar Cipher shifts each alphabetical character by a selected number of positions.

Encryption:

E(x) = (x + k) mod 26

Decryption:

D(x) = (x - k + 26) mod 26

Where:
- x represents a letter's position (0-25).
- k represents the selected shift value.

The Assembly implementation uses character comparisons and conditional jumps to handle alphabet wrap-around.

The program uses a 256-byte input buffer and processes each character individually.

## Limitations

- Only ASCII letters A-Z and a-z are encrypted.
- Accented and other non-ASCII characters are preserved.
- Input is limited by fixed-size buffers.
- The program is designed for Linux x86-64 environments.
- The Caesar Cipher is a historical educational cipher and is not suitable for securing sensitive data.

## Academic Context

**Course:** Programming Paradigms  
**Institution:** University of Pécs  
**Project type:** Final assignment  

This project was developed to practice Assembly programming and demonstrate fundamental low-level programming concepts.
