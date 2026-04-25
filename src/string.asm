; string.asm - Manipulacao de strings

section .text

; str_len: calcula comprimento da string
; EAX = ponteiro para string (terminada em 0)
; Retorna: ECX = comprimento
str_len:
    push eax
    xor ecx, ecx
.loop:
    cmp byte [eax], 0
    je .fim
    inc eax
    inc ecx
    jmp .loop
.fim:
    pop eax
    ret

; str_copy: copia string
; ESI = origem
; EDI = destino
str_copy:
    push eax
.loop:
    mov al, [esi]
    mov [edi], al
    inc esi
    inc edi
    test al, al
    jnz .loop
    pop eax
    ret

; str_cmp: compara duas strings
; ESI = string1
; EDI = string2
; Retorna: EAX = 0 se iguais, -1 ou 1 caso contrario
str_cmp:
    push ecx
    push edx
.loop:
    mov cl, [esi]
    mov dl, [edi]
    cmp cl, dl
    jne .diferente
    test cl, cl
    jz .iguais
    inc esi
    inc edi
    jmp .loop
.iguais:
    xor eax, eax
    jmp .fim
.diferente:
    movsx eax, cl
    movsx ecx, dl
    sub eax, ecx
.fim:
    pop edx
    pop ecx
    ret

; str_reverse: inverte string in-place
; ESI = ponteiro para string
str_reverse:
    push eax
    push ebx
    push ecx
    push edx

    mov edi, esi
    call str_len
    add edi, ecx
    dec edi

.loop:
    cmp esi, edi
    jge .fim
    mov al, [esi]
    mov bl, [edi]
    mov [esi], bl
    mov [edi], al
    inc esi
    dec edi
    jmp .loop

.fim:
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
