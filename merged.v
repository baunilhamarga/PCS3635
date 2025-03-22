// --- Start of jogo_playseq.v ---
//------------------------------------------------------------------
// Arquivo   : jogo_playseq.v
// Projeto   : PlaySeq
//------------------------------------------------------------------
// Descricao : Circuito principal do jogo PlaySeq
//             
//------------------------------------------------------------------
// Revisoes  :
//     Data        Versao  Autor             Descricao
//     07/03/2025  1.0     Ana Vitória       versao inicial
//------------------------------------------------------------------
//
module jogo_playseq (
    input clock,
    input reset,
    input jogar,
    input [3:0] botoes,
    input [1:0] memoria,
    input [1:0] nivel,
    input [1:0] timeoutD,
    input quer_escrever,
    input ignora_timeout,
    output ganhou,
    output perdeu,
    output timeout,
    output pronto,
    output [3:0] leds,
    output db_clock,
    output db_tem_jogada,
    output db_chavesIgualMemoria,
    output db_enderecoIgualSequencia,
    output db_fimS,
    output [6:0] db_contagem,
    output [6:0] db_memoria,
    output [6:0] db_jogadafeita,
    output [6:0] db_sequencia,
    output [6:0] db_estado,
    output db_seletor_memoria,
    // Nossos debugs
    output db_pare,
    output [1:0] db_contagem_jogo,
    output [6:0] vitorias,
    output [6:0] derrotas 
);

    wire [3:0] s_jogadafeita;
    wire [3:0] s_contagem;
    wire [3:0] s_memoria;
    wire [4:0] s_estado;
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
    wire [1:0] s_nivel_uc;
    wire s_zeraT;
    wire s_timeoutL;
    wire s_menorS;
    wire s_controla_leds;
    wire s_zeraT_leds;
    wire s_contaT_leds;
    wire s_fase_preview;
    wire [1:0] s_memoria_uc;
    wire s_carregaS;
    wire s_pare;
    wire s_contaJ;
    wire s_zeraJ;
    wire [1:0] s_contagem_jogo;
    wire s_vai_escrever;
    wire s_ram_escreve;
    wire s_conta_ganhar;
    wire s_conta_perder;
    wire s_zera_metricas;
    wire [3:0] s_vitorias;
    wire [3:0] s_derrotas;

    // Fluxo de Dados
    playseq_fluxo_dados FD (
        .clock                     ( clock              ),
        .botoes                    ( botoes             ),
        .nivel                     ( s_nivel_uc         ),
        .zeraT                     ( s_zeraT            ),
        .zeraR                     ( s_zeraR            ),
        .registraR                 ( s_registraR        ),
        .contaE                    ( s_contaE           ),
        .contaS                    ( s_contaS           ),
        .contaT                    ( s_contaT           ),
        .contaJ                    ( s_contaJ           ),
        .zeraE                     ( s_zeraE            ),
        .zeraS                     ( s_zeraS            ),
        .zeraJ                     ( s_zeraJ            ),
        .carregaS                  ( s_carregaS         ),
        .controla_leds             ( s_controla_leds    ),
        .zeraT_leds                ( s_zeraT_leds       ),
        .contaT_leds               ( s_contaT_leds      ),
        .fase_preview              ( s_fase_preview     ),
        .seletor_memoria           ( s_memoria_uc       ),
        .ram_escreve               ( s_ram_escreve      ),
        .quer_escrever             ( quer_escrever      ),
        .timeoutD                  ( timeoutD           ),
        .conta_ganhar              ( s_conta_ganhar     ),
        .conta_perder              ( s_conta_perder     ),
        .zera_metricas             ( s_zera_metricas    ),
        .ignora_timeout            ( ignora_timeout     ), 
        .igual                     ( s_igualE           ),
        .enderecoIgualSequencia    ( s_igualS           ),
        .fimE                      ( s_fimE             ),
        .fimS                      ( s_fimS             ),
        .db_contagem               ( s_contagem         ),
        .db_jogadafeita            ( s_jogadafeita      ),
        .db_memoria                ( s_memoria          ),
        .tem_jogada                ( s_tem_jogada       ),
        .controle_timeout          ( s_fim_timeout      ),
        .db_sequencia              ( s_sequencia        ),
        .controle_timeout_led      ( s_timeoutL         ),
        .sequenciaMenorQueEndereco ( s_menorS           ),
        .leds                      ( leds               ),
        .db_seletor_memoria        ( db_seletor_memoria ),
        .pare                      ( s_pare             ),
        .db_contagem_jogo          ( s_contagem_jogo    ),
        .vai_escrever              ( s_vai_escrever     ),
        .ganhos                    ( s_vitorias         ),
        .perdas                    ( s_derrotas         )
    );

    // Unidade de Controle
    playseq_unidade_controle UC (
        .clock         ( clock          ),
        .reset         ( reset          ),
        .jogar         ( jogar          ),
        .nivel         ( nivel          ),
        .fimE          ( s_fimE         ),
        .igualE        ( s_igualE       ),
        .igualS        ( s_igualS       ),
        .tem_jogada    ( s_tem_jogada   ),
        .timeout       ( s_fim_timeout  ),
        .timeoutL      ( s_timeoutL     ),
        .menorS        ( s_menorS       ),
        .memoria       ( memoria        ),
        .pare          ( s_pare         ),
        .vai_escrever  ( s_vai_escrever ),
        .zeraE         ( s_zeraE        ),
        .contaE        ( s_contaE       ),
        .carregaS      ( s_carregaS     ),
        .zeraS         ( s_zeraS        ),
        .contaS        ( s_contaS       ),
        .zeraR         ( s_zeraR        ),
        .registraR     ( s_registraR    ),
        .zeraJ         ( s_zeraJ        ),
        .contaJ        ( s_contaJ       ),
        .ganhou        ( ganhou         ),
        .perdeu        ( perdeu         ),
        .pronto        ( pronto         ),
        .db_estado     ( s_estado       ),
        .deu_timeout   ( timeout        ),
        .contaT        ( s_contaT       ),
        .nivel_uc      ( s_nivel_uc     ),
        .zeraT         ( s_zeraT        ),
        .controla_leds ( s_controla_leds),
        .zeraT_leds    ( s_zeraT_leds   ),
        .contaT_leds   ( s_contaT_leds  ),
        .fase_preview  ( s_fase_preview ),
        .memoria_uc    ( s_memoria_uc   ),
        .ram_escreve   ( s_ram_escreve  ),
        .conta_ganhar  ( s_conta_ganhar ),
        .conta_perder  ( s_conta_perder ),
        .zera_metricas ( s_zera_metricas)
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
    hexa7seg5b HEX5 (
        .hexa    ( s_estado  ),
        .display ( db_estado )
    );

    // Display da sequência atual
    hexa7seg HEX3 (
        .hexa    ( s_sequencia  ),
        .display ( db_sequencia )
    );

    // Display de vitórias
    hexa7seg HEX4 (
        .hexa    ( s_vitorias  ),
        .display ( vitorias )
    );

    // Display de derrotas
    hexa7seg HEX6 (
        .hexa    ( s_derrotas  ),
        .display ( derrotas )
    );

assign db_chavesIgualMemoria = s_igualE;
assign db_enderecoIgualSequencia = s_igualS;
assign db_fimS = s_fimS;
assign db_tem_jogada = s_tem_jogada;
assign db_clock = clock;
assign db_pare = s_pare;
assign db_contagem_jogo = s_contagem_jogo;
endmodule
// --- End of jogo_playseq.v ---

// --- Start of comparador_85.v ---
/* -----------------------------------------------------------------
 *  Arquivo   : comparador_85.v
 *  Projeto   : PlaySeq
 * -----------------------------------------------------------------
 * Descricao : comparador de magnitude de 4 bits 
 *             similar ao CI 7485
 *             baseado em descricao comportamental disponivel em	
 * https://web.eecs.umich.edu/~jhayes/iscas.restore/74L85b.v
 * -----------------------------------------------------------------
 * Revisoes  :
 *     Data        Versao  Autor             Descricao
 *     21/12/2023  1.0     Edson Midorikawa  criacao
 * -----------------------------------------------------------------
 */

module comparador_85 (ALBi, AGBi, AEBi, A, B, ALBo, AGBo, AEBo);

    input[3:0] A, B;
    input      ALBi, AGBi, AEBi;
    output     ALBo, AGBo, AEBo;
    wire[4:0]  CSL, CSG;

    assign CSL  = ~A + B + ALBi;
    assign ALBo = ~CSL[4];
    assign CSG  = A + ~B + AGBi;
    assign AGBo = ~CSG[4];
    assign AEBo = ((A == B) && AEBi);

endmodule /* comparador_85 */
// --- End of comparador_85.v ---

// --- Start of contador_163.v ---
//------------------------------------------------------------------
// Arquivo   : contador_163.v
// Projeto   : PlaySeq
//------------------------------------------------------------------
// Descricao : Contador binario de 4 bits, modulo 16
//             similar ao componente 74163
//
// baseado no componente Vrcntr4u.v do livro Digital Design Principles 
// and Practices, Fifth Edition, by John F. Wakerly              
//------------------------------------------------------------------
// Revisoes  :
//     Data        Versao  Autor             Descricao
//     14/12/2023  1.0     Edson Midorikawa  versao inicial
//------------------------------------------------------------------
//
module contador_163 ( clock, clr, ld, ent, enp, D, Q, rco );
    input clock, clr, ld, ent, enp;
    input [3:0] D;
    output reg [3:0] Q;
    output reg rco;

    always @ (posedge clock)
        if (~clr)               Q <= 4'd0;
        else if (~ld)           Q <= D;
        else if (ent && enp)    Q <= Q + 1'b1;
        else                    Q <= Q;
 
    always @ (Q or ent)
        if (ent && (Q == 4'd15))   rco = 1;
        else                       rco = 0;
endmodule
// --- End of contador_163.v ---

// --- Start of contador_m.v ---

/*---------------Laboratorio Digital-------------------------------------
 * Arquivo   : contador_m.v
 * Projeto   : PlaySeq
 *-----------------------------------------------------------------------
 * Descricao : contador binario, modulo m, com parametros 
 *             M (modulo do contador) e N (numero de bits),
 *             sinais para clear assincrono (zera_as) e sincrono (zera_s)
 *             e saidas de fim e meio de contagem
 *             
 *-----------------------------------------------------------------------
 * Revisoes  :
 *     Data        Versao  Autor             Descricao
 *     30/01/2024  1.0     Edson Midorikawa  criacao
 *     16/01/2025  1.1     Edson Midorikawa  revisao
 *-----------------------------------------------------------------------
 */

module contador_m #(parameter M=100, N=7)
  (
   input  wire          clock,
   input  wire          zera_as,
   input  wire          zera_s,
   input  wire          conta,
   output reg  [N-1:0]  Q,
   output reg           fim,
   output reg           meio
  );

  always @(posedge clock or posedge zera_as) begin
    if (zera_as) begin
      Q <= 0;
    end else if (clock) begin
      if (zera_s) begin
        Q <= 0;
      end else if (conta) begin
        if (Q == M-1) begin
          Q <= 0;
        end else begin
          Q <= Q + 1'b1;
        end
      end
    end
  end

  // Saidas
  always @ (Q)
      if (Q == M-1)   fim = 1;
      else            fim = 0;

  always @ (Q)
      if (Q == M/2-1) meio = 1;
      else             meio = 0;

endmodule

// --- End of contador_m.v ---

// --- Start of edge_detector.v ---
/* ------------------------------------------------------------------------
 *  Arquivo   : edge_detector.v
 *  Projeto   : PlaySeq
 * ------------------------------------------------------------------------
 *  Descricao : detector de borda
 *              gera um pulso na saida de 1 periodo de clock
 *              a partir da detecao da borda de subida sa entrada
 *
 *              sinal de reset ativo em alto
 *
 *              > codigo adaptado a partir de codigo VHDL disponivel em
 *                https://surf-vhdl.com/how-to-design-a-good-edge-detector/
 * ------------------------------------------------------------------------
 *  Revisoes  :
 *      Data        Versao  Autor             Descricao
 *      26/01/2024  1.0     Edson Midorikawa  versao inicial
 * ------------------------------------------------------------------------
 */

module edge_detector (
    input  clock,
    input  reset,
    input  sinal,
    output pulso
);

    reg reg0;
    reg reg1;

    always @(posedge clock or posedge reset) begin
        if (reset) begin
            reg0 <= 1'b0;
            reg1 <= 1'b0;
        end else if (clock) begin
            reg0 <= sinal;
            reg1 <= reg0;
        end
    end

    assign pulso = ~reg1 & reg0;

endmodule

// --- End of edge_detector.v ---

// --- Start of hexa7seg.v ---
/* ----------------------------------------------------------------
 * Arquivo   : hexa7seg.v
 * Projeto   : PlaySeq
 *--------------------------------------------------------------
 * Descricao : decodificador hexadecimal para 
 *             display de 7 segmentos 
 * 
 * entrada : hexa - codigo binario de 4 bits hexadecimal
 * saida   : sseg - codigo de 7 bits para display de 7 segmentos
 *
 * baseado no componente bcd7seg.v da Intel FPGA
 *--------------------------------------------------------------
 * dica de uso: mapeamento para displays da placa DE0-CV
 *              bit 6 mais significativo é o bit a esquerda
 *              p.ex. sseg(6) -> HEX0[6] ou HEX06
 *--------------------------------------------------------------
 * Revisoes  :
 *     Data        Versao  Autor             Descricao
 *     24/12/2023  1.0     Edson Midorikawa  criacao
 *--------------------------------------------------------------
 */

module hexa7seg (hexa, display);
    input      [3:0] hexa;
    output reg [6:0] display;

    /*
     *    ---
     *   | 0 |
     * 5 |   | 1
     *   |   |
     *    ---
     *   | 6 |
     * 4 |   | 2
     *   |   |
     *    ---
     *     3
     */
        
    always @(hexa)
    case (hexa)
        4'h0:    display = 7'b1000000;
        4'h1:    display = 7'b1111001;
        4'h2:    display = 7'b0100100;
        4'h3:    display = 7'b0110000;
        4'h4:    display = 7'b0011001;
        4'h5:    display = 7'b0010010;
        4'h6:    display = 7'b0000010;
        4'h7:    display = 7'b1111000;
        4'h8:    display = 7'b0000000;
        4'h9:    display = 7'b0010000;
        4'ha:    display = 7'b0001000;
        4'hb:    display = 7'b0000011;
        4'hc:    display = 7'b1000110;
        4'hd:    display = 7'b0100001;
        4'he:    display = 7'b0000110;
        4'hf:    display = 7'b0001110;
        default: display = 7'b1111111;
    endcase
endmodule

// --- End of hexa7seg.v ---

// --- Start of hexa7seg5b.v ---
/*--------------------------------------------------------------
 * Arquivo   : hexa7seg5b.v
 * Projeto   : PlaySeq
 * -------------------------------------------------------------
 * Descricao : decodificador hexa para 
 *             display de 7 segmentos 
 * 
 * entrada: hexa - codigo binario de 5 bits
 * saida: display - codigo de 7 bits para display de 7 segmentos
 * ----------------------------------------------------------------
 * dica de uso: mapeamento para displays da placa DE0-CV
 *              bit 6 mais significativo é o bit a esquerda
 *              p.ex. display(6) -> HEX0[6] ou HEX06
 * ----------------------------------------------------------------
 * Revisoes  :
 *     Data        Versao  Autor             	Descricao
 *     09/02/2021  1.0     Edson Midorikawa  	criacao
 *     30/01/2025  2.0     Edson Midorikawa  	revisao p/ Verilog
 * 	 11/02/2025  2.1 		Augusto Vaccarelli 	revisao
 * ----------------------------------------------------------------
 */

module hexa7seg5b (hexa, display);
    input      [4:0] hexa;
    output reg [6:0] display;


always @(*) begin
    case (hexa)
        5'b00000: display = 7'b1000000;  // 0
        5'b00001: display = 7'b1111001;  // 1
        5'b00010: display = 7'b0100100;  // 2
        5'b00011: display = 7'b0110000;  // 3
        5'b00100: display = 7'b0011001;  // 4
        5'b00101: display = 7'b0010010;  // 5
        5'b00110: display = 7'b0000010;  // 6
        5'b00111: display = 7'b1111000;  // 7
        5'b01000: display = 7'b0000000;  // 8
        5'b01001: display = 7'b0010000;  // 9
        5'b01010: display = 7'b0001000;  // A
        5'b01011: display = 7'b0000011;  // B
        5'b01100: display = 7'b1000110;  // C
        5'b01101: display = 7'b0100001;  // D
        5'b01110: display = 7'b0000110;  // E
        5'b01111: display = 7'b0001110;  // F
        5'b10000: display = 7'b1111110;  // 10
        5'b10001: display = 7'b1111101;  // 11
        5'b10010: display = 7'b1111011;  // 12
        5'b10011: display = 7'b1110111;  // 13
        5'b10100: display = 7'b1101111;  // 14
        5'b10101: display = 7'b1011111;  // 15
        5'b10110: display = 7'b0111111;  // 16
        5'b10111: display = 7'b1111100;  // 17
        5'b11000: display = 7'b1110011;  // 18
        5'b11001: display = 7'b1100111;  // 19
        5'b11010: display = 7'b1001111;  // 1A
        5'b11011: display = 7'b0011111;  // 1B
        5'b11100: display = 7'b1110001;  // 1C
        5'b11101: display = 7'b1100011;  // 1D
        5'b11110: display = 7'b1000111;  // 1E
        5'b11111: display = 7'b0001111;  // 1F
        default:  display = 7'b1111111;
    endcase
end

endmodule


// --- End of hexa7seg5b.v ---

// --- Start of memoria_1.v ---
//------------------------------------------------------------------
// Arquivo   : memoria_1.v
// Projeto   : PlaySeq
//------------------------------------------------------------------
// Descricao : ROM sincrona 16x4 (conteúdo pre-programado)
//             
//------------------------------------------------------------------
// Revisoes  :
//     Data        Versao  Autor             Descricao
//     14/12/2023  1.0     Edson Midorikawa  versao inicial
//------------------------------------------------------------------
//
module memoria_1 (clock, address, data_out);
    input            clock;
    input      [3:0] address;
    output reg [3:0] data_out;

    always @ (posedge clock)
    begin
        case (address)
            4'b0000: data_out = 4'b0001; // 4
            4'b0001: data_out = 4'b0001; // 5
            4'b0010: data_out = 4'b0010; // 6
            4'b0011: data_out = 4'b0010; // 7 
            4'b0100: data_out = 4'b0100; // 8
            4'b0101: data_out = 4'b0100; // 9
            4'b0110: data_out = 4'b1000; // 10
            4'b0111: data_out = 4'b1000; // 11
            4'b1000: data_out = 4'b0100; // 12
            4'b1001: data_out = 4'b0100; // 13
            4'b1010: data_out = 4'b0010; // 14
            4'b1011: data_out = 4'b0010; // 15
            4'b1100: data_out = 4'b0001; // 16
            4'b1101: data_out = 4'b0001; // 17
            4'b1110: data_out = 4'b0010; // 18
            4'b1111: data_out = 4'b0010; // 19
        endcase
    end
endmodule
// --- End of memoria_1.v ---

// --- Start of memoria_2.v ---
//------------------------------------------------------------------
// Arquivo   : memoria_2.v
// Projeto   : PlaySeq
//------------------------------------------------------------------
// Descricao : ROM sincrona 16x4 (conteúdo pre-programado)
//             
//------------------------------------------------------------------
// Revisoes  :
//     Data        Versao  Autor             Descricao
//     14/12/2023  1.0     Edson Midorikawa  versao inicial
//------------------------------------------------------------------
//
module memoria_2 (clock, address, data_out);
    input            clock;
    input      [3:0] address;
    output reg [3:0] data_out;

    always @ (posedge clock)
    begin
        case (address)
            4'b0000: data_out = 4'b0001;
            4'b0001: data_out = 4'b0010;
            4'b0010: data_out = 4'b1000;
            4'b0011: data_out = 4'b0100;
            4'b0100: data_out = 4'b0010;
            4'b0101: data_out = 4'b1000;
            4'b0110: data_out = 4'b0100;
            4'b0111: data_out = 4'b0001;
            4'b1000: data_out = 4'b1000;
            4'b1001: data_out = 4'b0100;
            4'b1010: data_out = 4'b0001;
            4'b1011: data_out = 4'b0010;
            4'b1100: data_out = 4'b0100;
            4'b1101: data_out = 4'b0001;
            4'b1110: data_out = 4'b0010;
            4'b1111: data_out = 4'b1000;
        endcase
    end
endmodule

// --- End of memoria_2.v ---

// --- Start of memoria_3.v ---
//------------------------------------------------------------------
// Arquivo   : memoria_3.v
// Projeto   : PlaySeq
//------------------------------------------------------------------
// Descricao : ROM sincrona 16x4 (conteúdo pre-programado)
//             
//------------------------------------------------------------------
// Revisoes  :
//     Data        Versao  Autor             Descricao
//     14/12/2023  1.0     Edson Midorikawa  versao inicial
//------------------------------------------------------------------
//
module memoria_3 (clock, address, data_out);
    input            clock;
    input      [3:0] address;
    output reg [3:0] data_out;

    always @ (posedge clock)
    begin
        case (address)
            4'b0000: data_out = 4'b0001;
            4'b0001: data_out = 4'b0010;
            4'b0010: data_out = 4'b1000;
            4'b0011: data_out = 4'b0100;
            4'b0100: data_out = 4'b0100;
            4'b0101: data_out = 4'b1000;
            4'b0110: data_out = 4'b0010;
            4'b0111: data_out = 4'b0001;
            4'b1000: data_out = 4'b0001;
            4'b1001: data_out = 4'b0010;
            4'b1010: data_out = 4'b1000;
            4'b1011: data_out = 4'b0100;
            4'b1100: data_out = 4'b0100;
            4'b1101: data_out = 4'b1000;
            4'b1110: data_out = 4'b0010;
            4'b1111: data_out = 4'b0001;
        endcase
    end
endmodule
// --- End of memoria_3.v ---

// --- Start of mux12x4_n.v ---
/*------------------------------------------------------------------------
 * Arquivo   : mux4x2_n.v
 * Projeto   : PlaySeq
 *------------------------------------------------------------------------
 * Descricao : multiplexador 4x(2 bit de seletor) com entradas de n bits 
 * (parametrizado) 
 * 
 *------------------------------------------------------------------------
 * Revisoes  :
 *     Data        Versao  Autor             Descricao
 *     07/03/2024  1.0     Ana Vitória       criacao
 *------------------------------------------------------------------------
 */

module mux12x4_n #(
    parameter BITS = 4
) (
    input      [BITS-1:0] D0, // nível fácil e memória fácil
    input      [BITS-1:0] D1, // nível fácil e memória média
    input      [BITS-1:0] D2, // nível fácil e memória difícil
    input      [BITS-1:0] D3, // nível fácil e memória personalizada
    input      [BITS-1:0] D4, // nível médio e memória fácil
    input      [BITS-1:0] D5, // nível médio e memória média
    input      [BITS-1:0] D6, // nível médio e memória difícil
    input      [BITS-1:0] D7, // nível médio e memória personalizada
    input      [BITS-1:0] D8, // nível difícil e memória fácil
    input      [BITS-1:0] D9, // nível difícil e memória média
    input      [BITS-1:0] D10, // nível difícil e memória difícil
    input      [BITS-1:0] D11, // nível difícil e memória personalizada
    input      [3:0]      SEL,
    output reg [BITS-1:0] OUT
);

always @(*) begin
    case (SEL)
        4'b0000:    OUT = D0;
        4'b0001:    OUT = D1;
        4'b0010:    OUT = D2;
        4'b0011:    OUT = D3;
        4'b0100:    OUT = D4;
        4'b0101:    OUT = D5;
        4'b0110:    OUT = D6;
        4'b0111:    OUT = D7;
        4'b1000:    OUT = D8;
        4'b1001:    OUT = D9;
        4'b1010:    OUT = D10;
        4'b1011:    OUT = D11;
        default: OUT = {BITS{1'b1}}; // todos os bits em 1
    endcase
end

endmodule
// --- End of mux12x4_n.v ---

// --- Start of mux2x1.v ---
/*------------------------------------------------------------------------
 * Arquivo   : mux2x1.v
 * Projeto   : PlaySeq
 *------------------------------------------------------------------------
 * Descricao : multiplexador 2x1
 * 
 * adaptado a partir do codigo my_4t1_mux.vhd do livro "Free Range VHDL"
 * 
 * exemplo de uso: ver testbench mux2x1_tb.v
 *------------------------------------------------------------------------
 * Revisoes  :
 *     Data        Versao  Autor             Descricao
 *     15/02/2024  1.0     Edson Midorikawa  criacao
 *     31/01/2025  1.1     Edson Midorikawa  revisao
 *------------------------------------------------------------------------
 */

module mux2x1 (
    input      D0,
    input      D1,
    input      SEL,
    output reg OUT
);

always @(*) begin
    case (SEL)
        1'b0:    OUT = D0;
        1'b1:    OUT = D1;
        default: OUT = 0; // saida em 0
    endcase
end

endmodule

// --- End of mux2x1.v ---

// --- Start of mux2x1_n.v ---
/*------------------------------------------------------------------------
 * Arquivo   : mux2x1_n.v
 * Projeto   : PlaySeq
 *------------------------------------------------------------------------
 * Descricao : multiplexador 2x1 com entradas de n bits (parametrizado) 
 * 
 * adaptado a partir do codigo my_4t1_mux.vhd do livro "Free Range VHDL"
 * 
 * exemplo de uso: ver testbench mux2x1_n_tb.v
 *------------------------------------------------------------------------
 * Revisoes  :
 *     Data        Versao  Autor             Descricao
 *     15/02/2024  1.0     Edson Midorikawa  criacao
 *------------------------------------------------------------------------
 */

module mux2x1_n #(
    parameter BITS = 4
) (
    input      [BITS-1:0] D0,
    input      [BITS-1:0] D1,
    input                 SEL,
    output reg [BITS-1:0] OUT
);

always @(*) begin
    case (SEL)
        1'b0:    OUT = D0;
        1'b1:    OUT = D1;
        default: OUT = {BITS{1'b1}}; // todos os bits em 1
    endcase
end

endmodule
// --- End of mux2x1_n.v ---

// --- Start of mux4x2_n.v ---
/*------------------------------------------------------------------------
 * Arquivo   : mux4x2_n.v
 * Projeto   : PlaySeq
 *------------------------------------------------------------------------
 * Descricao : multiplexador 4x(2 bit de seletor) com entradas de n bits 
 * (parametrizado) 
 * 
 *------------------------------------------------------------------------
 * Revisoes  :
 *     Data        Versao  Autor             Descricao
 *     07/03/2024  1.0     Ana Vitória       criacao
 *------------------------------------------------------------------------
 */

module mux4x2_n #(
    parameter BITS = 4
) (
    input      [BITS-1:0] D0,
    input      [BITS-1:0] D1,
    input      [BITS-1:0] D2,
    input      [BITS-1:0] D3,
    input      [1:0]      SEL,
    output reg [BITS-1:0] OUT
);

always @(*) begin
    case (SEL)
        2'b00:    OUT = D0;
        2'b01:    OUT = D1;
        2'b10:    OUT = D2;
        2'b11:    OUT = D3;
        default: OUT = {BITS{1'b0}}; // todos os bits em 1
    endcase
end

endmodule
// --- End of mux4x2_n.v ---

// --- Start of playseq_fluxo_dados.v ---
//------------------------------------------------------------------
// Arquivo   : playseq_fluxo_dados.v
// Projeto   : PlaySeq
//------------------------------------------------------------------
// Descricao : Fluxo de Dados do Jogo PlaySeq
//             
//------------------------------------------------------------------
// Revisoes  :
//     Data        Versao  Autor             Descricao
//     07/03/2025  1.0     Ana Vitória       versao inicial
//------------------------------------------------------------------
//

module playseq_fluxo_dados (
    input clock,
    input [3:0] botoes,
    input [1:0] nivel,
    input zeraT,
    input zeraR,
    input registraR,
    input contaE,
    input contaS,
    input contaT,
    input contaJ,
    input zeraE,
    input zeraS,
    input zeraJ,
    input carregaS,
    input controla_leds,
    input zeraT_leds,
    input contaT_leds,
    input fase_preview,
    input [1:0] seletor_memoria,
    input ram_escreve,
    input quer_escrever,
    input [1:0] timeoutD,
    input conta_ganhar,
    input conta_perder,
    input zera_metricas,
    input ignora_timeout,
    output igual,
    output enderecoIgualSequencia,
    output fimE,
    output fimS,
    output tem_jogada,
    output [3:0] db_contagem,
    output [3:0] db_jogadafeita,
    output [3:0] db_memoria,
    output controle_timeout,
    output [3:0] db_sequencia,
    output controle_timeout_led,
    output sequenciaMenorQueEndereco,
    output [3:0] leds,
    output db_seletor_memoria,
    output pare,
    output [1:0] db_contagem_jogo,
    output vai_escrever,
    output [3:0] ganhos,
    output [3:0] perdas
);

    wire [3:0] s_endereco;
    wire [3:0] s_dado;
    wire [3:0] s_botoes;
    wire [3:0] s_sequencia;
    wire [3:0] s_sequencia_fixo;
    wire s_tem_jogada = |botoes;
    wire [3:0] s_mux;
    wire [3:0] s_mem1;
    wire [3:0] s_mem2;
    wire [3:0] s_mem3;
    wire [3:0] s_mem4;
    wire [1:0] s_contagem;
    wire [3:0] s_quant_inicial;
    wire [3:0] s_seletor_final = {nivel, seletor_memoria};
	wire rco;
    wire fim_dois_e_meios;
    wire fim_5s;
    wire fim_10s;
    wire fim_20s;
    wire s_controle_timeout;

    // dificuldade_quant
    mux4x2_n #( .BITS(1) ) mux_quant (
        .D0 (~s_contagem[0] & ~s_contagem[1]),
        .D1 (s_contagem[0] & ~s_contagem[1]),
        .D2 (~s_contagem[0] & s_contagem[1]),
        .D3 (1'b1),
        .SEL (nivel),
        .OUT (pare)
    );

    // dificuldade_ms
    mux4x2_n #( .BITS(1) ) mux_timeout (
        .D0 (fim_20s),
        .D1 (fim_10s),
        .D2 (fim_5s),
        .D3 (fim_dois_e_meios),
        .SEL (timeoutD),
        .OUT (s_controle_timeout)
    );

    // ignora_timeout
    mux2x1 mux_controla_timeout (
        .D0 (s_controle_timeout),
        .D1 (1'b0),
        .SEL (ignora_timeout),
        .OUT (controle_timeout)
    );

    // decide o início para cada situação, sempre defasado de 1
    mux12x4_n #( .BITS(4) ) mux_inicial (
        .D0 (4'b0100), // feito
        .D1 (4'b1000), // feito
        .D2 (4'b0111), // feito
        .D3 (4'b0100),
        .D4 (4'b0101), //feito
        .D5 (4'b1000), // feito
        .D6 (4'b0101), // feito
        .D7 (4'b0100),
        .D8 (4'b0100), // feito
        .D9 (4'b1000), // feito
        .D10(4'b0011), // feito
        .D11(4'b0100),
        .SEL (s_seletor_final),
        .OUT (s_quant_inicial)
    );

    // decide o final para cada situação
    mux12x4_n #( .BITS(1) ) mux_final (
        .D0 (rco), // feito
        .D1 (rco), // feito
        .D2 (~s_endereco[0] & s_endereco[1] & s_endereco[2] & s_endereco[3]), // feito
        .D3 (rco),
        .D4 (rco), // feito
        .D5 (rco), // feito
        .D6 (rco), // feito
        .D7 (rco),
        .D8 (rco), // feito
        .D9 (rco), // feito
        .D10(~s_endereco[0] & s_endereco[1] & s_endereco[2] & s_endereco[3]), // feito
        .D11(rco),
        .SEL (s_seletor_final),
        .OUT (fimE)
    );

    // mux n
    mux2x1_n #( .BITS(4) ) mux_leds (
      .D0(botoes),
      .D1(s_mux),
      .SEL(fase_preview),
      .OUT(leds)
    );

    // mux n
    mux2x1_n #( .BITS(4) ) mux_zera (
      .D0(4'b0000),
      .D1(s_dado),
      .SEL(controla_leds),
      .OUT(s_mux)
    );

    // contador endereços
    contador_163 contEnd (
        .clock (clock),
        .clr   (~zeraE),
        .ld    (1'b1),
        .ent   (1'b1),
        .enp   (contaE),
        .D     (4'b0),
        .Q     (s_endereco),
        .rco   (rco)
    );

    // contador sequencias
    contador_163 contLmt (
        .clock (clock),
        .clr   (~zeraS),
        .ld    (~carregaS),
        .ent   (1'b1),
        .enp   (contaS),
        .D     (s_quant_inicial),
        .Q     (s_sequencia),
        .rco   (fimS)
    );

    // comparador jogadas
    comparador_85 compJog (
        .A    (s_dado),
        .B    (s_botoes),
        .ALBi (1'b0),
        .AGBi (1'b0),
        .AEBi (1'b1),
        .ALBo (),
        .AGBo (),
        .AEBo (igual)
    );

    // comparador sequencias
    comparador_85 compLmt (
        .A    (s_sequencia),
        .B    (s_endereco),
        .ALBi (1'b0),
        .AGBi (1'b0),
        .AEBi (1'b1),
        .ALBo (sequenciaMenorQueEndereco),
        .AGBo (),
        .AEBo (enderecoIgualSequencia)
    );

    // dificuldade_seq
    mux4x2_n #( .BITS(4) ) mux_seq (
      .D0(s_mem1),
      .D1(s_mem2),
      .D2(s_mem3),
      .D3(s_mem4),
      .SEL(seletor_memoria),
      .OUT(s_dado)
    );

    mux2x1_n #( .BITS(1) ) mux_escrita (
      .D0(1'b0),
      .D1(quer_escrever),
      .SEL(&seletor_memoria),
      .OUT(vai_escrever)
    );

    // memória 1
    memoria_1 memoria1 (
        .clock    (clock),
        .address  (s_endereco),
        .data_out (s_mem1)
    );

    // memória 2
    memoria_2 memoria2 (
        .clock    (clock),
        .address  (s_endereco),
        .data_out (s_mem2)
    );

    // memória 3
    memoria_3 memoria3 (
        .clock    (clock),
        .address  (s_endereco),
        .data_out (s_mem3)
    );

    // memória 4
    sync_ram_16x4_file memoria4 (
    	.clk  (clock),
    	.we   (ram_escreve),
    	.data (botoes),
    	.addr (s_endereco),
    	.q    (s_mem4)
    );

    // registrador
    registrador_4 regBotoes (
        .clock  (clock),
        .clear  (zeraR),
        .enable (registraR),
        .D      (botoes),
        .Q      (s_botoes)
    );

    edge_detector detector (
        .clock (clock),
        .reset (zeraS),
        .sinal (s_tem_jogada),
        .pulso (tem_jogada)
    );

    contador_m #(.M(5000), .N(13)) contador_timeout_jogadas (
        .clock   (clock),
        .zera_as (zeraR),
        .zera_s  (zeraT),
        .conta   (contaT),
        .Q       (),
        .fim     (fim_5s),
        .meio    (fim_dois_e_meios)
    );

    contador_m #(.M(20000), .N(15)) contador_timeout_jogadas_facil (
        .clock   (clock),
        .zera_as (zeraR),
        .zera_s  (zeraT),
        .conta   (contaT),
        .Q       (),
        .fim     (fim_20s),
        .meio    (fim_10s)
    );

    contador_m #(.M(500), .N(9)) contador_timeout_leds (
        .clock   (clock),
        .zera_as (zeraR),
        .zera_s  (zeraT_leds),
        .conta   (contaT_leds),
        .Q       (),
        .fim     (controle_timeout_led),
        .meio    ()
    );

    contador_m #(.M(4), .N(2)) contador_jogadas (
        .clock   (clock),
        .zera_as (zeraR), // precisa ser um zera diferente
        .zera_s  (zeraJ),
        .conta   (contaJ), // precisa ser um zera diferente
        .Q       (s_contagem),
        .fim     (),
        .meio    ()
    );

        // contador métricas ganhar
    contador_163 contGanha (
        .clock (clock),
        .clr   (~zera_metricas),
        .ld    (1'b1),
        .ent   (1'b1),
        .enp   (conta_ganhar),
        .D     (4'b0),
        .Q     (ganhos),
        .rco   ()
    );

    // contador métricas perder
    contador_163 contPerde (
        .clock (clock),
        .clr   (~zera_metricas),
        .ld    (1'b1),
        .ent   (1'b1),
        .enp   (conta_perder),
        .D     (4'b0),
        .Q     (perdas),
        .rco   ()
    );

    assign db_memoria  = s_dado;
    assign db_contagem = s_endereco;
    assign db_sequencia = s_sequencia;
    assign db_jogadafeita = s_botoes;
    assign db_seletor_memoria = seletor_memoria;
    assign db_contagem_jogo = s_contagem;
endmodule
// --- End of playseq_fluxo_dados.v ---

// --- Start of playseq_unidade_controle.v ---
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
            metricas_perder:    Eatual_str = "metricas_perder";
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
// --- End of playseq_unidade_controle.v ---

// --- Start of registrador_4.v ---
//------------------------------------------------------------------
// Arquivo   : registrador_4.v
// Projeto   : PlaySeq
//------------------------------------------------------------------
// Descricao : Registrador de 4 bits
//             
//------------------------------------------------------------------
// Revisoes  :
//     Data        Versao  Autor             Descricao
//     14/12/2023  1.0     Edson Midorikawa  versao inicial
//------------------------------------------------------------------
//
module registrador_4 (
    input        clock,
    input        clear,
    input        enable,
    input  [3:0] D,
    output [3:0] Q
);

    reg [3:0] IQ;

    always @(posedge clock or posedge clear) begin
        if (clear)
            IQ <= 0;
        else if (enable)
            IQ <= D;
    end

    assign Q = IQ;

endmodule
// --- End of registrador_4.v ---

// --- Start of sync_ram_16x4.v ---
//------------------------------------------------------------------
// Arquivo   : sync_ram_16x4.v
// Projeto   : PlaySeq
//------------------------------------------------------------------
// Descricao : RAM sincrona 16x4
//             com conteudo inicial pre-programado             
//------------------------------------------------------------------
// Revisoes  :
//     Data        Versao  Autor             Descricao
//     15/03/2025  1.0     Ana Vitória       versao inicial
//------------------------------------------------------------------

module sync_ram_16x4_file
(
    input        clk,
    input        we,
    input  [3:0] data,
    input  [3:0] addr,
    output [3:0] q
);

    // Variavel RAM (armazena dados)
    reg [3:0] ram[15:0];

    // Inicializa manualmente os valores da RAM (Verilog-2005 compatível)
    initial begin
        ram[0]  = 4'b0001; ram[1]  = 4'b0010; ram[2]  = 4'b0100; ram[3]  = 4'b1000;
        ram[4]  = 4'b0001; ram[5]  = 4'b0010; ram[6]  = 4'b0100; ram[7]  = 4'b1000;
        ram[8]  = 4'b0001; ram[9]  = 4'b0010; ram[10] = 4'b0100; ram[11] = 4'b1000;
        ram[12] = 4'b0001; ram[13] = 4'b0010; ram[14] = 4'b0100; ram[15] = 4'b1000;
    end

    // Registra endereco de acesso
    reg [3:0] addr_reg;

    always @ (posedge clk) begin
        if (we)
            ram[addr] <= data;

        addr_reg <= addr;
    end

    assign q = ram[addr_reg];

endmodule

// --- End of sync_ram_16x4.v ---

