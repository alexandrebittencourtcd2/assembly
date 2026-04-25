; stack.asm - Implementacao de pilha (LIFO) em memoria

section .data
    STACK_MAX equ 64
    err_overflow  db "ERRO: stack overflow", 0xA, 0
    err_underflow db "ERRO: stack underflow", 0xA, 0

section .bss
    stack_data resd STACK_MAX
    stack_top  resd 1

section .text

; stack_init: inicializa a pilha
stack_init:
    mov dword [stack_top], 0
    ret

; stack_push: empilha valor
; EAX = valor a empilhar
; Retorna: CF=1 se overflow
stack_push:
    push ebx
    mov ebx, [stack_top]
    cmp ebx, STACK_MAX
    jge .overflow
    mov [stack_data + ebx * 4], eax
    inc dword [stack_top]
    clc
    pop ebx
    ret
.overflow:
    push eax
    mov eax, err_overflow
    call print_str
    pop eax
    stc
    pop ebx
    ret

; stack_pop: desempilha valor
; Retorna: EAX = valor, CF=1 se underflow
stack_pop:
    push ebx
    mov ebx, [stack_top]
    test ebx, ebx
    jz .underflow
    dec ebx
    mov eax, [stack_data + ebx * 4]
    mov [stack_top], ebx
    clc
    pop ebx
    ret
.underflow:
    push eax
    mov eax, err_underflow
    call print_str
    pop eax
    stc
    pop ebx
    ret

; stack_peek: retorna topo sem remover
; Retorna: EAX = valor, CF=1 se vazia
stack_peek:
    push ebx
    mov ebx, [stack_top]
    test ebx, ebx
    jz .vazia
    dec ebx
    mov eax, [stack_data + ebx * 4]
    clc
    pop ebx
    ret
.vazia:
    stc
    pop ebx
    ret

; stack_size: retorna tamanho atual
; Retorna: EAX = numero de elementos
stack_size:
    mov eax, [stack_top]
    ret

; stack_clear: esvazia a pilha
stack_clear:
    mov dword [stack_top], 0
    ret
