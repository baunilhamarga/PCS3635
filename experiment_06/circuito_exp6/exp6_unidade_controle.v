//------------------------------------------------------------------
// Arquivo   : exp6_unidade_controle.v
// Projeto   : Experiencia 6 - Jogo da Memória
//------------------------------------------------------------------
// Descricao : Unidade de controle
//         
//------------------------------------------------------------------
// Revisoes  :
//     Data        Versao  Autor                        Descricao
//     14/01/2024  1.0     Edson Midorikawa             versao inicial
//     12/01/2025  1.1     Edson Midorikawa             revisao
//     24/01/2025  1.2     Ana Murad, Heitor Gama       exercício
//------------------------------------------------------------------
//
module exp6_unidade_controle (
    input clock,
    input reset,
    input jogar,
    input nivel,
    input fimE,
    input igualE,
    input igualS,
    input tem_jogada,
    input timeout,
    input timeoutL,
    input menorS,
    output reg zeraE,
    output reg contaE,
    output reg zeraS,
    output reg contaS,
    output reg zeraR,
    output reg registraR,
    output reg ganhou,
    output reg perdeu,
    output reg pronto,
    output reg [3:0] db_estado,
    output reg deu_timeout,
    output reg contaT,
    output reg nivel_uc,
    output reg zeraT,
    output reg controla_leds,
    output reg zeraT_leds,
    output reg contaT_leds
);

    // Define estados
    parameter inicial        = 4'b0000;  // 0
    parameter preparacao     = 4'b0001;  // 1
    parameter nova_seq       = 4'b0010;  // 2
    parameter mostra_leds    = 4'b1011;  // B
    parameter mostrou_led    = 4'b1100;  // C
    parameter espera_led     = 4'b0111;  // 7
    parameter zera_timeout   = 4'b1000;  // 8
    parameter comecar_rodada = 4'b1101;  // D
    parameter espera         = 4'b0011;  // 3
    parameter registra       = 4'b0100;  // 4
    parameter comparacao     = 4'b0101;  // 5
    parameter proximo        = 4'b0110;  // 6
    parameter fim_erro       = 4'b1110;  // E
    parameter fim_acerto     = 4'b1010;  // A
    parameter fim_timeout    = 4'b1111;  // F

    // Variaveis de estado
    reg [3:0] Eatual, Eprox;

    reg [10*8-1:0] Eatual_str;
    always@(Eatual) begin
        case(Eatual)
            inicial:        Eatual_str = "inicial";
            preparacao:     Eatual_str = "preparacao";
            nova_seq:       Eatual_str = "nova_seq";
            mostra_leds:    Eatual_str = "mostra_leds";
            mostrou_led:    Eatual_str = "mostrou_leds";
            espera_led:     Eatual_str = "espera_leds";
            zera_timeout:   Eatual_str = "zera_timeout";
            comecar_rodada: Eatual_str = "comecar_rodada";
            espera:         Eatual_str = "espera";
            registra:       Eatual_str = "registra";
            comparacao:     Eatual_str = "comparacao";
            proximo:        Eatual_str = "proximo";
            fim_acerto:     Eatual_str = "fim_acerto";
            fim_erro:       Eatual_str = "fim_erro";
            fim_timeout:    Eatual_str = "fim_timeout";
            default:        Eatual_str = "UNKNOWN";
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
            inicial:        Eprox = jogar ? preparacao : inicial;
            preparacao:     Eprox = mostra_leds;
            nova_seq:       Eprox = mostra_leds;
            mostra_leds:    Eprox = menorS ? comecar_rodada : (timeoutL ? (fimE ? comecar_rodada : mostrou_led) : mostra_leds);
            mostrou_led:    Eprox = espera_led;
            espera_led:     Eprox = timeoutL ? zera_timeout : espera_led;
            zera_timeout:   Eprox = mostra_leds;
            comecar_rodada: Eprox = espera;
            espera:         Eprox = timeout ? fim_timeout : (tem_jogada ? registra : espera);
            registra:       Eprox = comparacao;
            comparacao:     Eprox = igualE ? (fimE ? fim_acerto : (igualS ? nova_seq : proximo)) : fim_erro;
            proximo:        Eprox = espera;
            fim_acerto:     Eprox = jogar ? preparacao : fim_acerto;
            fim_erro:       Eprox = jogar ? preparacao : fim_erro;
            fim_timeout:    Eprox = jogar ? preparacao : fim_timeout;
            default:        Eprox = inicial;
        endcase
    end

    // Logica de saida (maquina Moore)
    always @* begin
        zeraE         = (Eatual == inicial || Eatual == preparacao || Eatual == nova_seq || Eatual == comecar_rodada) ? 1'b1 : 1'b0;
        zeraR         = (Eatual == inicial) ? 1'b1 : 1'b0;
        registraR     = (Eatual == registra) ? 1'b1 : 1'b0;
        contaE        = (Eatual == proximo || Eatual == mostrou_led) ? 1'b1 : 1'b0;
        pronto        = (Eatual == fim_acerto || Eatual == fim_erro || Eatual == fim_timeout) ? 1'b1 : 1'b0;
        ganhou        = (Eatual == fim_acerto) ? 1'b1 : 1'b0;
        perdeu        = (Eatual == fim_erro || Eatual == fim_timeout) ? 1'b1 : 1'b0;
        deu_timeout   = (Eatual == fim_timeout) ? 1'b1 : 1'b0;
        contaT        = (Eatual == espera) ? 1'b1: 1'b0;
        zeraS         = (Eatual == preparacao) ? 1'b1 : 1'b0;
        contaS        = (Eatual == nova_seq) ? 1'b1 : 1'b0;
        nivel_uc      = (Eatual == preparacao) ? nivel : nivel_uc;
		zeraT         = (Eatual == proximo || Eatual == nova_seq) ? 1'b1 : 1'b0;
        controla_leds = (Eatual == mostra_leds) ? 1'b1 : 1'b0;
        zeraT_leds    = (Eatual == mostrou_led || Eatual == comecar_rodada || Eatual == zera_timeout) ? 1'b1 : 1'b0;
        contaT_leds   = (Eatual == mostra_leds || Eatual == espera_led) ? 1'b1 : 1'b0;

        // Saida de depuracao (estado)
        case (Eatual)
            inicial:        db_estado = 4'b0000;  // 0
            preparacao:     db_estado = 4'b0001;  // 1
            nova_seq:       db_estado = 4'b0010;  // 2
            mostra_leds:    db_estado = 4'b1011;  // B
            mostrou_led:    db_estado = 4'b1100;  // C
            espera_led:     db_estado = 4'b0111;  // 7
            zera_timeout:   db_estado = 4'b1000;  // 8
            comecar_rodada: db_estado = 4'b1101;  // D
            espera:         db_estado = 4'b0011;  // 3
            registra:       db_estado = 4'b0100;  // 4
            comparacao:     db_estado = 4'b0101;  // 5
            proximo:        db_estado = 4'b0110;  // 6
            fim_acerto:     db_estado = 4'b1010;  // A
            fim_erro:       db_estado = 4'b1110;  // E
            fim_timeout:    db_estado = 4'b1111;  // F (deu ruim)
            default:        db_estado = 4'b1001;  // 9
        endcase
    end
endmodule