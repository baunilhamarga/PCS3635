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
module exp4_unidade_controle (
    input clock,
    input reset,
    input iniciar,
    input fim,
    input jogada,
    input igual,
    output reg zeraC,
    output reg contaC,
    output reg zeraR,
    output reg registraR,
    output reg acertou,
    output reg errou,
    output reg pronto,
    output reg [3:0] db_estado
);

    // Define estados
    parameter [3:0] inicial    = 4'b0000;  // 0
    parameter preparacao = 4'b0001;  // 1
    parameter espera     = 4'b0011;  // 3
    parameter registra   = 4'b0100;  // 4
    parameter comparacao = 4'b0101;  // 5
    parameter proximo    = 4'b0110;  // 6
    parameter fim_erro   = 4'b1110;  // E
    parameter fim_acerto = 4'b1010;  // A

    // Variaveis de estado
    reg [3:0] Eatual, Eprox;

    reg [10*8-1:0] Eatual_str;
    always@(Eatual) begin
        case(Eatual)
            inicial:     Eatual_str = "inicial";
            preparacao:  Eatual_str = "preparacao";
            espera:      Eatual_str = "espera";
            registra:    Eatual_str = "registra";
            comparacao:  Eatual_str = "comparacao";
            proximo:     Eatual_str = "proximo";
            fim_acerto:  Eatual_str = "fim_acerto";
            fim_erro:    Eatual_str = "fim_erro";
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
            inicial:     Eprox = iniciar ? preparacao : inicial;
            preparacao:  Eprox = espera;
            espera:      Eprox = jogada ? registra : espera;
            registra:    Eprox = comparacao;
            comparacao:  Eprox = igual ? (fim ? fim_acerto : proximo) : fim_erro;
            proximo:     Eprox = espera;
            fim_acerto:  Eprox = iniciar ? preparacao : fim_acerto;
            fim_erro:    Eprox = iniciar ? preparacao : fim_erro;
            default:     Eprox = inicial;
        endcase
    end

    // Logica de saida (maquina Moore)
    always @* begin
        zeraC     = (Eatual == inicial || Eatual == preparacao) ? 1'b1 : 1'b0;
        zeraR     = (Eatual == inicial) ? 1'b1 : 1'b0;
        registraR = (Eatual == registra) ? 1'b1 : 1'b0;
        contaC    = (Eatual == proximo) ? 1'b1 : 1'b0;
        pronto    = (Eatual == fim_acerto || Eatual == fim_erro) ? 1'b1 : 1'b0;
        acertou   = (Eatual == fim_acerto) ? 1'b1 : 1'b0;
        errou     = (Eatual == fim_erro) ? 1'b1 : 1'b0;

        // Saida de depuracao (estado)
        case (Eatual)
            inicial:     db_estado = 4'b0000;  // 0
            preparacao:  db_estado = 4'b0001;  // 1
            espera:      db_estado = 4'b0011;  // 3
            registra:    db_estado = 4'b0100;  // 4
            comparacao:  db_estado = 4'b0101;  // 5
            proximo:     db_estado = 4'b0110;  // 6
            fim_acerto:  db_estado = 4'b1010;  // A
            fim_erro:    db_estado = 4'b1110;  // E
            default:     db_estado = 4'b1111;  // F (deu ruim)
        endcase
    end

endmodule