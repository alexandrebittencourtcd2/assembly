; io.asm - Entrada e saida

section .bss
    buf_int resb 12

section .text

; print_str: imprime string terminada em 0
; EAX = ponteiro para string
print_str:
    push eax
    push ecx
    push edx
    push ebx

    mov ecx, eax
    call _str_len_io
    mov edx, eax
    mov eax, 4
    mov ebx, 1
    int 0x80

    pop ebx
    pop edx
    pop ecx
    pop eax
    ret

_str_len_io:
    push ecx
    xor eax, eax
.loop:
    cmp byte [ecx + eax], 0
    je .fim
    inc eax
    jmp .loop
.fim:
    pop ecx
    ret

; print_int: imprime inteiro em decimal
; EAX = valor
print_int:
    push eax
    push ebx
    push ecx
    push edx
    push edi

    mov edi, buf_int + 11
    mov byte [edi], 0
    dec edi
    mov ebx, 10

    test eax, eax
    jns .convert
    neg eax

.convert:
    xor edx, edx
    div ebx
    add dl, '0'
    mov [edi], dl
    dec edi
    test eax, eax
    jnz .convert

    inc edi
    mov eax, 4
    mov ebx, 1
    mov ecx, edi
    mov edx, buf_int + 11
    sub edx, edi
    int 0x80

    pop edi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret

; read_int: le inteiro do stdin
; Retorna: EAX = valor lido
read_int:
    push ebx
    push ecx
    push edx

    mov eax, 3
    mov ebx, 0
    mov ecx, buf_int
    mov edx, 12
    int 0x80

    mov esi, buf_int
    xor eax, eax
    xor ebx, ebx

.loop:
    movzx ebx, byte [esi]
    cmp ebx, 0xA
    je .fim
    cmp ebx, 0
    je .fim
    sub ebx, '0'
    imul eax, 10
    add eax, ebx
    inc esi
    jmp .loop

.fim:
    pop edx
    pop ecx
    pop ebx
    ret
