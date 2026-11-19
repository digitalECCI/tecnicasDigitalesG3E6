
`timescale 1ns / 1ps

module caja_fuerte(
    input wire clk,
    input wire reset,          // KEY1: activo en bajo
    input wire enter_pulse,    // KEY0: activo en bajo
    input wire [3:0] SW,

    output reg servo_abierto,
    output reg led_verde,
    output reg led_rojo,
    output reg [1:0] intentos,
    output wire [2:0] estado,

    output reg [6:0] HEX0,
    output reg [6:0] HEX1,
    output reg [6:0] HEX2,
    output reg [6:0] HEX3,
    output reg [6:0] HEX4,
    output reg [6:0] HEX5
);

    //================================================
    // 1. ESTADOS DE LA FSM
    //================================================

    localparam S_INICIO  = 3'b000;
    localparam S_CAP1    = 3'b001;
    localparam S_CAP2    = 3'b010;
    localparam S_VERIF   = 3'b011;
    localparam S_ABIERTO = 3'b100;
    localparam S_ERROR   = 3'b101;
    localparam S_BLOQUEO = 3'b110;

    reg [2:0] state;
    reg [2:0] next_state;

    assign estado = state;

    //================================================
    // 2. CLAVE SECRETA
    //================================================

    localparam [3:0] CLAVE1 = 4'd1;
    localparam [3:0] CLAVE2 = 4'd2;
    localparam [3:0] CLAVE3 = 4'd3;

    reg [3:0] digito1;
    reg [3:0] digito2;
    reg [3:0] digito3;

    wire clave_correcta;

    assign clave_correcta =
        (digito1 == CLAVE1) &&
        (digito2 == CLAVE2) &&
        (digito3 == CLAVE3);

  
    //================================================
    // 3. SINCRONIZACION Y ANTIRREBOTE DE KEY0
    //================================================

    reg key0_sync1;
    reg key0_sync2;
    reg key0_stable;

    reg [19:0] debounce_count;
    reg enter_event;

    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            key0_sync1 <= 1'b1;
            key0_sync2 <= 1'b1;
        end else begin
            key0_sync1 <= enter_pulse;
            key0_sync2 <= key0_sync1;
        end
    end

    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            key0_stable <= 1'b1;
            debounce_count <= 20'd0;
            enter_event <= 1'b0;
        end else begin

            // Por defecto, el pulso permanece apagado
            enter_event <= 1'b0;

            // Si la entrada coincide con el estado estable
            if (key0_sync2 == key0_stable) begin
                debounce_count <= 20'd0;
            end

            // Si la entrada cambia, contar hasta 20 ms
            else if (debounce_count < 20'd999999) begin
                debounce_count <= debounce_count + 1'b1;
            end

            // Confirmar el cambio después de 20 ms
            else begin
                key0_stable <= key0_sync2;
                debounce_count <= 20'd0;

                // Generar un único pulso al presionar KEY0
                if (key0_sync2 == 1'b0)
                    enter_event <= 1'b1;
            end
        end
    end


    //================================================
    // 4. REGISTROS DE LA FSM Y CAPTURA DE DIGITOS
    //================================================

    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            state <= S_INICIO;

            digito1 <= 4'd0;
            digito2 <= 4'd0;
            digito3 <= 4'd0;

            intentos <= 2'd3;
        end else begin

            state <= next_state;

            if (state == S_INICIO && enter_event)
                digito1 <= SW;

            if (state == S_CAP1 && enter_event)
                digito2 <= SW;

            if (state == S_CAP2 && enter_event)
                digito3 <= SW;

            if (state == S_VERIF && !clave_correcta && intentos > 0)
                intentos <= intentos - 1'b1;

        end
    end

    //================================================
    // 5. LOGICA DE TRANSICION DE ESTADOS
    //================================================

    always @(*) begin

        next_state = state;

        case (state)

            S_INICIO: begin
                if (enter_event)
                    next_state = S_CAP1;
            end

            S_CAP1: begin
                if (enter_event)
                    next_state = S_CAP2;
            end

            S_CAP2: begin
                if (enter_event)
                    next_state = S_VERIF;
            end

            S_VERIF: begin
                if (clave_correcta)
                    next_state = S_ABIERTO;
                else
                    next_state = S_ERROR;
            end

            S_ABIERTO: begin
    if (enter_event)
        next_state = S_INICIO;
    else
        next_state = S_ABIERTO;
end

            S_ERROR: begin
                if (enter_event) begin
                    if (intentos > 0)
                        next_state = S_INICIO;
                    else
                        next_state = S_BLOQUEO;
                end
            end

            S_BLOQUEO: begin
                next_state = S_BLOQUEO;
            end

            default: begin
                next_state = S_INICIO;
            end

        endcase
    end

    //================================================
    // 6. SALIDAS DE LEDS
    //================================================

    always @(*) begin

        led_verde = 1'b0;
        led_rojo = 1'b0;

        case (state)

            S_ABIERTO: begin
                led_verde = 1'b1;
            end

            S_ERROR: begin
                led_rojo = 1'b1;
            end

            S_BLOQUEO: begin
                led_rojo = 1'b1;
            end

            default: begin
                led_verde = 1'b0;
                led_rojo = 1'b0;
            end

        endcase
    end

    //================================================
    // 7. CONTROL PWM DEL SERVO
    //================================================

    reg [19:0] pwm_count;
    reg servo_comando;

    // 50 MHz / 50 Hz = 1.000.000 cuentas
    // 50.000 cuentas = 1 ms
    // 100.000 cuentas = 2 ms

    always @(*) begin
        servo_comando = (state == S_ABIERTO);
    end

    always @(posedge clk or negedge reset) begin

        if (!reset) begin
            pwm_count <= 0;
            servo_abierto <= 1'b0;
        end else begin

            if (pwm_count >= 20'd999999)
                pwm_count <= 0;
            else
                pwm_count <= pwm_count + 1'b1;

            if (servo_comando) begin
                servo_abierto <= (pwm_count < 20'd100000);
            end else begin
                servo_abierto <= (pwm_count < 20'd50000);
            end

        end
    end

    //================================================
    // 8. DECODIFICADOR HEXADECIMAL
    //================================================

    function [6:0] hex7;
        input [3:0] numero;
        begin
            case (numero)
                4'h0: hex7 = 7'b1000000;
                4'h1: hex7 = 7'b1111001;
                4'h2: hex7 = 7'b0100100;
                4'h3: hex7 = 7'b0110000;
                4'h4: hex7 = 7'b0011001;
                4'h5: hex7 = 7'b0010010;
                4'h6: hex7 = 7'b0000010;
                4'h7: hex7 = 7'b1111000;
                4'h8: hex7 = 7'b0000000;
                4'h9: hex7 = 7'b0010000;
                4'hA: hex7 = 7'b0001000;
                4'hB: hex7 = 7'b0000011;
                4'hC: hex7 = 7'b1000110;
                4'hD: hex7 = 7'b0100001;
                4'hE: hex7 = 7'b0000110;
                4'hF: hex7 = 7'b0001110;
                default: hex7 = 7'b1111111;
            endcase
        end
    endfunction

    //================================================
    // 9. DECODIFICADOR DE LETRAS
    //================================================

    function [6:0] letra7;
    input [7:0] letra;
    begin
        case (letra)
            "A": letra7 = 7'b0001000;
            "C": letra7 = 7'b1000110;
            "E": letra7 = 7'b0000110;
            "I": letra7 = 7'b1111001;
            "L": letra7 = 7'b1000111;
            "N": letra7 = 7'b0101011;
            "O": letra7 = 7'b1000000;
            "q": letra7 = 7'b0011000;
            "S": letra7 = 7'b0010010;
            "T": letra7 = 7'b0000111;
            "u": letra7 = 7'b1100011;
            "b": letra7 = 7'b0000011;
            "r": letra7 = 7'b0101111;
            "R": letra7 = 7'b0101111;
            "k": letra7 = 7'b1101000;
            "-": letra7 = 7'b0111111;
            "U": letra7 = 7'b1000001;
            default: letra7 = 7'b1111111;
        endcase
    end

endfunction

    //================================================
    // 10. VISUALIZACION EN LOS 6 DISPLAYS
    //================================================

    always @(*) begin

        // Todos apagados inicialmente
        HEX0 = 7'b1111111;
        HEX1 = 7'b1111111;
        HEX2 = 7'b1111111;
        HEX3 = 7'b1111111;
        HEX4 = 7'b1111111;
        HEX5 = 7'b1111111;

        case (state)

            // Mostrar SW en tiempo real
            S_INICIO: begin
                HEX0 = hex7(SW);
            end

            S_CAP1: begin
                HEX0 = hex7(SW);
                HEX1 = hex7(digito1);
            end

            S_CAP2: begin
                HEX0 = hex7(SW);
                HEX1 = hex7(digito2);
                HEX2 = hex7(digito1);
            end

            S_VERIF: begin
                HEX0 = 7'b1111111;
                HEX1 = 7'b1111111;
                HEX2 = 7'b1111111;
            end

            // Mensaje: AccESO
            S_ABIERTO: begin
                HEX0 = letra7("O");
                HEX1 = letra7("S");
                HEX2 = letra7("E");
                HEX3 = letra7("C");
                HEX4 = letra7("C");
                HEX5 = letra7("A");
            end

            // Mensaje: Int. n
        S_ERROR: begin
    HEX5 = 7'b1111111;
    HEX4 = letra7("E");
    HEX3 = letra7("r");
    HEX2 = letra7("r");
    HEX1 = letra7("O");
    HEX0 = hex7(intentos);
end
            // Mensaje: bLOquE
        S_BLOQUEO: begin
    HEX5 = letra7("b");
    HEX4 = letra7("L");
    HEX3 = letra7("O");
    HEX2 = letra7("q");
    HEX1 = letra7("U");
    HEX0 = letra7("E");
end
            default: begin
                HEX0 = 7'b1111111;
                HEX1 = 7'b1111111;
                HEX2 = 7'b1111111;
                HEX3 = 7'b1111111;
                HEX4 = 7'b1111111;
                HEX5 = 7'b1111111;
            end

        endcase
    end

endmodule
