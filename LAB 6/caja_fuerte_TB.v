
`timescale 1ns / 1ps

`include "caja_fuerte.v"

module caja_fuerte_TB;

    // Entradas
    reg clk;
    reg reset;
    reg enter_pulse;
    reg [3:0] SW;

    // Salidas
    wire servo_abierto;
    wire led_verde;
    wire led_rojo;
    wire [1:0] intentos;
    wire [2:0] estado;

    wire [6:0] HEX0;
    wire [6:0] HEX1;
    wire [6:0] HEX2;
    wire [6:0] HEX3;
    wire [6:0] HEX4;
    wire [6:0] HEX5;

    // Instancia del circuito
    caja_fuerte DUT (
        .clk(clk),
        .reset(reset),
        .enter_pulse(enter_pulse),
        .SW(SW),

        .servo_abierto(servo_abierto),
        .led_verde(led_verde),
        .led_rojo(led_rojo),
        .intentos(intentos),
        .estado(estado),

        .HEX0(HEX0),
        .HEX1(HEX1),
        .HEX2(HEX2),
        .HEX3(HEX3),
        .HEX4(HEX4),
        .HEX5(HEX5)
    );

    // Reloj de 50 MHz
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    // Registrar señales para GTKWave
    initial begin
        $dumpfile("simulation.vcd");
        $dumpvars(0, caja_fuerte_TB);
    end

    // Monitor de funcionamiento
    initial begin
        $monitor(
            "Tiempo=%0t | Estado=%b | SW=%d | Intentos=%d | Servo=%b | LED V=%b | LED R=%b | HEX5-HEX0=%b_%b_%b_%b_%b_%b",
            $time, estado, SW, intentos,
            servo_abierto, led_verde, led_rojo,
            HEX5, HEX4, HEX3, HEX2, HEX1, HEX0
        );
    end

    //================================================
    // TAREA: PRESIONAR Y SOLTAR KEY0
    //================================================

    task presionar_KEY0;
    begin
        // Presionar: activo en bajo
        @(negedge clk);
        enter_pulse = 1'b0;

        // Mantener presionado más de 20 ms
        repeat (1000010) @(negedge clk);

        // Soltar el botón
        enter_pulse = 1'b1;

        // Esperar a que el antirrebote reconozca la liberación
        repeat (1000010) @(negedge clk);
    end
    endtask

    //================================================
    // TAREA: INGRESAR UN DIGITO
    //================================================

    task ingresar_digito;
        input [3:0] numero;
    begin
        SW = numero;
        presionar_KEY0;
    end
    endtask

    //================================================
    // TAREA: INGRESAR UNA CLAVE DE TRES DIGITOS
    //================================================

    task ingresar_clave;
        input [3:0] d1;
        input [3:0] d2;
        input [3:0] d3;
    begin
        ingresar_digito(d1);
        ingresar_digito(d2);
        ingresar_digito(d3);

        repeat (5) @(posedge clk);
    end
    endtask

    //================================================
    // TAREA: REINICIAR EL SISTEMA
    //================================================

    task reiniciar_sistema;
    begin
        reset = 1'b0;
        enter_pulse = 1'b1;
        SW = 4'd0;

        repeat (5) @(negedge clk);

        reset = 1'b1;

        repeat (5) @(posedge clk);
    end
    endtask

    //================================================
    // PRUEBAS
    //================================================

    initial begin

        // Valores iniciales
        reset = 1'b0;
        enter_pulse = 1'b1;
        SW = 4'd0;

        repeat (5) @(negedge clk);
        reset = 1'b1;

        repeat (5) @(posedge clk);

        $display("--------------------------------------");
        $display(" INICIO DE SIMULACION");
        $display("--------------------------------------");

        //============================================
        // PRUEBA 1: CLAVE CORRECTA 1-2-3
        //============================================

        $display("PRUEBA 1: INGRESO DE CLAVE CORRECTA");

        ingresar_clave(4'd1, 4'd2, 4'd3);

        $display("Estado despues de clave correcta: %b", estado);
        $display("LED verde: %b", led_verde);
        $display("Servo: %b", servo_abierto);

        //============================================
        // PRUEBA 2: CERRAR LA CAJA CON KEY0
        //============================================

        $display("PRUEBA 2: CERRAR LA CAJA");

        presionar_KEY0;

        $display("Estado despues de cerrar: %b", estado);

        //============================================
        // PRUEBA 3: REINICIAR PARA PROBAR ERRORES
        //============================================

        $display("PRUEBA 3: REINICIAR SISTEMA");

        reiniciar_sistema;

        $display("Intentos iniciales: %d", intentos);

        //============================================
        // PRUEBA 4: PRIMER INTENTO INCORRECTO
        //============================================

        $display("PRUEBA 4: PRIMERA CLAVE INCORRECTA");

        ingresar_clave(4'd4, 4'd5, 4'd6);

        $display("Estado: %b | Intentos restantes: %d",
                 estado, intentos);

        // Salir del estado ERROR
        presionar_KEY0;

        //============================================
        // PRUEBA 5: SEGUNDO INTENTO INCORRECTO
        //============================================

        $display("PRUEBA 5: SEGUNDA CLAVE INCORRECTA");

        ingresar_clave(4'd7, 4'd8, 4'd9);

        $display("Estado: %b | Intentos restantes: %d",
                 estado, intentos);

        presionar_KEY0;

        //============================================
        // PRUEBA 6: TERCER INTENTO INCORRECTO
        //============================================

        $display("PRUEBA 6: TERCERA CLAVE INCORRECTA");

        ingresar_clave(4'd5, 4'd5, 4'd5);

        $display("Estado: %b | Intentos restantes: %d",
                 estado, intentos);

        // KEY0 debe llevar al estado de bloqueo
        presionar_KEY0;

        //============================================
        // RESULTADO FINAL
        //============================================

        $display("--------------------------------------");
        $display(" FIN DE SIMULACION");
        $display(" Estado final: %b", estado);
        $display(" Intentos finales: %d", intentos);
        $display(" LED rojo: %b", led_rojo);
        $display("--------------------------------------");

        #100;
        $finish;

    end

endmodule
