; convert.asm - Conversao entre bases numericas

section .bss
    hex_buf resb 16
    bin_buf resb 36

section .data
    hex_chars db "0123456789ABCDEF"
    prefix_hex db "0x", 0
    prefix_bin db "0b", 0

section .text

; int_to_hex: converte inteiro para string hexadecimal
; EAX = valor
; EDI = buffer de destino (minimo 11 bytes)
; Retorna: EDI aponta para inicio da string
int_to_hex:
    push eax
    push ebx
    push ecx
    push edx

    mov ecx, 8
    add edi, 2
    mov byte [edi - 2], '0'
    mov byte [edi - 1], 'x'
    add edi, ecx

    mov byte [edi], 0
    dec edi

.loop:
    mov edx, eax
    and edx, 0xF
    mov bl, [hex_chars + edx]
    mov [edi], bl
    shr eax, 4
    dec edi
    loop .loop

    pop edx
    pop ecx
    pop ebx
    pop eax
    ret

; int_to_bin: converte inteiro para string binaria
; EAX = valor
; EDI = buffer de destino (minimo 35 bytes)
int_to_bin:
    push eax
    push ecx

    mov byte [edi], '0'
    mov byte [edi+1], 'b'
    add edi, 2

    mov ecx, 32
    add edi, ecx
    mov byte [edi], 0
    dec edi

.loop:
    mov edx, eax
    and edx, 1
    add dl, '0'
    mov [edi], dl
    shr eax, 1
    dec edi
    loop .loop

    pop ecx
    pop eax
    ret

; hex_to_int: converte string hex para inteiro
; ESI = ponteiro para string (sem prefixo 0x)
; Retorna: EAX = valor inteiro
hex_to_int:
    push ebx
    push ecx
    xor eax, eax

.loop:
    movzx ecx, byte [esi]
    test cl, cl
    jz .fim

    cmp cl, '0'
    jl .fim
    cmp cl, '9'
    jle .digito
    cmp cl, 'A'
    jl .fim
    cmp cl, 'F'
    jle .letra_mai
    cmp cl, 'a'
    jl .fim
    cmp cl, 'f'
    jg .fim

    sub cl, 'a'
    add cl, 10
    jmp .acumula

.letra_mai:
    sub cl, 'A'
    add cl, 10
    jmp .acumula

.digito:
    sub cl, '0'

.acumula:
    shl eax, 4
    or al, cl
    inc esi
    jmp .loop

.fim:
    pop ecx
    pop ebx
    ret
