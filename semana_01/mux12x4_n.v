/*------------------------------------------------------------------------
 * Arquivo   : mux12x4_n.v
 * Projeto   : PlaySeq
 *------------------------------------------------------------------------
 * Descricao : multiplexador 12x4(4 bit de seletor) com entradas de n bits 
 * (parametrizado) 
 * 
 *------------------------------------------------------------------------
 * Revisoes  :
 *     Data        Versao  Autor             Descricao
 *     07/03/2024  1.0     Ana Vitória       criacao
 *------------------------------------------------------------------------
 */

module mux12x4_n #(
    parameter BITS = 4
) (
    input      [BITS-1:0] D0, // nível fácil e memória fácil
    input      [BITS-1:0] D1, // nível fácil e memória média
    input      [BITS-1:0] D2, // nível fácil e memória difícil
    input      [BITS-1:0] D3, // nível fácil e memória personalizada
    input      [BITS-1:0] D4, // nível médio e memória fácil
    input      [BITS-1:0] D5, // nível médio e memória média
    input      [BITS-1:0] D6, // nível médio e memória difícil
    input      [BITS-1:0] D7, // nível médio e memória personalizada
    input      [BITS-1:0] D8, // nível difícil e memória fácil
    input      [BITS-1:0] D9, // nível difícil e memória média
    input      [BITS-1:0] D10, // nível difícil e memória difícil
    input      [BITS-1:0] D11, // nível difícil e memória personalizada
    input      [3:0]      SEL,
    output reg [BITS-1:0] OUT
);

always @(*) begin
    case (SEL)
        4'b0000:    OUT = D0;
        4'b0001:    OUT = D1;
        4'b0010:    OUT = D2;
        4'b0011:    OUT = D3;
        4'b0100:    OUT = D4;
        4'b0101:    OUT = D5;
        4'b0110:    OUT = D6;
        4'b0111:    OUT = D7;
        4'b1000:    OUT = D8;
        4'b1001:    OUT = D9;
        4'b1010:    OUT = D10;
        4'b1011:    OUT = D11;
        default: OUT = {BITS{1'b1}}; // todos os bits em 1
    endcase
end

endmodule