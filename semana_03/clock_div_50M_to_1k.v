//------------------------------------------------------------------
// Arquivo   : clock_div_50M_to_1k.v
// Projeto   : PlaySeq
//------------------------------------------------------------------
// Descricao : Contador divisor de clock de 50 MHz para 1KHz
//          
//------------------------------------------------------------------
// Revisoes  :
//     Data        Versao  Autor             Descricao
//     22/03/2025  1.0     Ana Vitória       versao inicial
//------------------------------------------------------------------
//

module clock_div_50M_to_1k (
    input clock_in,   // Clock de entrada (50 MHz)
    output reg clock_out  // Clock de saída (1 kHz)
);

    reg [27:0] counter = 28'd0;
    parameter DIVISOR = 28'd100;  // Divisor para gerar 1 kHz a partir de 50 MHz

    always @(posedge clock_in) begin
        counter <= counter + 28'd1;

        if(counter >= (DIVISOR - 1))  
            counter <= 28'd0;

        // Gera o sinal de saída (1 kHz)
        clock_out <= (counter < DIVISOR / 2) ? 1'b1 : 1'b0;
    end
endmodule

