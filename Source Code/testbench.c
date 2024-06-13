#include "stdio.h"

extern int float2int(float num);

int main() {
    float num = 10.29;
    int num_int = float2int(num);
    printf("Resultado de la conversión: %f is %d\n", num, num_int);
    return 0;
}
