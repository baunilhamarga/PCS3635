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

module exp5_fluxo_dados (
    input clock,
    input contaL,
    input zeraL,
    input zeraE,
    input contaE,
    input contaT,
    input zeraR,
    input zeraT,
    input registraR,
    input [3:0] botoes,
    output enderecoMenorOuIguaLimite,
    output enderecoIgualLimite,
    output fimE,
    output fimL,
    output jogada_feita,
    output db_tem_jogada,
    output [3:0] db_contagem,
    output [3:0] db_memoria,
    output [3:0] db_jogadafeita,
    output [3:0] db_limite,
    output controle_timeout,
    output igual
);

    wire [3:0] s_endereco;
    wire [3:0] s_dado;
    wire [3:0] s_botoes;
    wire [3:0] s_limite;
    wire tem_jogada = |botoes;

    // contador endereços
    contador_163 contEnd (
        .clock (clock),
        .clr   (~zeraE),
        .ld    (1'b1),
        .ent   (1'b1),
        .enp   (contaE),
        .D     (4'b0),
        .Q     (s_endereco),
        .rco   (fimE)
    );

    // contador limites
    contador_163 contLmt (
        .clock (clock),
        .clr   (~zeraL),
        .ld    (1'b1),
        .ent   (1'b1),
        .enp   (contaL),
        .D     (4'b0),
        .Q     (s_limite),
        .rco   (fimL)
    );

    // comparador jogadas
    comparador_85 compJog (
        .A    (s_dado),
        .B    (s_botoes),
        .ALBi (1'b0),
        .AGBi (1'b0),
        .AEBi (1'b1),
        .ALBo (),
        .AGBo (),
        .AEBo (igual)
    );

    // comparador limites
    comparador_85 compLmt (
        .A    (s_limite),
        .B    (s_endereco),
        .ALBi (1'b0),
        .AGBi (1'b0),
        .AEBi (1'b1),
        .ALBo (),
        .AGBo (enderecoMenorOuIguaLimite),
        .AEBo (enderecoIgualLimite)
    );

    // memória
    sync_rom_16x4 memoria (
        .clock    (clock),
        .address  (s_endereco),
        .data_out (s_dado)
    );

    // registrador
    registrador_4 regBotoes (
        .clock  (clock),
        .clear  (zeraR),
        .enable (registraR),
        .D      (botoes),
        .Q      (s_botoes)
    );

    edge_detector detector (
        .clock (clock),
        .reset (zeraL),
        .sinal (tem_jogada),
        .pulso (jogada_feita)
    );

    contador_m #(.M(5000), .N(13)) contador_timeout (
        .clock   (clock),
        .zera_as (zeraC || zeraR),
        .zera_s  (zeraT),
        .conta   (contaT),
        .Q       (),
        .fim     (controle_timeout), 
        .meio    ()
    );

    assign db_memoria  = s_dado;
    assign db_jogadafeita = s_botoes;
    assign db_contagem = s_endereco;
    assign db_tem_jogada = tem_jogada;
    assign db_limite = s_limite;
endmodule
