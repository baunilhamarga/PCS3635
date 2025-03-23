//------------------------------------------------------------------
// Arquivo   : jogo_playseq.v
// Projeto   : PlaySeq
//------------------------------------------------------------------
// Descricao : Circuito principal do jogo PlaySeq
//             
//------------------------------------------------------------------
// Revisoes  :
//     Data        Versao  Autor             Descricao
//     07/03/2025  1.0     Ana Vitória       versao inicial
//------------------------------------------------------------------
//
module jogo_playseq (
    input clockFPGA,
    input reset,
    input jogar,
    input [3:0] botoes,
    input [1:0] memoria,
    input [1:0] nivel,
    input [1:0] timeoutD,
    input quer_escrever,
    input ignora_timeout,
    output ganhou,
    output perdeu,
    output timeout,
    output pronto,
    output [3:0] leds,
    output buzzer,
    output db_clock,
    output db_tem_jogada,
    output db_chavesIgualMemoria,
    output db_enderecoIgualSequencia,
    output db_fimS,
    output [6:0] db_contagem,
    output [6:0] db_memoria,
    output [6:0] db_jogadafeita,
    output [6:0] db_sequencia,
    output [6:0] db_estado,
    output db_seletor_memoria,
    // Nossos debugs
    output db_pare,
    output [1:0] db_contagem_jogo,
    output [6:0] vitorias,
    output [6:0] derrotas
);

    wire [3:0] s_jogadafeita;
    wire [3:0] s_contagem;
    wire [3:0] s_memoria;
    wire [4:0] s_estado;
    wire [3:0] s_sequencia;
    wire s_tem_jogada;
    wire s_fimE;
    wire s_fimS;
    wire s_igualE;
    wire s_fim_timeout;
    wire s_contaT;
    wire s_contaS;
    wire s_zeraS;
    wire s_contaE;
    wire s_zeraE;
    wire s_igualS;
    wire s_zeraR;
    wire s_registraR;
    wire [1:0] s_nivel_uc;
    wire s_zeraT;
    wire s_timeoutL;
    wire s_menorS;
    wire s_controla_leds;
    wire s_zeraT_leds;
    wire s_contaT_leds;
    wire s_fase_preview;
    wire [1:0] s_memoria_uc;
    wire s_carregaS;
    wire s_pare;
    wire s_contaJ;
    wire s_zeraJ;
    wire [1:0] s_contagem_jogo;
    wire s_vai_escrever;
    wire s_ram_escreve;
    wire s_conta_ganhar;
    wire s_conta_perder;
    wire s_zera_metricas;
    wire [3:0] s_vitorias;
    wire [3:0] s_derrotas;
    wire clock;

    // Clock de 50 MHz para 1 KHz
    clock_div divisor (
        .clock_in(clockFPGA),
        .clock_out(clock)
    );

    // Fluxo de Dados
    playseq_fluxo_dados FD (
        .clockFPGA                 ( clockFPGA          ),
        .clock                     ( clock              ),
        .botoes                    ( botoes             ),
        .nivel                     ( s_nivel_uc         ),
        .zeraT                     ( s_zeraT            ),
        .zeraR                     ( s_zeraR            ),
        .registraR                 ( s_registraR        ),
        .contaE                    ( s_contaE           ),
        .contaS                    ( s_contaS           ),
        .contaT                    ( s_contaT           ),
        .contaJ                    ( s_contaJ           ),
        .zeraE                     ( s_zeraE            ),
        .zeraS                     ( s_zeraS            ),
        .zeraJ                     ( s_zeraJ            ),
        .carregaS                  ( s_carregaS         ),
        .controla_leds             ( s_controla_leds    ),
        .zeraT_leds                ( s_zeraT_leds       ),
        .contaT_leds               ( s_contaT_leds      ),
        .fase_preview              ( s_fase_preview     ),
        .seletor_memoria           ( s_memoria_uc       ),
        .ram_escreve               ( s_ram_escreve      ),
        .quer_escrever             ( quer_escrever      ),
        .timeoutD                  ( timeoutD           ),
        .conta_ganhar              ( s_conta_ganhar     ),
        .conta_perder              ( s_conta_perder     ),
        .zera_metricas             ( s_zera_metricas    ),
        .ignora_timeout            ( ignora_timeout     ),
        .igual                     ( s_igualE           ),
        .enderecoIgualSequencia    ( s_igualS           ),
        .fimE                      ( s_fimE             ),
        .fimS                      ( s_fimS             ),
        .db_contagem               ( s_contagem         ),
        .db_jogadafeita            ( s_jogadafeita      ),
        .db_memoria                ( s_memoria          ),
        .tem_jogada                ( s_tem_jogada       ),
        .controle_timeout          ( s_fim_timeout      ),
        .db_sequencia              ( s_sequencia        ),
        .controle_timeout_led      ( s_timeoutL         ),
        .sequenciaMenorQueEndereco ( s_menorS           ),
        .leds                      ( leds               ),
        .buzzer                    ( buzzer             ),
        .db_seletor_memoria        ( db_seletor_memoria ),
        .pare                      ( s_pare             ),
        .db_contagem_jogo          ( s_contagem_jogo    ),
        .vai_escrever              ( s_vai_escrever     ),
        .ganhos                    ( s_vitorias         ),
        .perdas                    ( s_derrotas         )
    );

    // Unidade de Controle
    playseq_unidade_controle UC (
        .clock         ( clock          ),
        .reset         ( reset          ),
        .jogar         ( jogar          ),
        .nivel         ( nivel          ),
        .fimE          ( s_fimE         ),
        .igualE        ( s_igualE       ),
        .igualS        ( s_igualS       ),
        .tem_jogada    ( s_tem_jogada   ),
        .timeout       ( s_fim_timeout  ),
        .timeoutL      ( s_timeoutL     ),
        .menorS        ( s_menorS       ),
        .memoria       ( memoria        ),
        .pare          ( s_pare         ),
        .vai_escrever  ( s_vai_escrever ),
        .zeraE         ( s_zeraE        ),
        .contaE        ( s_contaE       ),
        .carregaS      ( s_carregaS     ),
        .zeraS         ( s_zeraS        ),
        .contaS        ( s_contaS       ),
        .zeraR         ( s_zeraR        ),
        .registraR     ( s_registraR    ),
        .zeraJ         ( s_zeraJ        ),
        .contaJ        ( s_contaJ       ),
        .ganhou        ( ganhou         ),
        .perdeu        ( perdeu         ),
        .pronto        ( pronto         ),
        .db_estado     ( s_estado       ),
        .deu_timeout   ( timeout        ),
        .contaT        ( s_contaT       ),
        .nivel_uc      ( s_nivel_uc     ),
        .zeraT         ( s_zeraT        ),
        .controla_leds ( s_controla_leds),
        .zeraT_leds    ( s_zeraT_leds   ),
        .contaT_leds   ( s_contaT_leds  ),
        .fase_preview  ( s_fase_preview ),
        .memoria_uc    ( s_memoria_uc   ),
        .ram_escreve   ( s_ram_escreve  ),
        .conta_ganhar  ( s_conta_ganhar ),
        .conta_perder  ( s_conta_perder ),
        .zera_metricas ( s_zera_metricas)
    );

    // Display das botoes
    hexa7seg HEX2 (
        .hexa    ( s_jogadafeita  ),
        .display ( db_jogadafeita )
    );

    // Display dos endereços codificados
    hexa7seg HEX0 (
        .hexa    ( s_contagem  ),
        .display ( db_contagem )
    );

    // Display do conteúdo em uma posição de memória
    hexa7seg HEX1 (
        .hexa    ( s_memoria  ),
        .display ( db_memoria )
    );

    // Display do estado atual
    hexa7seg5b HEX5 (
        .hexa    ( s_estado  ),
        .display ( db_estado )
    );

    // Display da sequência atual
    hexa7seg HEX3 (
        .hexa    ( s_sequencia  ),
        .display ( db_sequencia )
    );

    // Display de vitórias
    hexa7seg HEX4 (
        .hexa    ( s_vitorias  ),
        .display ( vitorias )
    );

    // Display de derrotas
    hexa7seg HEX6 (
        .hexa    ( s_derrotas  ),
        .display ( derrotas )
    );

    assign db_chavesIgualMemoria = s_igualE;
    assign db_enderecoIgualSequencia = s_igualS;
    assign db_fimS = s_fimS;
    assign db_tem_jogada = s_tem_jogada;
    assign db_clock = clock;
    assign db_pare = s_pare;
    assign db_contagem_jogo = s_contagem_jogo;
endmodule