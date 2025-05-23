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
module circuito_exp4_desafio (
    input clock,
    input reset,
    input iniciar,
    input [3:0] chaves,
    output acertou,
    output errou,
    output pronto,
    output [3:0] leds,
    output db_igual,
    output [6:0] db_contagem,
    output [6:0] db_memoria,
    output [6:0] db_estado,
    output [6:0] db_jogadafeita,
    output db_clock,
    output db_iniciar,
    output db_tem_jogada,
    output db_timeout
);
    wire [3:0] s_jogada;
    wire [3:0] s_contagem;
    wire [3:0] s_memoria;
    wire [3:0] s_estado;
    wire s_jogada_feita;
    wire s_fimC;
    wire s_igual;
    wire s_fim_timeout;
    wire s_contaT;

    // Fluxo de Dados
    exp4_fluxo_dados FD (
        .estado             ( s_estado       ),
        .clock              ( clock          ),
        .chaves             ( chaves         ),
        .zeraR              ( s_zeraR        ), // zera registradores
        .registraR          ( s_registraR    ), // registra registradores
        .contaC             ( s_contaC       ),
        .contaT             ( s_contaT       ), // incrementa contagem
        .zeraC              ( s_zeraC        ), // zera contagem
        .igual              ( s_igual        ),
        .fimC               ( s_fimC         ), // fim da contagem
        .db_contagem        ( s_contagem     ),
        .db_jogadafeita     ( s_jogada       ),
        .db_memoria         ( s_memoria      ),
        .db_tem_jogada      ( db_tem_jogada  ),
        .jogada_feita       ( s_jogada_feita ),
        .controle_timeout   ( s_fim_timeout  )
    );

    // Unidade de Controle
    exp4_unidade_controle UC (
        .clock       ( clock          ),
        .timeout     ( s_fim_timeout  ),
        .reset       ( reset          ),
        .iniciar     ( iniciar        ),
        .fim         ( s_fimC         ),
        .igual       ( s_igual        ),
        .jogada      ( s_jogada_feita ),
        .zeraC       ( s_zeraC        ),
        .contaC      ( s_contaC       ),
        .zeraR       ( s_zeraR        ),
        .registraR   ( s_registraR    ),
        .pronto      ( pronto         ),
        .db_estado   ( s_estado       ),
        .acertou     ( acertou        ),
        .errou       ( errou          ),
        .deu_timeout ( db_timeout     ),
        .contaT      ( s_contaT       )
    );

    // Display das chaves
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

    assign db_iniciar = iniciar;
    assign db_igual = s_igual;
    assign leds = s_jogada;
    assign db_clock = clock;
endmodule