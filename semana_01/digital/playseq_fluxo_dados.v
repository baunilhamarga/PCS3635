//------------------------------------------------------------------
// Arquivo   : playseq_fluxo_dados.v
// Projeto   : PlaySeq
//------------------------------------------------------------------
// Descricao : Fluxo de Dados do Jogo PlaySeq
//             
//------------------------------------------------------------------
// Revisoes  :
//     Data        Versao  Autor             Descricao
//     07/03/2025  1.0     Ana Vitória       versao inicial
//------------------------------------------------------------------
//

module playseq_fluxo_dados (
    input clock,
    input [3:0] botoes,
    input [1:0] nivel,
    input zeraT,
    input zeraR,
    input registraR,
    input contaE,
    input contaS,
    input contaT,
    input contaJ,
    input zeraE,
    input zeraS,
    input zeraJ,
    input carregaE,
    input controla_leds,
    input zeraT_leds,
    input contaT_leds,
    input fase_preview,
    input [1:0] seletor_memoria,
    output igual,
    output enderecoIgualSequencia,
    output fimE,
    output fimS,
    output tem_jogada,
    output [3:0] db_contagem,
    output [3:0] db_jogadafeita,
    output [3:0] db_memoria,
    output controle_timeout,
    output [3:0] db_sequencia,
    output controle_timeout_led,
    output sequenciaMenorQueEndereco,
    output [3:0] leds,
    output db_seletor_memoria,
    output pare
);

    wire [3:0] s_endereco;
    wire [3:0] s_dado;
    wire [3:0] s_botoes;
    wire [3:0] s_sequencia;
    wire [3:0] s_sequencia_fixo;
    wire s_tem_jogada = |botoes;
    wire [3:0] s_mux;
    wire [3:0] s_mem1;
    wire [3:0] s_mem2;
    wire [3:0] s_mem3;
    wire [1:0] s_contagem;

    // dificuldade_quant
    mux4x2_n #( .BITS(1) ) mux (
        .D0 (~s_contagem[0] & ~s_contagem[1]),
        .D1 (~s_contagem[0] & s_contagem[1]),
        .D2 (&s_contagem[1:0]),
        .D3 (1'b1),
        .SEL (nivel),
        .OUT (pare)
    );

    // mux n
    mux2x1_n #( .BITS(4) ) mux_leds (
      .D0(botoes),
      .D1(s_mux),
      .SEL(fase_preview),
      .OUT(leds)
    );

    // mux n
    mux2x1_n #( .BITS(4) ) mux_zera (
      .D0(4'b0000),
      .D1(s_dado),
      .SEL(controla_leds),
      .OUT(s_mux)
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
        .rco   (fimE)
    );

    // contador sequencias
    contador_163 contLmt (
        .clock (clock),
        .clr   (~zeraS),
        .ld    (~carregaE),
        .ent   (1'b1),
        .enp   (contaS),
        .D     (4'b0101),
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
        .ALBo (sequenciaMenorQueEndereco),
        .AGBo (),
        .AEBo (enderecoIgualSequencia)
    );

    // dificuldade_seq
    mux4x2_n #( .BITS(4) ) mux_jogo (
      .D0(s_mem1),
      .D1(s_mem2),
      .D2(s_mem3),
      .D3(s_mem1), // será memória personalizável mais para frente
      .SEL(seletor_memoria),
      .OUT(s_dado)
    );

    // memória 1
    memoria_1 memoria1 (
        .clock    (clock),
        .address  (s_endereco),
        .data_out (s_mem1)
    );

    // memória 2
    memoria_2 memoria2 (
        .clock    (clock),
        .address  (s_endereco),
        .data_out (s_mem2)
    );

    // memória 3
    memoria_3 memoria3 (
        .clock    (clock),
        .address  (s_endereco),
        .data_out (s_mem3)
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
        .pulso (tem_jogada)
    );

    contador_m #(.M(5000), .N(13)) contador_timeout_jogadas (
        .clock   (clock),
        .zera_as (zeraC || zeraR),
        .zera_s  (zeraT),
        .conta   (contaT),
        .Q       (),
        .fim     (controle_timeout),
        .meio    ()
    );

    contador_m #(.M(500), .N(9)) contador_timeout_leds (
        .clock   (clock),
        .zera_as (zeraC || zeraR),
        .zera_s  (zeraT_leds),
        .conta   (contaT_leds),
        .Q       (),
        .fim     (controle_timeout_led),
        .meio    ()
    );

    contador_m #(.M(4), .N(2)) contador_jogadas (
        .clock   (clock),
        .zera_as (zeraC || zeraR), // precisa ser um zera diferente
        .zera_s  (zeraJ),
        .conta   (contaJ), // precisa ser um zera diferente
        .Q       (s_contagem),
        .fim     (),
        .meio    ()
    );

    assign db_memoria  = s_dado;
    assign db_contagem = s_endereco;
    assign db_sequencia = s_sequencia;
    assign db_jogadafeita = s_botoes;
    assign db_seletor_memoria = seletor_memoria;
endmodule
