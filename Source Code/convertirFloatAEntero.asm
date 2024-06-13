section .data
    num dd 0  ; Reserva espacio para una variable de doble palabra (32 bits) llamada 'num' e inicialízala a 0

global float2int
section .text

float2int:
    push ebp  ; Guarda el valor actual del puntero de base en la pila
    mov ebp,esp  ; Mueve el valor del puntero de pila al puntero de base

    fld dword [ebp + 8]  ; Carga el número en punto flotante que se pasa como argumento en la pila de la FPU

    fistp dword [num]  ; Convierte el número en punto flotante a un entero y lo guarda en 'num'

    mov eax, [num]  ; Mueve el valor de 'num' al registro eax
    add eax, 1  ; Suma 1 al valor en eax
    mov [num], eax  ; Mueve el valor de eax de vuelta a 'num'

    mov esp, ebp  ; Restaura el puntero de pila al valor que tenía antes de la llamada a la función
    pop ebp  ; Restaura el puntero de base al valor que tenía antes de la llamada a la función
    ret  ; Retorna al código que llamó a esta función