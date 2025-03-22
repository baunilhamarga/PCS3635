/*------------------------------------------------------------------------
 * Arquivo   : mux4x2_n.v
 * Projeto   : PlaySeq
 *------------------------------------------------------------------------
 * Descricao : multiplexador 4x(2 bit de seletor) com entradas de n bits 
 * (parametrizado) 
 * 
 *------------------------------------------------------------------------
 * Revisoes  :
 *     Data        Versao  Autor             Descricao
 *     07/03/2024  1.0     Ana Vitória       criacao
 *------------------------------------------------------------------------
 */

module mux4x2_n #(
    parameter BITS = 4
) (
    input      [BITS-1:0] D0,
    input      [BITS-1:0] D1,
    input      [BITS-1:0] D2,
    input      [BITS-1:0] D3,
    input      [1:0]      SEL,
    output reg [BITS-1:0] OUT
);

always @(*) begin
    case (SEL)
        2'b00:    OUT = D0;
        2'b01:    OUT = D1;
        2'b10:    OUT = D2;
        2'b11:    OUT = D3;
        default: OUT = {BITS{1'b1}}; // todos os bits em 1
    endcase
end

endmodule