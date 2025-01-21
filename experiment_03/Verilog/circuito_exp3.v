module circuito_exp3 (
    input clock,
    input reset,
    input iniciar,
    input [3:0] chaves,
    output pronto,
    output db_igual,
    output db_iniciar,
    output [6:0] db_contagem,
    output [6:0] db_memoria,
    output [6:0] db_chaves,
    output [6:0] db_estado,
	 output db_zeraC,
	 output db_contaC,
	 output db_fimC,
	 output db_zeraR,
	 output db_registraR
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

    // Fluxo de Dados
    exp3_fluxo_dados FD (
        .clock              ( clock       ),
        .chaves             ( chaves      ),
        .zeraR              ( s_zeraR     ), // zera registradores
        .registraR          ( s_registraR ), // registra nos registradores
        .contaC             ( s_contaC    ), // incrementa contagem
        .zeraC              ( s_zeraC     ), // zera contagem
        .chavesIgualMemoria ( db_igual    ),
        .fimC               ( s_fimC      ),
        .db_contagem        ( s_contagem  ),
        .db_chaves          ( s_chaves    ),
        .db_memoria         ( s_memoria   )
    );

    // Unidade de Controle
    exp3_unidade_controle UC (
        .clock     ( clock       ),
        .reset     ( reset       ),
        .iniciar   ( iniciar     ),
        .fimC      ( s_fimC      ), // fim da contagem
        .zeraC     ( s_zeraC     ),
        .contaC    ( s_contaC    ),
        .zeraR     ( s_zeraR     ),
        .registraR ( s_registraR ),
        .pronto    ( pronto      ),
        .db_estado ( s_estado    )
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
	 assign db_zeraC = s_zeraC;
	 assign db_contaC = s_contaC;
	 assign db_fimC = s_fimC;
	 assign db_zeraR = s_zeraR;
	 assign db_registraR = s_registraR;
endmodule