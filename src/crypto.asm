; crypto.asm - Cifras simples: XOR e Caesar

section .data
    CAESAR_SHIFT equ 13

section .text

; xor_cipher: cifra/decifra buffer com chave XOR
; ESI = buffer, ECX = tamanho, AL = chave
xor_cipher:
    push ecx
    push esi
.loop:
    test ecx, ecx
    jz .fim
    xor [esi], al
    inc esi
    dec ecx
    jmp .loop
.fim:
    pop esi
    pop ecx
    ret

; caesar_encrypt: cifra ROT-N em string
; ESI = string (terminada em 0), CL = shift
caesar_encrypt:
    push eax
    push esi
.loop:
    movzx eax, byte [esi]
    test al, al
    jz .fim

    cmp al, 'A'
    jl .check_lower
    cmp al, 'Z'
    jg .check_lower
    sub al, 'A'
    add al, cl
    xor ah, ah
    mov edx, 26
    div dl
    add ah, 'A'
    mov [esi], ah
    inc esi
    jmp .loop

.check_lower:
    cmp al, 'a'
    jl .skip
    cmp al, 'z'
    jg .skip
    sub al, 'a'
    add al, cl
    xor ah, ah
    mov edx, 26
    div dl
    add ah, 'a'
    mov [esi], ah
    inc esi
    jmp .loop

.skip:
    inc esi
    jmp .loop

.fim:
    pop esi
    pop eax
    ret

; caesar_decrypt: decifra ROT-N em string
; ESI = string (terminada em 0), CL = shift
caesar_decrypt:
    push ecx
    neg cl
    add cl, 26
    call caesar_encrypt
    pop ecx
    ret

; checksum8: calcula checksum de 8 bits de um buffer
; ESI = buffer, ECX = tamanho
; Retorna: EAX = checksum
checksum8:
    push ecx
    push esi
    xor eax, eax
.loop:
    test ecx, ecx
    jz .fim
    movzx edx, byte [esi]
    add eax, edx
    inc esi
    dec ecx
    jmp .loop
.fim:
    and eax, 0xFF
    pop esi
    pop ecx
    ret

; parity_check: verifica paridade de EAX
; EAX = valor
; Retorna: EAX = 0 paridade par, 1 impar
parity_check:
    push ecx
    call count_bits
    and eax, 1
    pop ecx
    ret
