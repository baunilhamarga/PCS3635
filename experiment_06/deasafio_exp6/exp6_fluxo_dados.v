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
    input controla_leds,
    input zeraT_leds,
    input contaT_leds,
    input fase_preview,
    input seletor_memoria,
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
    output [3:0] db_seletor_memoria
);

    wire [3:0] s_endereco;
    wire [3:0] s_dado;
    wire [3:0] s_botoes;
    wire [3:0] s_sequencia;
    wire [3:0] s_sequencia_fixo;
    wire s_tem_jogada = |botoes;
    wire rco;
    wire [3:0] s_mux;
    wire [3:0] s_mem1;
    wire [3:0] s_mem2;

    // mux
    mux2x1 mux (
        .D0 (&s_endereco[2:0]),
        .D1 (rco),
        .SEL (nivel),
        .OUT (fimE)
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
        .ALBo (sequenciaMenorQueEndereco),
        .AGBo (),
        .AEBo (enderecoIgualSequencia)
    );

    mux2x1_n #( .BITS(4) ) mux_jogo (
      .D0(s_mem1),
      .D1(s_mem2),
      .SEL(seletor_memoria),
      .OUT(s_dado)
    );

    // memória 1
    sync_rom_16x4 #(.ROM_FILE("jogo_1.mem")) memoria (
        .clock    (clock),
        .address  (s_endereco),
        .data_out (s_mem1)
    );

    // memória 2
    sync_rom_16x4 #(.ROM_FILE("jogo_2.mem")) memoria (
        .clock    (clock),
        .address  (s_endereco),
        .data_out (s_mem2)
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

    assign db_memoria  = s_dado;
    assign db_contagem = s_endereco;
    assign db_sequencia = s_sequencia;
    assign db_jogadafeita = s_botoes;
    assign db_seletor_memoria = seletor_memoria;
endmodule
