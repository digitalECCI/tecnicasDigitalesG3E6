# Lab02 - Sumador de 4 bits

# Integrantes

## Integrantes

* [Daniel Alejandro Arevalo Castiblanco](https://github.com/danielarev10)

* [Andres Bustos](https://github.com/andresfebustosva-coder)

* [Nicolas Santiago Ayala Rivera](https://github.com/nicolassaayalari-web)

# Informe

Indice:

1. [Documentación](#documentación-de-los-circuitos-implementados-implementado)

2. [Simulaciones](#simulaciones)

3. [Evidencias de implementación](#evidencias-de-implementación)

4. [Conclusiones](#conclusiones)

5. [Referencias](#referencias)

---

## 1. Documentación del diseño implementado

En esta práctica de laboratorio se desarrolló un sumador de 4 bits utilizando como base un módulo sumador completo de 1 bit previamente elaborado.

El propósito principal de la actividad fue aprender a reutilizar módulos mediante la creación de instancias en Verilog, permitiendo construir un circuito de mayor capacidad a partir de un bloque más pequeño.

El sumador de 4 bits permite realizar operaciones entre dos números binarios de cuatro bits. Para su construcción se utilizaron cuatro sumadores de 1 bit conectados de manera consecutiva, de forma que el acarreo generado por una etapa pueda ser utilizado por la siguiente.

El circuito cuenta con dos entradas principales de cuatro bits, A y B, además de una entrada de acarreo inicial denominada `Cin`.

Las salidas del diseño son `Sum[3:0]`, que corresponde al resultado de la operación, y `Cout`, que representa el acarreo final generado por el circuito.

Durante la práctica también se trabajó en la automatización de las pruebas mediante ciclos `for`. Esto permitió comprobar diferentes combinaciones de entrada sin necesidad de escribir manualmente cada caso de prueba.

Para el desarrollo de la actividad se utilizaron herramientas de programación y simulación como Verilog y Visual Studio Code, además de las herramientas empleadas para la verificación del diseño digital.

### 1.1 Sumador de 4 bits

El sumador de 4 bits se construyó mediante cuatro instancias del módulo sumador de 1 bit.

Cada instancia procesa una posición determinada de los números binarios A y B y produce un bit correspondiente de la salida `Sum`.

El circuito se encuentra organizado desde el bit menos significativo hasta el bit más significativo.

La primera instancia trabaja con `A[0]` y `B[0]`. Su salida de acarreo se conecta a la siguiente instancia mediante la señal `C0`.

La segunda instancia utiliza `C0` como acarreo de entrada y genera `C1`.

Posteriormente, la tercera instancia recibe `C1` y genera `C2`.

Finalmente, la cuarta instancia recibe `C2` y produce el acarreo final `Cout`.

La cadena de acarreo puede representarse de la siguiente manera:

```text
Cin → C0 → C1 → C2 → Cout
```

De esta manera, los cuatro módulos de 1 bit trabajan conjuntamente para realizar la operación correspondiente a un sumador de 4 bits.

![Diagrama de bloques del sumador de 4 bits](/dsdf.png)

*Figura 1. Diagrama de bloques del sumador de 4 bits.*

### 1.2 Instanciación de los módulos

Una de las principales características de la práctica fue la reutilización del módulo `sumador_1bit`.

La instanciación permite utilizar un módulo previamente creado dentro de otro módulo de mayor tamaño. Esto facilita el desarrollo de sistemas digitales más complejos, ya que no es necesario volver a escribir toda la lógica correspondiente al módulo original.

Para el sumador de 4 bits se utilizaron cuatro instancias independientes:

- `bit0`
- `bit1`
- `bit2`
- `bit3`

Cada instancia se conecta a los bits correspondientes de las entradas A y B y a la señal de acarreo que corresponde a su posición.

La estructura utilizada permite que el resultado de una etapa sea utilizado por la siguiente mediante las señales de acarreo.

![Código del sumador de 4 bits](/SUMA.jpeg)

*Figura 2. Código Verilog utilizado para implementar el sumador de 4 bits mediante instancias.*

### 1.3 Funcionamiento de los acarreos

Los acarreos son necesarios para transportar la información generada durante la suma de una posición binaria hacia la siguiente.

El funcionamiento de las señales de acarreo dentro del circuito es el siguiente:

- `Cin`: corresponde al acarreo inicial que ingresa al primer sumador.
- `C0`: es el acarreo generado por el primer sumador.
- `C1`: corresponde al acarreo producido por el segundo sumador.
- `C2`: corresponde al acarreo generado por el tercer sumador.
- `Cout`: representa el acarreo final producido por el cuarto sumador.

Por lo tanto, el recorrido de los acarreos se realiza de forma consecutiva:

```text
Cin → Sumador 1 → C0 → Sumador 2 → C1 → Sumador 3 → C2 → Sumador 4 → Cout
```

Este método permite conectar los cuatro sumadores de 1 bit para obtener un único circuito capaz de realizar operaciones con números de cuatro bits.

### 1.4 Automatización de pruebas mediante `for`

Uno de los aspectos que se buscó desarrollar durante esta práctica fue la utilización de ciclos `for` para realizar pruebas automáticamente.

Las entradas `A` y `B` están formadas por cuatro bits. Por esta razón, cada una puede representar 16 valores diferentes, comprendidos entre 0 y 15.

Es decir:

```text
A = 0 hasta 15
B = 0 hasta 15
```

Al combinar todos los valores posibles de ambas entradas se obtiene:

```text
16 × 16 = 256 combinaciones
```

El uso de dos ciclos `for` permite recorrer automáticamente estas combinaciones.

Esto significa que no es necesario escribir manualmente las 256 pruebas en el código de simulación. En cambio, los ciclos se encargan de asignar progresivamente los valores a las entradas A y B.

Por esta razón, el `for` puede funcionar como un **generador automático de pruebas**, facilitando la verificación del circuito y reduciendo considerablemente la cantidad de código necesario para realizar las pruebas.

Además, se establece un intervalo de tiempo entre cada combinación para que el simulador pueda registrar correctamente el comportamiento de las señales.

![Código de simulación](/simulacion%204.PNG)

*Figura 3. Código utilizado para realizar automáticamente las pruebas mediante ciclos `for`.*

### 1.5 Generación del archivo de simulación

Para observar los resultados de las pruebas se generó un archivo de simulación con extensión `.vcd`.

Este archivo permite almacenar los cambios producidos en las diferentes señales durante la ejecución del testbench.

De esta manera, posteriormente es posible visualizar las formas de onda y analizar el comportamiento de las entradas y salidas del circuito.

Las señales que pueden ser observadas durante la simulación incluyen las entradas A, B y Cin, además de las salidas Sum y Cout.

El uso del archivo de simulación facilita la verificación del circuito y permite identificar posibles errores en el diseño antes de realizar una implementación física.

---

## 2. Simulaciones

Una vez realizado el diseño del sumador de 4 bits, se procedió a realizar las pruebas correspondientes mediante simulación.

El objetivo de esta etapa fue verificar que las cuatro instancias del sumador de 1 bit estuvieran conectadas correctamente y que los acarreos se transmitieran de una etapa a otra.

También se utilizó el testbench desarrollado con ciclos `for` para automatizar las diferentes pruebas del circuito.

### 2.1 Simulación del sumador de 4 bits

Durante la simulación se aplicaron diferentes valores a las entradas A y B.

Debido a que cada entrada tiene cuatro bits, existen 16 valores posibles para cada una.

Al combinar los valores de ambas entradas se obtienen:

```text
16 × 16 = 256 combinaciones
```

El uso de los ciclos `for` permitió recorrer estas combinaciones automáticamente.

Esto permitió realizar una comprobación más completa del funcionamiento del circuito, evitando tener que introducir manualmente cada uno de los valores.

![Simulación del sumador de 4 bits](/simulacion4.4.PNG)

*Figura 4. Simulación del sumador de 4 bits.*

### 2.2 Verificación de las salidas

Durante la simulación se observaron las salidas `Sum` y `Cout`.

La salida `Sum[3:0]` representa los cuatro bits correspondientes al resultado de la operación.

Por otro lado, `Cout` representa el acarreo final producido por el circuito cuando el resultado requiere un bit adicional.

También se verificó el comportamiento de los acarreos intermedios:

```text
C0
C1
C2
```

Estos permiten transportar el acarreo entre los cuatro sumadores de 1 bit.

La correcta transmisión de estas señales es necesaria para obtener el resultado esperado en el sumador de 4 bits.

### 2.3 Pruebas automáticas mediante `for`

El ciclo `for` utilizado en el testbench permitió generar automáticamente las combinaciones de las entradas.

El primer ciclo recorre los valores posibles de una de las entradas, mientras que el segundo ciclo recorre los valores de la otra entrada.

De esta manera se generan automáticamente:

```text
A = 0, 1, 2, ..., 15
B = 0, 1, 2, ..., 15
```

y en total:

```text
256 combinaciones
```

Esto permite utilizar el testbench como un generador automático de pruebas, facilitando la comprobación del circuito.

La automatización de las pruebas fue uno de los aspectos principales de aprendizaje de la práctica, ya que permite verificar una gran cantidad de casos sin tener que escribir cada combinación individualmente.

---

## 3. Evidencias de implementación

En esta sección se presentan las evidencias relacionadas con el desarrollo y comprobación del sumador de 4 bits.

Las evidencias permiten observar el código utilizado, la estructura del circuito y los resultados obtenidos durante la simulación.

### 3.1 Código del sumador de 4 bits

La siguiente imagen corresponde al código utilizado para implementar el módulo sumador de 4 bits.

En este código se realiza la instanciación de cuatro sumadores de 1 bit y se establecen las conexiones correspondientes entre los diferentes acarreos.

![Código del sumador de 4 bits](/sumador4.PNG)

*Figura 5. Código del sumador de 4 bits.*

### 3.2 Código de simulación

La siguiente evidencia corresponde al código utilizado para realizar la simulación del circuito.

En este testbench se utilizaron ciclos `for` para generar automáticamente las combinaciones de las entradas A y B.

![Código de simulación](/simulacion%204.PNG)

*Figura 6. Código del testbench utilizado para realizar las pruebas automáticas.*

### 3.3 Diagrama de bloques

El siguiente diagrama muestra la estructura utilizada para conectar los cuatro sumadores de 1 bit.

En él se pueden observar las señales de entrada, los resultados individuales y la cadena de acarreos entre las diferentes etapas.

![Diagrama de bloques del sumador](/dsdf.png)

*Figura 7. Diagrama de bloques del sumador de 4 bits.*

### 3.4 Resultado de la simulación

La siguiente imagen presenta el resultado obtenido durante la simulación del circuito.

En ella se pueden observar las diferentes señales generadas durante las pruebas realizadas mediante el testbench.

![Resultado de la simulación](/simulacion4.4.PNG)

*Figura 8. Resultado de la simulación del sumador de 4 bits.*

### 3.5 Videos de funcionamiento

A continuación se presentan los espacios destinados a los videos realizados durante la práctica, donde se muestra el funcionamiento del sumador de 4 bits.

**Video 1 - Funcionamiento del sumador de 4 bits**

https://youtube.com/shorts/hdh7RilTL9s?si=as92HUVJaLVJ658D


---

## 4. Conclusiones

El desarrollo de esta práctica permitió comprender cómo es posible construir un circuito digital de mayor capacidad utilizando módulos previamente diseñados.

Mediante la instanciación del sumador de 1 bit se construyó un sumador de 4 bits utilizando cuatro módulos conectados de forma consecutiva.

Esta metodología permitió aplicar un diseño estructural y modular en Verilog, demostrando la utilidad de reutilizar bloques funcionales dentro de un sistema digital.

También se comprendió la función de las señales de acarreo dentro del circuito. Las señales `C0`, `C1` y `C2` permiten transmitir el acarreo generado en cada posición hacia la siguiente etapa, mientras que `Cout` corresponde al acarreo final.

Otro de los principales aprendizajes fue la utilización de ciclos `for` dentro del código de simulación.

Debido a que A y B poseen cuatro bits, cada una puede tomar 16 valores diferentes. Al combinar todas las posibilidades de ambas entradas se obtienen 256 combinaciones.

Los ciclos `for` permiten generar automáticamente estas combinaciones, evitando tener que escribir manualmente cada una de las pruebas en el testbench.

Por lo tanto, el uso de ciclos permite realizar una verificación más eficiente y organizada del diseño.

Finalmente, mediante la simulación fue posible observar el comportamiento de las entradas, las salidas y los diferentes acarreos del circuito. Esto permitió comprobar la importancia de verificar un diseño digital antes de realizar su implementación física.

En conclusión, la práctica permitió fortalecer los conocimientos relacionados con la instanciación de módulos, el diseño estructural en Verilog, el manejo de acarreos y la automatización de pruebas mediante ciclos `for`.

---

## Referencias

[1] IEEE, *IEEE Standard for Verilog Hardware Description Language*, IEEE Std. 1364.

[2] Intel Corporation, *Intel Quartus Prime Software*, herramienta utilizada para el desarrollo y verificación de diseños digitales.

[3] Microsoft, *Visual Studio Code*, editor utilizado para la escritura y organización de los archivos desarrollados en Verilog.

[4] GTKWave, *GTKWave Waveform Viewer*, herramienta utilizada para visualizar las señales generadas durante la simulación.

[5] Digital ECCI, *Técnicas Digitales ECCI 2026-II*, material correspondiente al laboratorio de sumador de 4 bits.