; memory.asm - Operacoes de manipulacao de memoria

section .data
    POOL_SIZE equ 4096
    err_nomem db "ERRO: sem memoria disponivel", 0xA, 0

section .bss
    mem_pool   resb POOL_SIZE
    mem_offset resd 1

section .text

; mem_init: inicializa o pool de memoria
mem_init:
    mov dword [mem_offset], 0
    ret

; mem_alloc: aloca N bytes do pool
; EAX = numero de bytes
; Retorna: EAX = ponteiro, ou 0 se falhou
mem_alloc:
    push ebx
    mov ebx, [mem_offset]
    mov ecx, ebx
    add ecx, eax
    cmp ecx, POOL_SIZE
    jg .falhou
    add [mem_offset], eax
    lea eax, [mem_pool + ebx]
    pop ebx
    ret
.falhou:
    push eax
    mov eax, err_nomem
    call print_str
    pop eax
    xor eax, eax
    pop ebx
    ret

; mem_copy: copia N bytes de origem para destino
; ESI = origem, EDI = destino, ECX = bytes
mem_copy:
    push eax
    push ecx
    push esi
    push edi
.loop:
    test ecx, ecx
    jz .fim
    mov al, [esi]
    mov [edi], al
    inc esi
    inc edi
    dec ecx
    jmp .loop
.fim:
    pop edi
    pop esi
    pop ecx
    pop eax
    ret

; mem_set: preenche N bytes com valor
; EDI = destino, AL = valor, ECX = bytes
mem_set:
    push ecx
    push edi
.loop:
    test ecx, ecx
    jz .fim
    mov [edi], al
    inc edi
    dec ecx
    jmp .loop
.fim:
    pop edi
    pop ecx
    ret

; mem_cmp: compara N bytes entre dois blocos
; ESI = bloco1, EDI = bloco2, ECX = bytes
; Retorna: EAX = 0 se iguais, != 0 se diferentes
mem_cmp:
    push ecx
    push esi
    push edi
.loop:
    test ecx, ecx
    jz .iguais
    mov al, [esi]
    mov bl, [edi]
    cmp al, bl
    jne .diferentes
    inc esi
    inc edi
    dec ecx
    jmp .loop
.iguais:
    xor eax, eax
    jmp .fim
.diferentes:
    movsx eax, al
    movsx ebx, bl
    sub eax, ebx
.fim:
    pop edi
    pop esi
    pop ecx
    ret

; mem_free_all: libera todo o pool
mem_free_all:
    mov dword [mem_offset], 0
    ret
