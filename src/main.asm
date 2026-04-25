%include "io.asm"
%include "math.asm"
%include "string.asm"

section .data
    banner      db "=== Processador de Dados x86 ===", 0xA, 0
    menu_opt1   db "[1] Ordenar vetor (bubble sort)", 0xA, 0
    menu_opt2   db "[2] Calcular fatorial", 0xA, 0
    menu_opt3   db "[3] Busca binaria", 0xA, 0
    prompt      db "Escolha: ", 0
    newline     db 0xA, 0

    vetor       dd 42, 17, 83, 5, 61, 29, 74, 3, 56, 38
    vetor_tam   equ 10

section .bss
    entrada     resb 4
    resultado   resd 1

section .text
    global _start

_start:
    mov eax, banner
    call print_str

    mov eax, menu_opt1
    call print_str
    mov eax, menu_opt2
    call print_str
    mov eax, menu_opt3
    call print_str

    mov eax, prompt
    call print_str

    call read_int
    mov [entrada], eax

    cmp eax, 1
    je .bubble_sort
    cmp eax, 2
    je .fatorial
    cmp eax, 3
    je .busca
    jmp .sair

.bubble_sort:
    mov esi, vetor
    mov ecx, vetor_tam
    call bubble_sort
    jmp .sair

.fatorial:
    mov eax, 10
    call fatorial
    mov [resultado], eax
    jmp .sair

.busca:
    mov esi, vetor
    mov ecx, vetor_tam
    mov edx, 56
    call busca_binaria
    jmp .sair

.sair:
    mov eax, 1
    xor ebx, ebx
    int 0x80
