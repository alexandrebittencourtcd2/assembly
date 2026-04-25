; math.asm - Rotinas matematicas

section .text

; bubble_sort: ordena vetor de inteiros
; ESI = ponteiro para o vetor
; ECX = tamanho
bubble_sort:
    push ebp
    mov ebp, esp
    push ebx
    push edi

    dec ecx
.outer:
    push ecx
    mov edi, esi
.inner:
    mov eax, [edi]
    mov ebx, [edi + 4]
    cmp eax, ebx
    jle .no_swap
    mov [edi], ebx
    mov [edi + 4], eax
.no_swap:
    add edi, 4
    loop .inner
    pop ecx
    loop .outer

    pop edi
    pop ebx
    pop ebp
    ret

; fatorial: calcula n!
; EAX = n
; Retorna: EAX = n!
fatorial:
    push ebp
    mov ebp, esp
    push ebx

    cmp eax, 1
    jle .base
    mov ebx, eax
    dec eax
    call fatorial
    imul eax, ebx
    jmp .fim

.base:
    mov eax, 1

.fim:
    pop ebx
    pop ebp
    ret

; busca_binaria: busca valor em vetor ordenado
; ESI = ponteiro para vetor
; ECX = tamanho
; EDX = valor buscado
; Retorna: EAX = indice (-1 se nao encontrado)
busca_binaria:
    push ebp
    mov ebp, esp
    push ebx
    push edi

    xor eax, eax
    mov edi, ecx
    dec edi

.loop:
    cmp eax, edi
    jg .nao_encontrado

    mov ecx, eax
    add ecx, edi
    shr ecx, 1

    mov ebx, [esi + ecx * 4]
    cmp ebx, edx
    je .encontrado
    jl .direita

    lea edi, [ecx - 1]
    jmp .loop

.direita:
    lea eax, [ecx + 1]
    jmp .loop

.encontrado:
    mov eax, ecx
    jmp .fim

.nao_encontrado:
    mov eax, -1

.fim:
    pop edi
    pop ebx
    pop ebp
    ret
