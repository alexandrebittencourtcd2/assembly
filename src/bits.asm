; bits.asm - Operacoes de manipulacao de bits

section .text

; count_bits: conta bits setados em EAX (popcount)
; EAX = valor
; Retorna: EAX = numero de bits 1
count_bits:
    push ecx
    xor ecx, ecx
.loop:
    test eax, eax
    jz .fim
    mov edx, eax
    and edx, 1
    add ecx, edx
    shr eax, 1
    jmp .loop
.fim:
    mov eax, ecx
    pop ecx
    ret

; is_power_of_two: verifica se EAX eh potencia de 2
; EAX = valor
; Retorna: EAX = 1 se sim, 0 se nao
is_power_of_two:
    test eax, eax
    jz .nao
    mov ecx, eax
    dec ecx
    test eax, ecx
    jnz .nao
    mov eax, 1
    ret
.nao:
    xor eax, eax
    ret

; rotate_left: rotaciona bits de EAX para esquerda
; EAX = valor, ECX = quantidade
; Retorna: EAX = valor rotacionado
rotate_left:
    rol eax, cl
    ret

; rotate_right: rotaciona bits de EAX para direita
; EAX = valor, ECX = quantidade
; Retorna: EAX = valor rotacionado
rotate_right:
    ror eax, cl
    ret

; bit_reverse: inverte todos os bits de EAX
; EAX = valor
; Retorna: EAX = valor com bits invertidos
bit_reverse:
    not eax
    ret

; get_bit: retorna bit na posicao ECX de EAX
; EAX = valor, ECX = posicao (0-31)
; Retorna: EAX = 0 ou 1
get_bit:
    shr eax, cl
    and eax, 1
    ret

; set_bit: seta bit na posicao ECX de EAX
; EAX = valor, ECX = posicao
; Retorna: EAX = valor modificado
set_bit:
    push ecx
    mov edx, 1
    shl edx, cl
    or eax, edx
    pop ecx
    ret

; clear_bit: limpa bit na posicao ECX de EAX
; EAX = valor, ECX = posicao
; Retorna: EAX = valor modificado
clear_bit:
    push ecx
    mov edx, 1
    shl edx, cl
    not edx
    and eax, edx
    pop ecx
    ret
