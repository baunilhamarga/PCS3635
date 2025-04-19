//------------------------------------------------------------------
// Arquivo   : sync_ram_16x4.v
// Projeto   : PlaySeq
//------------------------------------------------------------------
// Descricao : RAM sincrona 16x4
//             com conteudo inicial pre-programado             
//------------------------------------------------------------------
// Revisoes  :
//     Data        Versao  Autor             Descricao
//     15/03/2025  1.0     Ana Vitória       versao inicial
//------------------------------------------------------------------

module sync_ram_16x4
(
    input        clk,
    input        we,
    input  [3:0] data,
    input  [3:0] addr,
    output [3:0] q
);

    // Variavel RAM (armazena dados)
    reg [3:0] ram[15:0];

    // Inicializa manualmente os valores da RAM (Verilog-2005 compatível)
    initial begin
        ram[0]  = 4'b0001; ram[1]  = 4'b0010; ram[2]  = 4'b0100; ram[3]  = 4'b1000;
        ram[4]  = 4'b0001; ram[5]  = 4'b0010; ram[6]  = 4'b0100; ram[7]  = 4'b1000;
        ram[8]  = 4'b0001; ram[9]  = 4'b0010; ram[10] = 4'b0100; ram[11] = 4'b1000;
        ram[12] = 4'b0001; ram[13] = 4'b0010; ram[14] = 4'b0100; ram[15] = 4'b1000;
    end

    // Registra endereco de acesso
    reg [3:0] addr_reg;

    always @ (posedge clk) begin
        if (we)
            ram[addr] <= data;

        addr_reg <= addr;
    end

    assign q = ram[addr_reg];

endmodule
