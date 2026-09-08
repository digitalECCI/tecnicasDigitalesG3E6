# Lab01 - Introducción a la lógica combinacional

# Integrantes

## Integrantes

* [Daniel Alejandro Arevalo Castiblanco](https://github.com/danielarev10)

* [Andres Bustos](https://github.com/andresfebustosva-coder)

* [Nicolas Santiago Ayala Rivera](https://github.com/nicolassaayalari-web)

# Informe

## Índice

1. [Documentación del diseño implementado](#1-documentación-del-diseño-implementado)
2. [Simulaciones](#2-simulaciones)
3. [Evidencias de implementación](#3-evidencias-de-implementación)
4. [Conclusiones](#4-conclusiones)
5. [Referencias](#referencias)

---

# 1. Documentación del diseño implementado

Durante el desarrollo de esta práctica de laboratorio se trabajó con diferentes circuitos pertenecientes a la lógica combinacional utilizando el lenguaje de descripción de hardware Verilog.

La actividad estuvo conformada por tres partes principales. En la primera se implementaron diferentes compuertas lógicas digitales. Posteriormente, se desarrolló un circuito combinacional capaz de determinar si un número binario de tres bits corresponde a un número primo. Finalmente, se realizó el diseño de un sumador completo de un bit.

Los sistemas combinacionales se caracterizan porque sus salidas dependen únicamente de los valores que se encuentran presentes en sus entradas. Esto significa que el circuito no almacena estados anteriores, sino que genera una respuesta de acuerdo con la combinación actual de las señales de entrada [1].

El objetivo principal de la práctica fue comprender y aplicar conceptos fundamentales de la lógica digital mediante la descripción, implementación y simulación de circuitos utilizando Verilog.

---

## 1.1 Compuertas lógicas

La primera parte de la práctica consistió en desarrollar diferentes compuertas lógicas digitales mediante el lenguaje Verilog. Para cada una de ellas se realizó la descripción del hardware y posteriormente se comprobó su funcionamiento mediante simulaciones.

Las compuertas implementadas fueron:

- **NOT**
- **AND**
- **OR**
- **XOR**
- **XNOR**

Cada una de estas compuertas realiza una operación lógica específica sobre una o varias señales binarias de entrada.

Las principales características de las compuertas utilizadas son las siguientes:

- **NOT:** genera el valor lógico opuesto al de la entrada.

- **AND:** produce una salida igual a 1 únicamente cuando sus dos entradas son iguales a 1.

- **OR:** genera una salida igual a 1 cuando al menos una de sus entradas tiene un valor lógico alto.

- **XOR:** produce una salida igual a 1 cuando las entradas presentan valores diferentes.

- **XNOR:** genera una salida igual a 1 cuando las dos entradas poseen el mismo valor lógico [1], [2].

Para verificar el funcionamiento de cada una de las compuertas se tuvieron en cuenta sus respectivas tablas de verdad y se evaluaron todas las combinaciones posibles de las señales de entrada.

**Código utilizado para la implementación de las compuertas:**

![Compuertas lógicas](/COMP.jpeg)

*Figura 1. Implementación de las compuertas lógicas mediante Verilog.*

### Video de funcionamiento de las compuertas lógicas

[Ver video de la práctica de compuertas lógicas](https://youtube.com/shorts/2mP-Xwf5Yz0?si=uUStz3KMFtKHlcDq)

---

## 1.2 Verificador de números primos

La segunda parte de la práctica consistió en diseñar un circuito combinacional capaz de identificar si un número representado mediante tres bits corresponde a un número primo.

Al utilizar tres bits como entrada, es posible representar números desde `000` hasta `111`, los cuales corresponden a los valores decimales comprendidos entre 0 y 7.

Dentro de este intervalo, los números que son primos corresponden a:

- 2
- 3
- 5
- 7

Las representaciones binarias de estos números son las siguientes:

| Número decimal | Representación binaria |
|:---:|:---:|
| 2 | 010 |
| 3 | 011 |
| 5 | 101 |
| 7 | 111 |

El circuito debe activar su salida cuando la combinación presente en sus entradas corresponda a alguno de estos valores.

Por el contrario, para los números que no son primos, la salida debe permanecer desactivada.

El desarrollo de este circuito permitió aplicar conocimientos relacionados con las tablas de verdad, el álgebra booleana y las funciones combinacionales [1].

**Código utilizado para la implementación del verificador:**

![Verificador de números primos](/PRIMO.jpeg)

*Figura 2. Código Verilog del circuito verificador de números primos.*

### Video de funcionamiento del verificador de números primos

[Ver video del verificador de números primos](https://youtube.com/shorts/7eX1FzHauPU?si=RQwMiMPHG3TSZi5n)

---

## 1.3 Sumador completo de 1 bit

La tercera parte de la práctica correspondió al diseño de un sumador completo de un bit, también conocido como *Full Adder*.

Este circuito permite realizar la suma de dos bits y, adicionalmente, considerar un bit correspondiente al acarreo de entrada.

El sumador completo posee tres señales de entrada:

- **A:** primer bit de entrada.
- **B:** segundo bit de entrada.
- **Ci:** bit de acarreo de entrada.

Como resultado de la operación se generan dos salidas:

- **So:** representa el resultado de la suma.
- **Co:** representa el acarreo generado durante la operación.

Debido a que el circuito cuenta con tres entradas binarias, existen ocho posibles combinaciones de entrada.

A continuación se presenta la tabla de verdad del sumador completo de 1 bit:

| A | B | Ci | Co | So |
|:---:|:---:|:---:|:---:|:---:|
| 0 | 0 | 0 | 0 | 0 |
| 0 | 0 | 1 | 0 | 1 |
| 0 | 1 | 0 | 0 | 1 |
| 0 | 1 | 1 | 1 | 0 |
| 1 | 0 | 0 | 0 | 1 |
| 1 | 0 | 1 | 1 | 0 |
| 1 | 1 | 0 | 1 | 0 |
| 1 | 1 | 1 | 1 | 1 |

A partir de la tabla de verdad se puede observar que la salida **So** representa el resultado obtenido al sumar los tres bits de entrada.

Por otra parte, la salida **Co** se activa cuando la operación genera un acarreo hacia una posición binaria superior.

Las expresiones lógicas del sumador completo son:

    So = A XOR B XOR Ci

Para la salida de acarreo:

    Co = AB + ACi + BCi

Estas expresiones permiten construir el circuito utilizando diferentes compuertas lógicas. La salida de suma se obtiene mediante operaciones XOR, mientras que la salida de acarreo puede implementarse mediante operaciones AND y OR.

**Código utilizado para la implementación del sumador:**

![Sumador completo de 1 bit](/SUMA.jpeg)

*Figura 3. Implementación del sumador completo de 1 bit.*

### Video de funcionamiento del sumador completo de 1 bit

[Ver video del sumador de 1 bit](https://youtube.com/shorts/kAMwP_q6PQ4?si=WbGBHEaAVNdeOfpQ)

---

# 2. Simulaciones

Después de realizar la descripción de los circuitos en Verilog, se efectuaron las simulaciones correspondientes con el objetivo de comprobar su funcionamiento.

Las simulaciones permiten analizar la respuesta de las salidas frente a las diferentes combinaciones posibles de las señales de entrada. De esta forma, se puede verificar que los resultados generados por cada circuito coincidan con el comportamiento esperado según las tablas de verdad y las funciones lógicas utilizadas [1], [2].

---

## 2.1 Simulación de las compuertas lógicas

Para comprobar el funcionamiento de las compuertas lógicas se realizaron pruebas utilizando las diferentes combinaciones posibles de las señales de entrada.

En el caso de la compuerta NOT se analizaron los dos estados posibles de su única entrada.

Para las compuertas AND, OR, XOR y XNOR se evaluaron las cuatro combinaciones posibles de las entradas A y B.

![Simulación de compuertas](/compuertas.jpeg)

*Figura 4. Simulación de las compuertas lógicas.*

Los resultados obtenidos permitieron comprobar que cada una de las salidas responde correctamente de acuerdo con la operación lógica que representa.

---

## 2.2 Simulación del verificador de números primos

Para comprobar el funcionamiento del verificador se probaron todas las combinaciones binarias posibles de las tres entradas.

Durante la simulación se verificó que la salida se activa únicamente cuando las entradas representan un número primo dentro del intervalo comprendido entre 0 y 7.

Las combinaciones correspondientes a los números primos son:

    010 = 2
    011 = 3
    101 = 5
    111 = 7

Para las demás combinaciones posibles, la salida del circuito permanece desactivada.

![Simulación del verificador de números primos](/VERIFICADOR.jpeg)

*Figura 5. Simulación del circuito verificador de números primos.*

Los resultados obtenidos permitieron confirmar que el diseño identifica correctamente las combinaciones binarias correspondientes a los números primos.

---

## 2.3 Simulación del sumador completo de 1 bit

Para verificar el funcionamiento del sumador completo se analizaron las ocho combinaciones posibles de las entradas A, B y Ci.

Durante la simulación se observaron las respuestas generadas en las salidas So y Co.

La salida **So** representa el resultado de la suma binaria de las tres señales de entrada.

Por otra parte, la salida **Co** se activa en aquellas combinaciones donde la operación genera un bit de acarreo.

![Simulación del sumador de 1 bit](/sumador%20de%201%20bit.jpeg)

*Figura 6. Simulación del sumador completo de 1 bit.*

Los resultados obtenidos permitieron comprobar que el circuito implementado cumple correctamente con el comportamiento establecido en la tabla de verdad del sumador completo.

---

# 3. Evidencias de implementación

Como parte del desarrollo de la práctica se realizaron diferentes evidencias relacionadas con el funcionamiento de los circuitos implementados.

Las evidencias corresponden a las tres actividades principales desarrolladas durante el laboratorio:

1. Implementación y funcionamiento de las compuertas lógicas.
2. Funcionamiento del circuito verificador de números primos.
3. Funcionamiento del sumador completo de 1 bit.

Los videos presentados en las secciones correspondientes permiten observar de manera práctica el comportamiento de cada uno de los circuitos desarrollados.

Estas evidencias permiten relacionar los resultados obtenidos durante las simulaciones con el funcionamiento práctico de los diseños implementados.

---

# 4. Conclusiones

El desarrollo de esta práctica permitió aplicar de manera práctica los conocimientos relacionados con la lógica combinacional y el diseño de circuitos digitales mediante el lenguaje Verilog.

La implementación de las diferentes compuertas lógicas permitió reforzar la comprensión de las operaciones fundamentales utilizadas en los sistemas digitales y comprobar su comportamiento mediante las distintas combinaciones de sus señales de entrada.

El desarrollo del circuito verificador de números primos permitió aplicar funciones booleanas para identificar combinaciones específicas de valores binarios. Esta actividad permitió relacionar conceptos matemáticos con el diseño de sistemas digitales combinacionales.

Por otra parte, la implementación del sumador completo de un bit permitió comprender el proceso de suma binaria y la importancia del acarreo dentro de las operaciones realizadas por los sistemas digitales.

Las simulaciones fueron fundamentales para comprobar el funcionamiento de cada uno de los diseños, ya que permitieron verificar que las respuestas generadas coincidieran con los resultados esperados según las tablas de verdad.

En general, la práctica permitió fortalecer los conocimientos relacionados con los circuitos combinacionales y adquirir experiencia en la descripción, diseño y simulación de sistemas digitales mediante Verilog.

---

# Referencias

[1] Intel Corporation, *Intel Quartus Prime Software*. Disponible en: https://www.intel.com/content/www/us/en/software/programmable/quartus-prime/overview.html

[2] Microsoft, *Visual Studio Code*. Disponible en: https://code.visualstudio.com/

[3] IEEE, *Verilog Hardware Description Language*.
