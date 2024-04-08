# Práctico #2 - Calculadora de índices GINI
### Materia:  Sistemas de Control 2024 FCEFyN-UNC
### Grupo: CBD
#### Integrantes
    GONZALEZ, BRUNO				    43134492	I.Electrónica	
    GARCÍA, ANGEL DOMINGO			32797989	I.Comp.				https://github.com/domingolu/Practico-2
## Table of Contents
- [Introducción](#introducción)
- [Implementación](#implementación)
- [Results](#results)
- [Future Work](#future-work)

<a name="introducción"></a>
## Introducción
Se pretente implementar una interfaz que muestre el índice GINI. La capa superior recuperará la información del banco mundial https://api.worldbank.org/v2/en/country/all/indicator/SI.POV.GINI?format=json&date=2011:2020&per_page=32500&page=1&country=%22Argentina%22. Se utiliza API Rest y Python. Los datos de consulta son entregados a un programa en C (capa intermedia) que convierte valores de float a enteros y devuelve el índice de un país como Argentina y otro. Luego el programa python muestra los datos obtenidos.

<a name="implementación"></a>
## Implementación
 1. Creamos la librería en C que utilizaremos para convertir de float a int:
- creamos el fichero convertirFloatAEntero.c. En una primera instancia utilizamos Google Colab (acá explica cómo usar C en Google Colab https://www.youtube.com/watch?v=zuKeHPZWMYE)
```python
#Creamos librería C
%%writefile convertirFloatAEntero.c
int convertirFloatAEntero(float numeroFloat) {
  int numeroEntero = (int)numeroFloat; // Convertir el número float a un entero
  return numeroEntero;
}
```
-	parámetros:
	-	recibe un valor float
	-	devuelve el número entero equivalente
```python
#compilamos
!gcc -c -fPIC convertirFloatAEntero.c -o convertirFloatAEntero.o
!gcc -shared -W -o libconvertirFloatAEntero.so ./convertirFloatAEntero.o
```
- Compilamos el fichero en C con gcc que es el compilador de C de GNU 
	- -c le dice a gcc que solo compile el archivo fuente y no lo enlace. 
	- -fPIC le dice a gcc que genere código posicion-independiente, lo que es necesario para crear bibliotecas compartidas.
- Creamos la biblioteca compartida libconvertirFloatAEntero.so a partir del archivo objeto convertirFloatAEntero.o: 
	- *-shared*: indica a gcc que debe generar una biblioteca compartida en lugar de un ejecutable. 
	- *-W*: opción de compilación que habilita advertencias 
	- *-o* especifica el nombre del archivo de salida 
	- *convertirFloatAEntero.o*: Es el archivo objeto que se está compilando y enlazando en la biblioteca compartida.

2. Creamos un wrapper con ctypes para poder usar la librería de C con Python y poder llamar sus funciones:
```python
# Importamos la librería ctypes
import ctypes
# Cargamos la libreria
libconvertirFloatAEntero = ctypes.CDLL('./libconvertirFloatAEntero.so')
# Definimos los tipos de los argumentos de la función factorial
libconvertirFloatAEntero.convertirFloatAEntero.argtypes = (ctypes.c_float,)
# Definimos el tipo del retorno de la función factorial
libconvertirFloatAEntero.convertirFloatAEntero.restype = ctypes.c_int
# Creamos nuestra función en Python
# hace de Wrapper para llamar a la función de C
def  convertirFloatAEntero(num):
return libconvertirFloatAEntero.convertirFloatAEntero(num)
```

3. Se consultan los datos del índice GINI de Argentina en la siguiente api rest https://api.worldbank.org/v2/en/country/all/indicator/SI.POV.GINI? Se usa la requests library para mandar una GET request a la API y obtener el JSON response. Todo esto lo realizamos definiendo la función:

```python
def  obtener_indice_gini(pais)
```
- definición:
	- recibe como parámetro el String del país del cual se necesitan los datos
	- devuelve una lista de diccionarios con el año y su correspondiente valore GINI para el país solicitado
4.  En la estructura main del programa se llama dos veces a la función *obtener_indice_gini (pais)* para obtener los indices GINI de dos países.
- primero se grafican los datos tal cual se obtienen
- luego se utiliza la función de convención de llamada a C *convertirFloatAEntero (num)* para convertir todos los índices GINI de float a int. 
- Se grafica nuevamente para, finalmente, comparar los resultados

<a name="Results"></a>
## Results

![](graps.png)
![Ejemplo de gráfico para los países Argentina y Bolivia](graphs_int.png)

<a name="future-work"></a>
## Future Work
- Se podrían agregar más países
- Se podría realizar una interfaz gráfica para seleccionar los países
- Se podría optimizar el código
- Se puede utilizar convención de llamadas para realizar tareas en Ensamblador