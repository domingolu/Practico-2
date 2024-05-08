#include "stdio.h"

extern int float2int(float numeroFloat);

int convertirFloatAEntero(float numeroFloat) {
  int numeroEntero = float2int(numeroFloat);        // Llama a la función ASM
  return numeroEntero;
}
