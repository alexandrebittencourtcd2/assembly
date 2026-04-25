; queue.asm - Fila circular (FIFO)

section .data
    QUEUE_MAX    equ 32
    err_q_full   db "ERRO: fila cheia", 0xA, 0
    err_q_empty  db "ERRO: fila vazia", 0xA, 0

section .bss
    queue_data  resd QUEUE_MAX
    queue_head  resd 1
    queue_tail  resd 1
    queue_count resd 1

section .text

; queue_init: inicializa a fila
queue_init:
    mov dword [queue_head],  0
    mov dword [queue_tail],  0
    mov dword [queue_count], 0
    ret

; queue_enqueue: insere elemento na fila
; EAX = valor
; Retorna: CF=1 se cheia
queue_enqueue:
    push ebx
    mov ebx, [queue_count]
    cmp ebx, QUEUE_MAX
    jge .cheia

    mov ebx, [queue_tail]
    mov [queue_data + ebx * 4], eax
    inc ebx
    cmp ebx, QUEUE_MAX
    jl .ok_tail
    xor ebx, ebx
.ok_tail:
    mov [queue_tail], ebx
    inc dword [queue_count]
    clc
    pop ebx
    ret
.cheia:
    push eax
    mov eax, err_q_full
    call print_str
    pop eax
    stc
    pop ebx
    ret

; queue_dequeue: remove e retorna elemento da fila
; Retorna: EAX = valor, CF=1 se vazia
queue_dequeue:
    push ebx
    mov ebx, [queue_count]
    test ebx, ebx
    jz .vazia

    mov ebx, [queue_head]
    mov eax, [queue_data + ebx * 4]
    inc ebx
    cmp ebx, QUEUE_MAX
    jl .ok_head
    xor ebx, ebx
.ok_head:
    mov [queue_head], ebx
    dec dword [queue_count]
    clc
    pop ebx
    ret
.vazia:
    push eax
    mov eax, err_q_empty
    call print_str
    pop eax
    stc
    pop ebx
    ret

; queue_peek: retorna frente sem remover
; Retorna: EAX = valor, CF=1 se vazia
queue_peek:
    push ebx
    mov ebx, [queue_count]
    test ebx, ebx
    jz .vazia
    mov ebx, [queue_head]
    mov eax, [queue_data + ebx * 4]
    clc
    pop ebx
    ret
.vazia:
    stc
    pop ebx
    ret

; queue_size: retorna numero de elementos
; Retorna: EAX = contagem
queue_size:
    mov eax, [queue_count]
    ret

; queue_clear: esvazia a fila
queue_clear:
    mov dword [queue_head],  0
    mov dword [queue_tail],  0
    mov dword [queue_count], 0
    ret
