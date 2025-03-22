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
    input carregaS,
    input controla_leds,
    input zeraT_leds,
    input contaT_leds,
    input fase_preview,
    input [1:0] seletor_memoria,
    input ram_escreve,
    input quer_escrever,
    input [1:0] timeoutD,
    input conta_ganhar,
    input conta_perder,
    input zera_metricas,
    input ignora_timeout,
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
    output pare,
    output [1:0] db_contagem_jogo,
    output vai_escrever,
    output [3:0] ganhos,
    output [3:0] perdas
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
    wire [3:0] s_mem4;
    wire [1:0] s_contagem;
    wire [3:0] s_quant_inicial;
    wire [3:0] s_seletor_final = {nivel, seletor_memoria};
	wire rco;
    wire fim_dois_e_meios;
    wire fim_5s;
    wire fim_10s;
    wire fim_20s;
    wire s_controle_timeout;

    // dificuldade_quant
    mux4x2_n #( .BITS(1) ) mux_quant (
        .D0 (~s_contagem[0] & ~s_contagem[1]),
        .D1 (s_contagem[0] & ~s_contagem[1]),
        .D2 (~s_contagem[0] & s_contagem[1]),
        .D3 (1'b1),
        .SEL (nivel),
        .OUT (pare)
    );

    // dificuldade_ms
    mux4x2_n #( .BITS(1) ) mux_timeout (
        .D0 (fim_20s),
        .D1 (fim_10s),
        .D2 (fim_5s),
        .D3 (fim_dois_e_meios),
        .SEL (timeoutD),
        .OUT (s_controle_timeout)
    );

    // ignora_timeout
    mux2x1 mux_controla_timeout (
        .D0 (s_controle_timeout),
        .D1 (1'b0),
        .SEL (ignora_timeout),
        .OUT (controle_timeout)
    );

    // decide o início para cada situação, sempre defasado de 1
    mux12x4_n #( .BITS(4) ) mux_inicial (
        .D0 (4'b0100), // feito
        .D1 (4'b1000), // feito
        .D2 (4'b0111), // feito
        .D3 (4'b0100),
        .D4 (4'b0101), //feito
        .D5 (4'b1000), // feito
        .D6 (4'b0101), // feito
        .D7 (4'b0100),
        .D8 (4'b0100), // feito
        .D9 (4'b1000), // feito
        .D10(4'b0011), // feito
        .D11(4'b0100),
        .SEL (s_seletor_final),
        .OUT (s_quant_inicial)
    );

    // decide o final para cada situação
    mux12x4_n #( .BITS(1) ) mux_final (
        .D0 (rco), // feito
        .D1 (rco), // feito
        .D2 (~s_endereco[0] & s_endereco[1] & s_endereco[2] & s_endereco[3]), // feito
        .D3 (rco),
        .D4 (rco), // feito
        .D5 (rco), // feito
        .D6 (rco), // feito
        .D7 (rco),
        .D8 (rco), // feito
        .D9 (rco), // feito
        .D10(~s_endereco[0] & s_endereco[1] & s_endereco[2] & s_endereco[3]), // feito
        .D11(rco),
        .SEL (s_seletor_final),
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
        .ld    (~carregaS),
        .ent   (1'b1),
        .enp   (contaS),
        .D     (s_quant_inicial),
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
    mux4x2_n #( .BITS(4) ) mux_seq (
      .D0(s_mem1),
      .D1(s_mem2),
      .D2(s_mem3),
      .D3(s_mem4),
      .SEL(seletor_memoria),
      .OUT(s_dado)
    );

    mux2x1_n #( .BITS(1) ) mux_escrita (
      .D0(1'b0),
      .D1(quer_escrever),
      .SEL(&seletor_memoria),
      .OUT(vai_escrever)
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

    // memória 4
    sync_ram_16x4_file memoria4 (
    	.clk  (clock),
    	.we   (ram_escreve),
    	.data (botoes),
    	.addr (s_endereco),
    	.q    (s_mem4)
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
        .zera_as (zeraR),
        .zera_s  (zeraT),
        .conta   (contaT),
        .Q       (),
        .fim     (fim_5s),
        .meio    (fim_dois_e_meios)
    );

    contador_m #(.M(20000), .N(15)) contador_timeout_jogadas_facil (
        .clock   (clock),
        .zera_as (zeraR),
        .zera_s  (zeraT),
        .conta   (contaT),
        .Q       (),
        .fim     (fim_20s),
        .meio    (fim_10s)
    );

    contador_m #(.M(500), .N(9)) contador_timeout_leds (
        .clock   (clock),
        .zera_as (zeraR),
        .zera_s  (zeraT_leds),
        .conta   (contaT_leds),
        .Q       (),
        .fim     (controle_timeout_led),
        .meio    ()
    );

    contador_m #(.M(4), .N(2)) contador_jogadas (
        .clock   (clock),
        .zera_as (zeraR), // precisa ser um zera diferente
        .zera_s  (zeraJ),
        .conta   (contaJ), // precisa ser um zera diferente
        .Q       (s_contagem),
        .fim     (),
        .meio    ()
    );

        // contador métricas ganhar
    contador_163 contGanha (
        .clock (clock),
        .clr   (~zera_metricas),
        .ld    (1'b1),
        .ent   (1'b1),
        .enp   (conta_ganhar),
        .D     (4'b0),
        .Q     (ganhos),
        .rco   ()
    );

    // contador métricas perder
    contador_163 contPerde (
        .clock (clock),
        .clr   (~zera_metricas),
        .ld    (1'b1),
        .ent   (1'b1),
        .enp   (conta_perder),
        .D     (4'b0),
        .Q     (perdas),
        .rco   ()
    );

    assign db_memoria  = s_dado;
    assign db_contagem = s_endereco;
    assign db_sequencia = s_sequencia;
    assign db_jogadafeita = s_botoes;
    assign db_seletor_memoria = seletor_memoria;
    assign db_contagem_jogo = s_contagem;
endmodule