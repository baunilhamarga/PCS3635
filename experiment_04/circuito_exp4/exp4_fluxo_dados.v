//------------------------------------------------------------------
// Arquivo   : exp4_fluxo_dados.v
// Projeto   : Experiencia 4 - Desenvolvimento de Projeto de
//             Circuitos Digitais em FPGA 
//------------------------------------------------------------------
// Descricao : Fluxo de Dados da Experiência 4
//             
//------------------------------------------------------------------
// Revisoes  :
//     Data        Versao  Autor             Descricao
//     25/01/2025  1.0     Ana Vitória       versao inicial
//------------------------------------------------------------------
//

module exp4_fluxo_dados (
    input clock,
    input zeraC,
    input contaC,
    input zeraR,
    input registraR,
    input [3:0] chaves,
    output igual,
    output fimC,
    output jogada_feita,
    output db_tem_jogada,
    output [3:0] db_contagem,
    output [3:0] db_memoria,
    output [3:0] db_jogadafeita
);

    wire [3:0] s_endereco;
    wire [3:0] s_dado;
    wire [3:0] s_chaves;
    wire tem_jogada = |chaves;

    // contador_163
    contador_163 contadorJ (
        .clock (clock),
        .clr   (~zeraC),
        .ld    (1'b1),
        .ent   (1'b1),
        .enp   (contaC),
        .D     (4'b0),
        .Q     (s_endereco),
        .rco   (fimC)
    );

    // comparador_85
    comparador_85 comparador (
        .A    (s_dado),
        .B    (s_chaves),
        .ALBi (1'b0),
        .AGBi (1'b0),
        .AEBi (1'b1),
        .ALBo (),
        .AGBo (),
        .AEBo (igual)
    );

    // memória
    sync_rom_16x4 memoria (
        .clock    (clock),
        .address  (s_endereco),
        .data_out (s_dado)
    );

    // registrador
    registrador_4 registradorJ (
        .clock  (clock),
        .clear  (zeraR),
        .enable (registraR),
        .D      (chaves),
        .Q      (s_chaves)
    );

    edge_detector detector (
        .clock (clock),
        .reset (zeraC),
        .sinal (tem_jogada),
        .pulso (jogada_feita)
    );

    assign db_memoria  = s_dado;
    assign db_jogadafeita   = s_chaves;
    assign db_contagem = s_endereco;
    assign db_tem_jogada = tem_jogada;
endmodule
