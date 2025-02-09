//------------------------------------------------------------------
// Arquivo   : jogo_desafio_memoria.v
// Projeto   : Experiencia 6 - Jogo da Memória
//------------------------------------------------------------------
// Descricao : Circuito da Experiência 6
//             
//------------------------------------------------------------------
// Revisoes  :
//     Data        Versao  Autor             Descricao
//     25/01/2025  1.0     Ana Vitória       versao inicial
//------------------------------------------------------------------
//
module jogo_desafio_memoria (
    input clock,
    input reset,
    input jogar,
    input [3:0] botoes,
    output ganhou,
    output perdeu,
    output timeout,
    output pronto,
    output [3:0] leds,
    output db_clock, //
    output db_tem_jogada,
    output db_chavesIgualMemoria,
    output db_enderecoIgualSequencia,
    output db_fimS, //
    output [6:0] db_contagem,
    output [6:0] db_memoria,
    output [6:0] db_jogadafeita,
    output [6:0] db_sequencia,
    output [6:0] db_estado
);

    wire [3:0] s_jogadafeita;
    wire [3:0] s_contagem;
    wire [3:0] s_memoria;
    wire [3:0] s_estado;
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
    wire s_nivel;
	wire s_zeraT;
    wire s_timeoutL;
    wire s_menorS;
    wire nivel;

    // Fluxo de Dados
    exp6_fluxo_dados FD (
        .clock                     ( clock          ),
        .botoes                    ( botoes         ),
        .nivel                     ( s_nivel        ),
        .zeraT                     ( s_zeraT        ),
        .zeraR                     ( s_zeraR        ),
        .registraR                 ( s_registraR    ),
        .contaE                    ( s_contaE       ),
        .contaS                    ( s_contaS       ),
        .contaT                    ( s_contaT       ),
        .zeraE                     ( s_zeraE        ),
        .zeraS                     ( s_zeraS        ),
        .igual                     ( s_igualE       ),
        .enderecoIgualSequencia    ( s_igualS       ),
        .fimE                      ( s_fimE         ),
        .fimS                      ( s_fimS         ),
        .db_contagem               ( s_contagem     ),
        .db_jogadafeita           ( s_jogadafeita ),
        .db_memoria                ( s_memoria      ),
        .tem_jogada              ( s_tem_jogada   ),
        .controle_timeout          ( s_fim_timeout  ),
        .db_sequencia              ( s_sequencia    ),
        .controle_timeout_led      ( s_timeoutL     ),
        .sequenciaMenorQueEndereco ( s_menorS       )
    );

    // Unidade de Controle
    exp6_unidade_controle UC (
        .clock       ( clock          ),
        .reset       ( reset          ),
        .jogar       ( jogar          ),
        .nivel       ( nivel          ),
        .fimE        ( s_fimE         ),
        .igualE      ( s_igualE       ),
        .igualS      ( s_igualS       ),
        .tem_jogada  ( s_tem_jogada   ),
        .timeout     ( s_fim_timeout  ),
        .timeoutL    ( s_timeoutL     ),
        .menorS      ( s_menorS       ),
        .memoria     ( s_memoria      ),
        .zeraE       ( s_zeraE        ),
        .contaE      ( s_contaE       ),
        .zeraS       ( s_zeraS        ),
        .contaS      ( s_contaS       ),
        .zeraR       ( s_zeraR        ),
        .registraR   ( s_registraR    ),
        .ganhou      ( ganhou         ),
        .perdeu      ( perdeu         ),
        .pronto      ( pronto         ),
        .db_estado   ( s_estado       ),
        .deu_timeout ( timeout        ),
        .contaT      ( s_contaT       ),
        .nivel_uc    ( s_nivel        ),
        .zeraT       ( s_zeraT        ),
        .leds        ( leds           )
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
    hexa7seg HEX5 (
        .hexa    ( s_estado  ),
        .display ( db_estado )
    );

    // Display da sequência atual
    hexa7seg HEX3 (
        .hexa    ( s_sequencia  ),
        .display ( db_sequencia )
    );

assign db_chavesIgualMemoria = s_igualE;
assign db_enderecoIgualSequencia = s_igualS;
assign db_fimS = s_fimS;
assign db_tem_jogada = s_tem_jogada;
assign db_clock = clock;
assign nivel = 1'b1;

endmodule