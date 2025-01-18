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
 output [6:0] db_estado
);

// Fluxo de Dados
exp3_fluxo_dados FD (
    .clock()
    .chaves()
    .zeraR()
    .registraR()
    .contaC()
    .zeraC()
    .chavesIgualMemoria()
    .fimC()
    .db_contagem()
    .db_chaves()
    .db_memoria()
);

exp3_unidade_controle UC (
    .clock()
    .reset()
    .iniciar()
    .fimC()
    .zeraC()
    .contaC()
    .zeraR()
    .registraR()
    .pronto()
    .db_estado()
);

hexa7seg HEX2 (
    .hexa()
    .display()
);

hexa7seg HEX0 (
    .hexa()
    .display()
);

hexa7seg HEX1 (
    .hexa()
    .display()
);

hexa7seg HEX5 (
    .hexa()
    .display()
);

endmodule