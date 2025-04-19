//------------------------------------------------------------------
// Arquivo   : sync_rom_16x4.v
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

module sync_rom_16x4 #(parameter ROM_FILE = "jogo_1.mem") (
    input            clock,
    input      [3:0] address,
    output reg [3:0] data_out
);

    reg [3:0] rom [15:0];  // Declaração da ROM como um array de registradores

    initial begin
        $readmemb(ROM_FILE, rom); // Lê os dados do arquivo binário
        // Para arquivo hexadecimal, use: $readmemh(ROM_FILE, rom);
    end

    always @ (posedge clock) begin
        data_out <= rom[address];  // Atribui o valor da ROM com base no endereço
    end

endmodule

