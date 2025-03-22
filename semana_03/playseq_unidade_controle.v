//------------------------------------------------------------------
// Arquivo   : playseq_unidade_controle.v
// Projeto   : PlaySeq
//------------------------------------------------------------------
// Descricao : Unidade de controle do Jogo PlaySeq
//         
//------------------------------------------------------------------
// Revisoes  :
//     Data        Versao  Autor         Descricao
//     07/03/2024  1.0     Ana Vitória   versao inicial
//------------------------------------------------------------------
//

module playseq_unidade_controle (
    input clock,
    input reset,
    input jogar,
    input [1:0] nivel,
    input fimE,
    input igualE,
    input igualS,
    input tem_jogada,
    input timeout,
    input timeoutL,
    input menorS,
    input [1:0] memoria,
    input pare,
    input vai_escrever,
    output reg zeraE,
    output reg contaE,
    output reg carregaS,
    output reg zeraS,
    output reg contaS,
    output reg zeraR,
    output reg registraR,
    output reg zeraJ,
    output reg contaJ,
    output reg ganhou,
    output reg perdeu,
    output reg pronto,
    output reg [4:0] db_estado,
    output reg deu_timeout,
    output reg contaT,
    output reg [1:0] nivel_uc,
    output reg zeraT,
    output reg controla_leds,
    output reg zeraT_leds,
    output reg contaT_leds,
    output reg fase_preview,
    output reg [1:0] memoria_uc,
    output reg ram_escreve,
    output reg conta_ganhar,
    output reg conta_perder,
    output reg zera_metricas
);

    // Define estados
    parameter inicial          = 5'b00000;  // 0
    parameter preparacao       = 5'b00001;  // 1
    parameter escreve          = 5'b01001;  // 9
    parameter espera_escrita   = 5'b10000;  // 10
    parameter zera_contador    = 5'b10010;  // 12
    parameter nova_seq         = 5'b00010;  // 2
    parameter mostra_leds      = 5'b01011;  // B
    parameter mostrou_led      = 5'b01100;  // C
    parameter espera_led       = 5'b00111;  // 7
    parameter zera_timeout     = 5'b01000;  // 8
    parameter comecar_rodada   = 5'b01101;  // D
    parameter espera           = 5'b00011;  // 3
    parameter registra         = 5'b00100;  // 4
    parameter comparacao       = 5'b00101;  // 5
    parameter proximo          = 5'b00110;  // 6
    parameter fim_erro         = 5'b01110;  // E
    parameter fim_acerto       = 5'b01010;  // A
    parameter fim_timeout      = 5'b01111;  // F
    parameter metricas_perder    = 5'b11111; // 1F
    parameter metricas_ganhar  = 5'b11010; // 1A

    // Variaveis de estado
    reg [4:0] Eatual, Eprox;

    reg [14*8-1:0] Eatual_str;
    always@(Eatual) begin
        case(Eatual)
            inicial:          Eatual_str = "inicial";
            preparacao:       Eatual_str = "preparacao";
            escreve:          Eatual_str = "escreve";
            espera_escrita:   Eatual_str = "espera_escrita";
            zera_contador:    Eatual_str = "zera_contador";
            nova_seq:         Eatual_str = "nova_seq";
            mostra_leds:      Eatual_str = "mostra_leds";
            mostrou_led:      Eatual_str = "mostrou_leds";
            espera_led:       Eatual_str = "espera_leds";
            zera_timeout:     Eatual_str = "zera_timeout";
            comecar_rodada:   Eatual_str = "comecar_rodada";
            espera:           Eatual_str = "espera";
            registra:         Eatual_str = "registra";
            comparacao:       Eatual_str = "comparacao";
            proximo:          Eatual_str = "proximo";
            fim_acerto:       Eatual_str = "fim_acerto";
            fim_erro:         Eatual_str = "fim_erro";
            fim_timeout:      Eatual_str = "fim_timeout";
            metricas_perder:  Eatual_str = "metricas_perder";
            metricas_ganhar:  Eatual_str = "metricas_ganhar";
            default:          Eatual_str = "UNKNOWN";
        endcase
    end

    // Memoria de estado
    always @(posedge clock or posedge reset) begin
        if (reset)
            Eatual <= inicial;
        else
            Eatual <= Eprox;
    end

    // Logica de proximo estado
    always @* begin
        case (Eatual)
            inicial:          Eprox = jogar ? preparacao : inicial;
            preparacao:       Eprox = vai_escrever? espera_escrita : mostra_leds;
            escreve:          Eprox = fimE ? zera_contador : espera_escrita;
            espera_escrita:   Eprox = tem_jogada ? escreve : espera_escrita;
            zera_contador:    Eprox = jogar ? mostra_leds : zera_contador;
            nova_seq:         Eprox = espera_led;
            mostra_leds:      Eprox = timeoutL ? (fimE ? comecar_rodada : mostrou_led) : mostra_leds;
            mostrou_led:      Eprox = espera_led;
            espera_led:       Eprox = menorS ? comecar_rodada : (timeoutL ? zera_timeout : espera_led);
            zera_timeout:     Eprox = mostra_leds;
            comecar_rodada:   Eprox = espera;
            espera:           Eprox = timeout ? fim_timeout : (tem_jogada ? registra : espera);
            registra:         Eprox = comparacao;
            comparacao:       Eprox = igualE ? (fimE ? fim_acerto : (pare ? nova_seq : proximo)) : fim_erro;
            proximo:          Eprox = espera;
            fim_acerto:       Eprox = jogar ? metricas_ganhar : fim_acerto;
            fim_erro:         Eprox = jogar ? metricas_perder : fim_erro;
            fim_timeout:      Eprox = jogar ? metricas_perder : fim_timeout;
            metricas_perder:  Eprox = preparacao;
            metricas_ganhar:  Eprox = preparacao;
            default:          Eprox = inicial;
        endcase
    end

    // Logica de saida (maquina Moore)
    always @* begin
        zeraE         = (Eatual == inicial || Eatual == nova_seq || Eatual == preparacao || Eatual == zera_contador) ? 1'b1 : 1'b0;
        zeraR         = (Eatual == inicial) ? 1'b1 : 1'b0;
        registraR     = (Eatual == registra) ? 1'b1 : 1'b0;
        contaE        = (Eatual == proximo || Eatual == mostrou_led || Eatual == escreve) ? 1'b1 : 1'b0;
        carregaS      = (Eatual == preparacao) ? 1'b1 : 1'b0;
        pronto        = (Eatual == fim_acerto || Eatual == fim_erro || Eatual == fim_timeout) ? 1'b1 : 1'b0;
        ganhou        = (Eatual == fim_acerto) ? 1'b1 : 1'b0;
        perdeu        = (Eatual == fim_erro || Eatual == fim_timeout) ? 1'b1 : 1'b0;
        deu_timeout   = (Eatual == fim_timeout) ? 1'b1 : 1'b0;
        contaT        = (Eatual == espera) ? 1'b1: 1'b0;
        zeraS         = (Eatual == inicial) ? 1'b1 : 1'b0;
        contaS        = (Eatual == nova_seq || Eatual == comparacao) ? 1'b1 : 1'b0;
        nivel_uc      = (Eatual == preparacao) ? nivel : nivel_uc;
		zeraT         = (Eatual == proximo || Eatual == nova_seq || Eatual == fim_acerto || Eatual == fim_erro || Eatual == fim_timeout) ? 1'b1 : 1'b0;
        controla_leds = (Eatual == mostra_leds) ? 1'b1 : 1'b0;
        zeraT_leds    = (Eatual == mostrou_led || Eatual == comecar_rodada || Eatual == zera_timeout) ? 1'b1 : 1'b0;
        contaT_leds   = (Eatual == mostra_leds || Eatual == espera_led) ? 1'b1 : 1'b0;
        fase_preview  = (Eatual == mostra_leds || Eatual == mostrou_led || Eatual == zera_timeout || Eatual == comecar_rodada) ? 1'b1 : 1'b0;
        memoria_uc    = (Eatual == preparacao) ? memoria : memoria_uc;
        contaJ        = (Eatual == proximo) ? 1'b1 : 1'b0;
        zeraJ         = (Eatual == nova_seq || Eatual == fim_acerto || Eatual == fim_erro || Eatual == fim_timeout) ? 1'b1 : 1'b0;
        ram_escreve   = (Eatual == escreve) ? 1'b1 : 1'b0;
        conta_ganhar  = (Eatual == metricas_ganhar) ? 1'b1 : 1'b0;
        conta_perder  = (Eatual == metricas_perder) ? 1'b1 : 1'b0;
        zera_metricas = (Eatual == inicial) ? 1'b1 : 1'b0;

        // Saida de depuracao (estado)
        case (Eatual)
            inicial:          db_estado = 5'b00000;  // 0
            preparacao:       db_estado = 5'b00001;  // 1
            escreve:          db_estado = 5'b01001;  // 9
            espera_escrita:   db_estado = 5'b10000;  // overflow
            zera_contador:    db_estado = 5'b10010;  // overflow3
            nova_seq:         db_estado = 5'b00010;  // 2
            mostra_leds:      db_estado = 5'b01011;  // B
            mostrou_led:      db_estado = 5'b01100;  // C
            espera_led:       db_estado = 5'b00111;  // 7
            zera_timeout:     db_estado = 5'b01000;  // 8
            comecar_rodada:   db_estado = 5'b01101;  // D
            espera:           db_estado = 5'b00011;  // 3
            registra:         db_estado = 5'b00100;  // 4
            comparacao:       db_estado = 5'b00101;  // 5
            proximo:          db_estado = 5'b00110;  // 6
            fim_acerto:       db_estado = 5'b01010;  // A
            fim_erro:         db_estado = 5'b01110;  // E
            fim_timeout:      db_estado = 5'b01111;  // F (deu ruim)
            metricas_perder:    db_estado = 5'b11111;  // 1F
            metricas_ganhar:  db_estado = 5'b11010;  // 1A
            default:          db_estado = 5'b00000;  // default
        endcase
    end
endmodule