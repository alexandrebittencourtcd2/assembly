; sort.asm - Algoritmos de ordenacao

section .text

; insertion_sort: ordenacao por insercao
; ESI = ponteiro para vetor
; ECX = tamanho
insertion_sort:
    push ebp
    mov ebp, esp
    push ebx
    push edi

    cmp ecx, 1
    jle .fim

    mov ebx, 1
.outer:
    cmp ebx, ecx
    jge .fim

    mov eax, [esi + ebx * 4]
    lea edi, [ebx - 1]

.inner:
    cmp edi, 0
    jl .insert
    mov edx, [esi + edi * 4]
    cmp edx, eax
    jle .insert
    mov [esi + edi * 4 + 4], edx
    dec edi
    jmp .inner

.insert:
    mov [esi + edi * 4 + 4], eax
    inc ebx
    jmp .outer

.fim:
    pop edi
    pop ebx
    pop ebp
    ret

; selection_sort: ordenacao por selecao
; ESI = ponteiro para vetor
; ECX = tamanho
selection_sort:
    push ebp
    mov ebp, esp
    push ebx
    push edi

    mov ebx, 0
.outer:
    cmp ebx, ecx
    jge .fim

    mov edi, ebx
    mov edx, ebx
    inc edx

.find_min:
    cmp edx, ecx
    jge .swap
    mov eax, [esi + edi * 4]
    mov ebp, [esi + edx * 4]
    cmp ebp, eax
    jge .no_update
    mov edi, edx
.no_update:
    inc edx
    jmp .find_min

.swap:
    cmp edi, ebx
    je .no_swap
    mov eax, [esi + ebx * 4]
    mov edx, [esi + edi * 4]
    mov [esi + ebx * 4], edx
    mov [esi + edi * 4], eax
.no_swap:
    inc ebx
    jmp .outer

.fim:
    pop edi
    pop ebx
    pop ebp
    ret

; merge_sort: ordenacao por fusao (in-place simplificado)
; ESI = ponteiro para vetor, ECX = tamanho
merge_sort:
    cmp ecx, 1
    jle .fim

    push ecx
    push esi

    shr ecx, 1
    call merge_sort

    pop esi
    pop ecx

    push ecx
    push esi

    mov eax, ecx
    shr eax, 1
    lea esi, [esi + eax * 4]
    sub ecx, eax
    call merge_sort

    pop esi
    pop ecx
    call _merge
.fim:
    ret

_merge:
    push ebp
    mov ebp, esp
    push ebx
    push edi

    mov eax, ecx
    shr eax, 1
    mov edi, eax

    mov ebx, 0
.loop:
    cmp ebx, edi
    jge .fim_merge
    cmp edi, ecx
    jge .fim_merge

    mov eax, [esi + ebx * 4]
    mov edx, [esi + edi * 4]
    cmp eax, edx
    jle .ok

    push ecx
    mov ecx, edi
    sub ecx, ebx
    push esi
    push edi

    lea edi, [esi + ebx * 4 + 4]
    lea esi, [esi + ebx * 4]
    push edx
    call _shift_right
    pop edx
    pop edi
    pop esi
    pop ecx

    mov [esi + ebx * 4], edx
    inc edi
.ok:
    inc ebx
    jmp .loop

.fim_merge:
    pop edi
    pop ebx
    pop ebp
    ret

_shift_right:
    push eax
    push ecx
    push edi
    add edi, ecx
    add edi, ecx
.loop:
    test ecx, ecx
    jz .fim
    mov eax, [edi - 4]
    mov [edi], eax
    sub edi, 4
    dec ecx
    jmp .loop
.fim:
    pop edi
    pop ecx
    pop eax
    ret
