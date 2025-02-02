//------------------------------------------------------------------
// Arquivo   : exp4_unidade_controle.v
// Projeto   : Experiencia 4 - Projeto de uma Unidade de Controle
//------------------------------------------------------------------
// Descricao : Unidade de controle
//
// usar este codigo como template (modelo) para codificar 
// máquinas de estado de unidades de controle            
//------------------------------------------------------------------
// Revisoes  :
//     Data        Versao  Autor                        Descricao
//     14/01/2024  1.0     Edson Midorikawa             versao inicial
//     12/01/2025  1.1     Edson Midorikawa             revisao
//     24/01/2025  1.2     Ana Murad, Heitor Gama       exercício
//------------------------------------------------------------------
//
module exp5_unidade_controle (
    input clock,
    input reset,
    input jogar,
    input fimE,
    input jogada,
    input igualE,
    input igualL,
    input timeout,
    input fimL,
    output reg zeraE,
    output reg contaE,
    output reg zeraL,
    output reg contaL,
    output reg zeraR,
    output reg registraR,
    output reg ganhou,
    output reg perdeu,
    output reg pronto,
    output reg [3:0] db_estado,
    output reg deu_timeout,
    output reg contaT
);

    // Define estados
    parameter inicial     = 4'b0000;  // 0
    parameter preparacao  = 4'b0001;  // 1
    parameter nova_seq    = 4'b0010;  // 2
    parameter espera      = 4'b0011;  // 3
    parameter registra    = 4'b0100;  // 4
    parameter comparacao  = 4'b0101;  // 5
    parameter proximo     = 4'b0110;  // 6
    parameter fim_erro    = 4'b1110;  // E
    parameter fim_acerto  = 4'b1010;  // A
    parameter fim_timeout = 4'b1101;  // D

    // Variaveis de estado
    reg [3:0] Eatual, Eprox;

    reg [10*8-1:0] Eatual_str;
    always@(Eatual) begin
        case(Eatual)
            inicial:     Eatual_str = "inicial";
            preparacao:  Eatual_str = "preparacao";
            nova_seq:    Eatual_str = "nova_seq";
            espera:      Eatual_str = "espera";
            registra:    Eatual_str = "registra";
            comparacao:  Eatual_str = "comparacao";
            proximo:     Eatual_str = "proximo";
            fim_acerto:  Eatual_str = "fim_acerto";
            fim_erro:    Eatual_str = "fim_erro";
            fim_timeout: Eatual_str = "fim_timeout";
            default:     Eatual_str = "UNKNOWN";
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
            inicial:     Eprox = jogar ? preparacao : inicial;
            preparacao:  Eprox = espera;
            nova_seq:    Eprox = espera;
            espera:      Eprox = timeout ? fim_timeout : (jogada ? registra : espera);
            registra:    Eprox = comparacao;
            comparacao:  Eprox = igualE ? (fimE ? fim_acerto : (igualL ? nova_seq : proximo)) : fim_erro;
            proximo:     Eprox = espera;
            fim_acerto:  Eprox = jogar ? preparacao : fim_acerto;
            fim_erro:    Eprox = jogar ? preparacao : fim_erro;
            fim_timeout: Eprox = jogar ? preparacao : fim_timeout;
            default:     Eprox = inicial;
        endcase
    end

    // Logica de saida (maquina Moore)
    always @* begin
        zeraE       = (Eatual == inicial || Eatual == preparacao || Eatual == nova_seq) ? 1'b1 : 1'b0;
        zeraR       = (Eatual == inicial) ? 1'b1 : 1'b0;
        registraR   = (Eatual == registra) ? 1'b1 : 1'b0;
        contaE      = (Eatual == proximo) ? 1'b1 : 1'b0;
        pronto      = (Eatual == fim_acerto || Eatual == fim_erro || Eatual == fim_timeout) ? 1'b1 : 1'b0;
        ganhou     = (Eatual == fim_acerto) ? 1'b1 : 1'b0;
        perdeu       = (Eatual == fim_erro || Eatual == fim_timeout) ? 1'b1 : 1'b0;
        deu_timeout = (Eatual == fim_timeout) ? 1'b1 : 1'b0;
        contaT      = (Eatual == espera) ? 1'b1: 1'b0;
        zeraL       = (Eatual == jogar || Eatual == preparacao) ? 1'b1 : 1'b0;
        contaL      = (Eatual == nova_seq) ? 1'b1 : 1'b0;

        // Saida de depuracao (estado)
        case (Eatual)
            inicial:     db_estado = 4'b0000;  // 0
            preparacao:  db_estado = 4'b0001;  // 1
            nova_seq:    db_estado = 4'b0010;  // 2
            espera:      db_estado = 4'b0011;  // 3
            registra:    db_estado = 4'b0100;  // 4
            comparacao:  db_estado = 4'b0101;  // 5
            proximo:     db_estado = 4'b0110;  // 6
            fim_acerto:  db_estado = 4'b1010;  // A
            fim_erro:    db_estado = 4'b1110;  // E
            fim_timeout: db_estado = 4'b1101;  // D (deu ruim)
            default:     db_estado = 4'b1111;  // F (F, deu ruim 2)
        endcase
    end
endmodule