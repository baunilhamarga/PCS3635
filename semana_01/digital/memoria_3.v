//------------------------------------------------------------------
// Arquivo   : memoria_3.v
// Projeto   : PlaySeq
//------------------------------------------------------------------
// Descricao : ROM sincrona 16x4 (conteúdo pre-programado)
//             
//------------------------------------------------------------------
// Revisoes  :
//     Data        Versao  Autor             Descricao
//     14/12/2023  1.0     Edson Midorikawa  versao inicial
//------------------------------------------------------------------
//
module memoria_3 (clock, address, data_out);
    input            clock;
    input      [3:0] address;
    output reg [3:0] data_out;

    always @ (posedge clock)
    begin
        case (address)
            4'b0000: data_out = 4'b0001; // 4
            4'b0001: data_out = 4'b0001; // 5
            4'b0010: data_out = 4'b0001; // 6
            4'b0011: data_out = 4'b0001; // 7 
            4'b0100: data_out = 4'b0010; // 8
            4'b0101: data_out = 4'b0010; // 9
            4'b0110: data_out = 4'b0010; // 10
            4'b0111: data_out = 4'b0010; // 11
            4'b1000: data_out = 4'b0100; // 12
            4'b1001: data_out = 4'b0100; // 13
            4'b1010: data_out = 4'b0100; // 14
            4'b1011: data_out = 4'b0100; // 15
            4'b1100: data_out = 4'b1000; // 16
            4'b1101: data_out = 4'b1000; // 17
            4'b1110: data_out = 4'b1000; // 18
            4'b1111: data_out = 4'b1000; // 19
        endcase
    end
endmodule