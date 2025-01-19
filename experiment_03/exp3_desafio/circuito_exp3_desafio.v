module circuito_exp3_desafio (
 input clock,
 input reset,
 input iniciar,
 input [3:0] chaves,
 output pronto,
 output acertou,
 output errou,
 output db_igual,
 output db_iniciar,
 output [6:0] db_contagem,
 output [6:0] db_memoria,
 output [6:0] db_chaves,
 output [6:0] db_estado
);
    wire [3:0] s_chaves;
    wire [3:0] s_contagem;
    wire [3:0] s_memoria;
    wire [3:0] s_estado;
    wire s_fimC;
    wire s_contaC;
    wire s_registraR;
    wire s_zeraC;
    wire s_zeraR;
    wire s_igual;

    // Fluxo de Dados
    exp3_fluxo_dados FD (
        .clock              ( clock       ),
        .chaves             ( chaves      ),
        .zeraR              ( s_zeraR     ), // zera registradores
        .registraR          ( s_registraR ), // registra registradores
        .contaC             ( s_contaC    ), // incrementa contagem
        .zeraC              ( s_zeraC     ), // zera contagem
        .chavesIgualMemoria ( s_igual     ),
        .fimC               ( s_fimC      ), // fim da contagem
        .db_contagem        ( s_contagem  ),
        .db_chaves          ( s_chaves    ),
        .db_memoria         ( s_memoria   )
    );

    // Unidade de Controle
    exp3_unidade_controle UC (
        .clock     ( clock       ),
        .reset     ( reset       ),
        .iniciar   ( iniciar     ),
        .fimC      ( s_fimC      ),
        .resultado ( ~s_igual    ),
        .zeraC     ( s_zeraC     ),
        .contaC    ( s_contaC    ),
        .zeraR     ( s_zeraR     ),
        .registraR ( s_registraR ),
        .pronto    ( pronto      ),
        .db_estado ( s_estado    ),
        .acertou   ( acertou     ),
        .errou     ( errou       )
    );

    // Display das chaves
    hexa7seg HEX2 (
        .hexa    ( s_chaves  ),
        .display ( db_chaves )
    );

    // Display dos endereços codificados
    hexa7seg HEX0 (
        .hexa    ( s_contagem ),
        .display ( db_contagem )
    );

    // Display do conteúdo em uma posição de memória
    hexa7seg HEX1 (
        .hexa    ( s_memoria  ),
        .display ( db_memoria )
    );

    // Display do estado atual
    hexa7seg HEX5 (
        .hexa    ( s_estado ),
        .display ( db_estado )
    );

    assign db_iniciar = iniciar;
    assign db_igual = s_igual;

endmodule