%include "io.asm"
%include "math.asm"
%include "string.asm"
%include "bits.asm"
%include "convert.asm"
%include "stack.asm"
%include "memory.asm"
%include "sort.asm"

section .data
    banner      db "=== Processador de Dados x86 ===", 0xA, 0
    menu_opt1   db "[1] Ordenar vetor (bubble sort)", 0xA, 0
    menu_opt2   db "[2] Calcular fatorial", 0xA, 0
    menu_opt3   db "[3] Busca binaria", 0xA, 0
    menu_opt4   db "[4] Insertion sort", 0xA, 0
    menu_opt5   db "[5] Selection sort", 0xA, 0
    menu_opt6   db "[6] Pilha (push/pop demo)", 0xA, 0
    menu_opt7   db "[7] Contar bits setados", 0xA, 0
    menu_opt8   db "[8] Verificar potencia de 2", 0xA, 0
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
    call mem_init
    call stack_init

    mov eax, banner
    call print_str
    mov eax, menu_opt1
    call print_str
    mov eax, menu_opt2
    call print_str
    mov eax, menu_opt3
    call print_str
    mov eax, menu_opt4
    call print_str
    mov eax, menu_opt5
    call print_str
    mov eax, menu_opt6
    call print_str
    mov eax, menu_opt7
    call print_str
    mov eax, menu_opt8
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
    cmp eax, 4
    je .insertion
    cmp eax, 5
    je .selection
    cmp eax, 6
    je .pilha
    cmp eax, 7
    je .bits
    cmp eax, 8
    je .potencia
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
    call print_int
    jmp .sair

.busca:
    mov esi, vetor
    mov ecx, vetor_tam
    mov edx, 56
    call busca_binaria
    call print_int
    jmp .sair

.insertion:
    mov esi, vetor
    mov ecx, vetor_tam
    call insertion_sort
    jmp .sair

.selection:
    mov esi, vetor
    mov ecx, vetor_tam
    call selection_sort
    jmp .sair

.pilha:
    mov eax, 10
    call stack_push
    mov eax, 20
    call stack_push
    mov eax, 30
    call stack_push
    call stack_pop
    call print_int
    jmp .sair

.bits:
    mov eax, 0b10110111
    call count_bits
    call print_int
    jmp .sair

.potencia:
    mov eax, 64
    call is_power_of_two
    call print_int
    jmp .sair

.sair:
    mov eax, 1
    xor ebx, ebx
    int 0x80
