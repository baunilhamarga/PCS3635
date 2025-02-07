//------------------------------------------------------------------
// Arquivo   : circuito_exp4.v
// Projeto   : Experiencia 4 - Desenvolvimento de Projeto de
//             Circuitos Digitais em FPGA 
//------------------------------------------------------------------
// Descricao : Circuito da Experiência 4
//             
//------------------------------------------------------------------
// Revisoes  :
//     Data        Versao  Autor             Descricao
//     25/01/2025  1.0     Ana Vitória       versao inicial
//------------------------------------------------------------------
//
module circuito_exp5_desafio (
    input clock,
    input reset,
    input jogar,
    input nivel,
    input [3:0] botoes,
    output ganhou,
    output perdeu,
    output pronto,
    output [3:0] leds,
    output db_igualL,
    output db_igualE,
    output [6:0] db_contagem,
    output [6:0] db_memoria,
    output [6:0] db_estado,
    output [6:0] db_jogadafeita,
    output db_clock,
    output db_tem_jogada,
    output db_timeout,
    output db_contaL,
    output [6:0] db_limite,
    output db_nivel
);
    wire [3:0] s_jogada;
    wire [3:0] s_contagem;
    wire [3:0] s_memoria;
    wire [3:0] s_estado;
    wire [3:0] s_limite;
    wire s_jogada_feita;
    wire s_fimE;
    wire s_fimL;
    wire s_menor;
    wire s_igualE;
    wire s_fim_timeout;
    wire s_contaT;
    wire s_contaL;
    wire s_zeraL;
    wire s_contaE;
    wire s_zeraE;
    wire s_igualL;
    wire s_zeraR;
    wire s_registraR;
    wire s_nivel;
	 wire s_zeraT;

    // Fluxo de Dados
    exp5_fluxo_dados FD (
        .clock                     ( clock          ),
        .botoes                    ( botoes         ),
        .nivel                     ( s_nivel        ),
		  .zeraT                    ( s_zeraT       ),
        .zeraR                     ( s_zeraR        ), // zera registradores
        .registraR                 ( s_registraR    ), // registra registradores
        .contaE                    ( s_contaE       ),
        .contaL                    ( s_contaL       ),
        .contaT                    ( s_contaT       ), // incrementa contagem
        .zeraE                     ( s_zeraE        ),
        .zeraL                     ( s_zeraL        ), // zera contagem
        .igual                     ( s_igualE       ),
        .enderecoIgualLimite       ( s_igualL       ),
        .enderecoMenorOuIguaLimite ( s_menor        ),
        .fimE                      ( s_fimE         ),
        .fimL                      ( s_fimL         ), // fim da contagem
        .db_contagem               ( s_contagem     ),
        .db_jogadafeita            ( s_jogada       ),
        .db_memoria                ( s_memoria      ),
        .db_tem_jogada             ( db_tem_jogada  ),
        .jogada_feita              ( s_jogada_feita ),
        .controle_timeout          ( s_fim_timeout  ),
        .db_limite                 ( s_limite       )               
    );

    // Unidade de Controle
    exp5_unidade_controle UC (
        .clock       ( clock          ),
        .timeout     ( s_fim_timeout  ),
        .reset       ( reset          ),
        .nivel       ( nivel          ),
        .jogar       ( jogar          ),
        .fimE        ( s_fimE         ),
        .fimL        ( s_fimL         ),
        .igualE      ( s_igualE       ),
        .igualL      ( s_igualL       ),
        .jogada      ( s_jogada_feita ),
        .zeraE       ( s_zeraE        ),
        .contaE      ( s_contaE       ),
        .zeraL       ( s_zeraL        ),
        .contaL      ( s_contaL       ),
        .zeraR       ( s_zeraR        ),
        .registraR   ( s_registraR    ),
        .pronto      ( pronto         ),
        .db_estado   ( s_estado       ),
        .ganhou      ( ganhou         ),
        .perdeu      ( perdeu         ),
        .deu_timeout ( db_timeout     ),
        .contaT      ( s_contaT       ),
        .nivel_uc    ( s_nivel        ),
		  .zeraT      ( s_zeraT       )
    );

    // Display das botoes
    hexa7seg HEX2 (
        .hexa    ( s_jogada  ),
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
        .hexa    ( s_limite  ),
        .display ( db_limite )
    );

    assign db_contaL = s_contaL;
    assign db_igualE = s_igualE;
    assign db_igualL = s_igualL;
    assign leds = s_jogada;
    assign db_clock = clock;
    assign db_nivel = s_nivel;
endmodule