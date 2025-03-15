//------------------------------------------------------------------
// Arquivo   : sync_ram_16x4v
// Projeto   : PlaySeq
 
//------------------------------------------------------------------
// Descricao : RAM sincrona 16x4
//             com conteudo inicial pre-programado             
//------------------------------------------------------------------
// Revisoes  :
//     Data        Versao  Autor             Descricao
//     15/03/2025  1.0     Ana Vitória       versao inicial
//------------------------------------------------------------------
//

module sync_ram_16x4_file #(
    parameter BINFILE = "ram_init.txt"
)
(
    input        clk,
    input        we,
    input  [3:0] data,
    input  [3:0] addr,
    output [3:0] q
);

    // Variavel RAM (armazena dados)
    reg [3:0] ram[15:0];

    // Registra endereco de acesso
    reg [3:0] addr_reg;

    always @ (posedge clk)
    begin
        if (we)
            ram[addr] <= data;

        addr_reg <= addr;
    end

    assign q = ram[addr_reg];
endmodule