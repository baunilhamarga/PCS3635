//------------------------------------------------------------------
// Arquivo   : exp4_fluxo_dados.v
// Projeto   : Experiencia 6 - Jogo da Memória
//------------------------------------------------------------------
// Descricao : Fluxo de Dados da Experiência 6
//             
//------------------------------------------------------------------
// Revisoes  :
//     Data        Versao  Autor             Descricao
//     25/01/2025  1.0     Ana Vitória       versao inicial
//------------------------------------------------------------------
//

module exp6_fluxo_dados (
    input clock,
    input [3:0] botoes,
    input nivel,
    input zeraT,
    input zeraR,
    input registraR,
    input contaE,
    input contaS,
    input contaT,
    input zeraE,
    input zeraS,
    output igual,
    output enderecoIgualSequencia,
    output fimE,
    output fimS,
    output [3:0] db_contagem,
    output [3:0] db_jogada_feita,
    output [3:0] db_memoria,
    output tem_jogada,
    output controle_timeout,
    output [3:0] db_sequencia,
    output controle_timeout_led,
    output enderecoMaiorQueSequencia
);

    wire [3:0] s_endereco;
    wire [3:0] s_dado;
    wire [3:0] s_botoes;
    wire [3:0] s_sequencia;
    wire [3:0] s_sequencia_fixo;
    wire s_tem_jogada = |botoes;
    wire rco;

    // mux
    mux2x1 mux (
        .D0 (&s_endereco[2:0]),
        .D1 (rco),
        .SEL (nivel),
        .OUT (fimE)
    );

    // contador endereços
    contador_163 contEnd (
        .clock (clock),
        .clr   (~zeraE),
        .ld    (1'b1),
        .ent   (1'b1),
        .enp   (contaE),
        .D     (4'b0),
        .Q     (s_endereco),
        .rco   (rco)
    );

    // contador sequencias
    contador_163 contLmt (
        .clock (clock),
        .clr   (~zeraS),
        .ld    (1'b1),
        .ent   (1'b1),
        .enp   (contaS),
        .D     (4'b0),
        .Q     (s_sequencia),
        .rco   (fimS)
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

    // comparador sequencias
    comparador_85 compLmt (
        .A    (s_sequencia),
        .B    (s_endereco),
        .ALBi (1'b0),
        .AGBi (1'b0),
        .AEBi (1'b1),
        .ALBo (),
        .AGBo (enderecoMaiorQueSequencia),
        .AEBo (enderecoIgualSequencia)
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
        .reset (zeraS),
        .sinal (s_tem_jogada),
        .pulso (jogada_feita)
    );

    contador_m #(.M(5000), .N(13)) contador_timeout (
        .clock   (clock),
        .zera_as (zeraC || zeraR),
        .zera_s  (zeraT),
        .conta   (contaT),
        .Q       (),
        .fim     (controle_timeout), 
        .decimo  (controle_timeout_led)
    );

    assign db_memoria  = s_dado;
    assign db_contagem = s_endereco;
    assign tem_jogada = s_tem_jogada;
    assign db_sequencia = s_sequencia;
endmodule
