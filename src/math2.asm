; math2.asm - Funcoes matematicas avancadas

section .text

; gcd: maximo divisor comum (algoritmo de Euclides)
; EAX = a, EBX = b
; Retorna: EAX = mdc(a, b)
gcd:
    push ebx
    push edx
.loop:
    test ebx, ebx
    jz .fim
    xor edx, edx
    div ebx
    mov eax, ebx
    mov ebx, edx
    jmp .loop
.fim:
    pop edx
    pop ebx
    ret

; lcm: minimo multiplo comum
; EAX = a, EBX = b
; Retorna: EAX = mmc(a, b)
lcm:
    push ebx
    push edx
    mov ecx, eax
    call gcd
    mov edx, ecx
    imul edx, [esp + 4]
    xor edx, edx
    div eax
    pop edx
    pop ebx
    ret

; power: calcula base^exp
; EAX = base, ECX = expoente
; Retorna: EAX = resultado
power:
    push ecx
    push ebx
    mov ebx, eax
    mov eax, 1
    test ecx, ecx
    jz .fim
.loop:
    imul eax, ebx
    loop .loop
.fim:
    pop ebx
    pop ecx
    ret

; abs_val: valor absoluto
; EAX = valor
; Retorna: EAX = |valor|
abs_val:
    test eax, eax
    jns .fim
    neg eax
.fim:
    ret

; clamp: limita valor entre min e max
; EAX = valor, EBX = min, ECX = max
; Retorna: EAX = valor limitado
clamp:
    cmp eax, ebx
    jge .check_max
    mov eax, ebx
    ret
.check_max:
    cmp eax, ecx
    jle .fim
    mov eax, ecx
.fim:
    ret

; fibonacci: calcula n-esimo numero de Fibonacci
; EAX = n
; Retorna: EAX = fib(n)
fibonacci:
    push ebx
    push ecx
    cmp eax, 1
    jle .base
    mov ecx, eax
    xor eax, eax
    mov ebx, 1
.loop:
    mov edx, eax
    add eax, ebx
    mov ebx, edx
    dec ecx
    cmp ecx, 1
    jg .loop
    jmp .fim
.base:
    test eax, eax
    jz .fim
    mov eax, 1
.fim:
    pop ecx
    pop ebx
    ret

; is_prime: verifica se numero eh primo
; EAX = n
; Retorna: EAX = 1 se primo, 0 caso contrario
is_prime:
    push ebx
    push ecx
    push edx
    cmp eax, 2
    jl .nao_primo
    je .primo
    test al, 1
    jz .nao_primo
    mov ecx, 3
.loop:
    mov edx, eax
    mov ebx, ecx
    xor edx, edx
    div ebx
    test edx, edx
    jz .nao_primo
    imul ebx, ecx, ecx
    cmp ebx, eax
    jg .primo
    add ecx, 2
    jmp .loop
.primo:
    mov eax, 1
    jmp .fim
.nao_primo:
    xor eax, eax
.fim:
    pop edx
    pop ecx
    pop ebx
    ret
