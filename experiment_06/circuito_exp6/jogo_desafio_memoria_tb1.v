// /* --------------------------------------------------------------------
//  * Arquivo   : circuito_exp4_tb-MODELO.v
//  * Projeto   : Experiencia 4 - Desenvolvimento de Projeto de
//  *             Circuitos Digitais em FPGA
//  * --------------------------------------------------------------------
//  * Descricao : testbench Verilog MODELO para circuito da Experiencia 5
//  *
//  *             1) Plano de teste com 4 jogadas certas
//  *                e erro na quinta jogada
//  *
//  * --------------------------------------------------------------------
//  * Revisoes  :
//  *     Data        Versao  Autor             Descricao
//  *     27/01/2024  1.0     Edson Midorikawa  versao inicial
//  *     16/01/2024  1.1     Edson Midorikawa  revisao
//  * --------------------------------------------------------------------
//  */

// `timescale 1ns/1ns

// module jogo_desafio_memoria_tb1;

//     // Sinais para conectar com o DUT
//     // valores iniciais para fins de simulacao (ModelSim)
//     reg        clock_in   = 1;
//     reg        reset_in   = 0;
//     reg        jogar_in = 0;
//     reg  [3:0] botoes_in  = 4'b0000;
//     reg        nivel_in = 0;

//     wire       ganhou_out;
//     wire       perdeu_out  ;
//     wire       pronto_out ;
//     wire [3:0] leds_out   ;

//     wire       db_igualE_out     ;
//     wire       db_igualL_out     ;
//     wire [6:0] db_contagem_out   ;
//     wire [6:0] db_memoria_out    ;
//     wire [6:0] db_estado_out     ;
//     wire [6:0] db_jogadafeita_out;
//     wire       db_clock_out      ;
//     wire       db_tem_jogada_out ;
//     wire       db_timeout_out    ;
//     wire       db_contaL_out     ;
//     wire [6:0] db_limite_out     ;
//     wire       db_nivel_out      ;

//     // Configuração do clock
//     parameter clockPeriod = 1_000_000; // in ns, f=1KHz

//     // Identificacao do caso de teste
//     reg [31:0] caso = 0;

//     // Gerador de clock
//     always #((clockPeriod / 2)) clock_in = ~clock_in;

//     // instanciacao do DUT (Device Under Test)
//     jogo_desafio_memoria_desafio dut (
//       .clock          ( clock_in    ),
//       .reset          ( reset_in    ),
//       .jogar          ( jogar_in    ),
//       .botoes         ( botoes_in   ),
//       .nivel          ( nivel_in    ),
//       .ganhou         ( ganhou_out  ),
//       .perdeu         ( perdeu_out  ),
//       .pronto         ( pronto_out  ),
//       .leds           ( leds_out    ),
//       .db_igualE      ( db_igualE_out      ),
//       .db_igualL      ( db_igualL_out      ),
//       .db_contagem    ( db_contagem_out    ),
//       .db_memoria     ( db_memoria_out     ),
//       .db_estado      ( db_estado_out      ),
//       .db_jogadafeita ( db_jogadafeita_out ),
//       .db_clock       ( db_clock_out       ),
//       .db_tem_jogada  ( db_tem_jogada_out  ),
//       .db_timeout     ( db_timeout_out     ),
//       .db_contaL      ( db_contaL_out      ),
//       .db_limite      ( db_limite_out      ),
//       .db_nivel       ( db_nivel_out       )
//     );

//     // geracao dos sinais de entrada (estimulos)
//     initial begin
//       $display("Inicio da simulacao");

//       // condicoes iniciais
//       caso       = 0;
//       clock_in   = 1;
//       reset_in   = 0;
//       jogar_in = 0;
//       botoes_in  = 4'b0000;
//       #clockPeriod;

//       // Teste 1. resetar circuito
//       caso = 1;
//       // gera pulso de reset
//       @(negedge clock_in);
//       reset_in = 1;
//       #(clockPeriod);
//       reset_in = 0;
//       // espera
//       #(10*clockPeriod);

//       // Teste 2. jogar=1 por 5 periodos de clock
//       caso = 2;
//       nivel_in = 0;
//       #(2*clockPeriod);
//       jogar_in = 1;
//       #(5*clockPeriod);
//       jogar_in = 0;
//       // espera
//       #(10*clockPeriod);

//       // Teste 3. jogada #1 (ajustar botoes para 0001 por 10 periodos de clock
//       caso = 3;
//       @(negedge clock_in);
//       botoes_in = 4'b0001;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       // Teste 4. jogada #2 (ajustar botoes para 0010 por 10 periodos de clock
//       caso = 4;
//       @(negedge clock_in);
//       botoes_in = 4'b0001;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       @(negedge clock_in);
//       botoes_in = 4'b0010;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       // Teste 5. jogada #3 (ajustar botoes para 0100 por 10 periodos de clock
//       caso = 5;
//       @(negedge clock_in);
//       botoes_in = 4'b0001;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);
      
//       @(negedge clock_in);
//       botoes_in = 4'b0010;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       @(negedge clock_in);
//       botoes_in = 4'b0100;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       // Teste 6. jogada #4 (ajustar botoes para 1000 por 10 periodos de clock
//       caso = 6;
//       @(negedge clock_in);
//       botoes_in = 4'b0001;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);
      
//       @(negedge clock_in);
//       botoes_in = 4'b0010;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);
      
//       @(negedge clock_in);
//       botoes_in = 4'b0100;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       @(negedge clock_in);
//       botoes_in = 4'b1000;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       // Teste 7. jogada #5 (ajustar botoes para 0100 por 10 periodos de clock
//       caso = 7;
//       @(negedge clock_in);
//       botoes_in = 4'b0001;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);
      
//       @(negedge clock_in);
//       botoes_in = 4'b0010;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);
      
//       @(negedge clock_in);
//       botoes_in = 4'b0100;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);
      
//       @(negedge clock_in);
//       botoes_in = 4'b1000;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       @(negedge clock_in);
//       botoes_in = 4'b0100;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       // Teste 8. jogada #6 (ajustar botoes para 0010 por 10 periodos de clock
//       caso = 8;
//       @(negedge clock_in);
//       botoes_in = 4'b0001;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);
      
//       @(negedge clock_in);
//       botoes_in = 4'b0010;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);
      
//       @(negedge clock_in);
//       botoes_in = 4'b0100;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);
      
//       @(negedge clock_in);
//       botoes_in = 4'b1000;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       @(negedge clock_in);
//       botoes_in = 4'b0100;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       @(negedge clock_in);
//       botoes_in = 4'b0010;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       // Teste 9. jogada #7 (ajustar botoes para 0001 por 10 periodos de clock
//       caso = 9;
//       @(negedge clock_in);
//       botoes_in = 4'b0001;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);
      
//       @(negedge clock_in);
//       botoes_in = 4'b0010;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);
      
//       @(negedge clock_in);
//       botoes_in = 4'b0100;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);
      
//       @(negedge clock_in);
//       botoes_in = 4'b1000;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       @(negedge clock_in);
//       botoes_in = 4'b0100;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       @(negedge clock_in);
//       botoes_in = 4'b0010;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       @(negedge clock_in);
//       botoes_in = 4'b0001;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       // Teste 10. jogada #8 (ajustar botoes para 0001 por 10 periodos de clock
//       caso = 10;
//       @(negedge clock_in);
//       botoes_in = 4'b0001;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);
      
//       @(negedge clock_in);
//       botoes_in = 4'b0010;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);
      
//       @(negedge clock_in);
//       botoes_in = 4'b0100;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);
      
//       @(negedge clock_in);
//       botoes_in = 4'b1000;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       @(negedge clock_in);
//       botoes_in = 4'b0100;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       @(negedge clock_in);
//       botoes_in = 4'b0010;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       @(negedge clock_in);
//       botoes_in = 4'b0001;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       @(negedge clock_in);
//       botoes_in = 4'b0001;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       // Teste 11. jogada #9 (ajustar botoes para 0010 por 10 periodos de clock
//       caso = 11;
//       @(negedge clock_in);
//       botoes_in = 4'b0001;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);
      
//       @(negedge clock_in);
//       botoes_in = 4'b0010;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);
      
//       @(negedge clock_in);
//       botoes_in = 4'b0100;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);
      
//       @(negedge clock_in);
//       botoes_in = 4'b1000;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       @(negedge clock_in);
//       botoes_in = 4'b0100;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       @(negedge clock_in);
//       botoes_in = 4'b0010;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       @(negedge clock_in);
//       botoes_in = 4'b0001;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       @(negedge clock_in);
//       botoes_in = 4'b0001;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       @(negedge clock_in);
//       botoes_in = 4'b0010;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       // Teste 12. jogada #10 (ajustar botoes para 0010 por 10 periodos de clock
//       caso = 12;
//       @(negedge clock_in);
//       botoes_in = 4'b0001;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);
      
//       @(negedge clock_in);
//       botoes_in = 4'b0010;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);
      
//       @(negedge clock_in);
//       botoes_in = 4'b0100;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);
      
//       @(negedge clock_in);
//       botoes_in = 4'b1000;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       @(negedge clock_in);
//       botoes_in = 4'b0100;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       @(negedge clock_in);
//       botoes_in = 4'b0010;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       @(negedge clock_in);
//       botoes_in = 4'b0001;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       @(negedge clock_in);
//       botoes_in = 4'b0001;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       @(negedge clock_in);
//       botoes_in = 4'b0010;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       @(negedge clock_in);
//       botoes_in = 4'b0010;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       // Teste 13. jogada #11 (ajustar botoes para 0100 por 10 periodos de clock
//       caso = 13;
//       @(negedge clock_in);
//       botoes_in = 4'b0001;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);
      
//       @(negedge clock_in);
//       botoes_in = 4'b0010;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);
      
//       @(negedge clock_in);
//       botoes_in = 4'b0100;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);
      
//       @(negedge clock_in);
//       botoes_in = 4'b1000;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       @(negedge clock_in);
//       botoes_in = 4'b0100;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       @(negedge clock_in);
//       botoes_in = 4'b0010;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       @(negedge clock_in);
//       botoes_in = 4'b0001;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       @(negedge clock_in);
//       botoes_in = 4'b0001;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       @(negedge clock_in);
//       botoes_in = 4'b0010;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       @(negedge clock_in);
//       botoes_in = 4'b0010;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       @(negedge clock_in);
//       botoes_in = 4'b0100;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       // Teste 14. jogada #12 (ajustar botoes para 0100 por 10 periodos de clock
//       caso = 14;
//       @(negedge clock_in);
//       botoes_in = 4'b0001;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);
      
//       @(negedge clock_in);
//       botoes_in = 4'b0010;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);
      
//       @(negedge clock_in);
//       botoes_in = 4'b0100;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);
      
//       @(negedge clock_in);
//       botoes_in = 4'b1000;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       @(negedge clock_in);
//       botoes_in = 4'b0100;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       @(negedge clock_in);
//       botoes_in = 4'b0010;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       @(negedge clock_in);
//       botoes_in = 4'b0001;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       @(negedge clock_in);
//       botoes_in = 4'b0001;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       @(negedge clock_in);
//       botoes_in = 4'b0010;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       @(negedge clock_in);
//       botoes_in = 4'b0010;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       @(negedge clock_in);
//       botoes_in = 4'b0100;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       @(negedge clock_in);
//       botoes_in = 4'b0100;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       // Teste 15. jogada #13 (ajustar botoes para 1000 por 10 periodos de clock
//       caso = 15;
//       @(negedge clock_in);
//       botoes_in = 4'b0001;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);
      
//       @(negedge clock_in);
//       botoes_in = 4'b0010;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);
      
//       @(negedge clock_in);
//       botoes_in = 4'b0100;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);
      
//       @(negedge clock_in);
//       botoes_in = 4'b1000;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       @(negedge clock_in);
//       botoes_in = 4'b0100;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       @(negedge clock_in);
//       botoes_in = 4'b0010;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       @(negedge clock_in);
//       botoes_in = 4'b0001;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       @(negedge clock_in);
//       botoes_in = 4'b0001;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       @(negedge clock_in);
//       botoes_in = 4'b0010;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       @(negedge clock_in);
//       botoes_in = 4'b0010;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       @(negedge clock_in);
//       botoes_in = 4'b0100;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       @(negedge clock_in);
//       botoes_in = 4'b0100;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       @(negedge clock_in);
//       botoes_in = 4'b1000;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       // Teste 16. jogada #14 (ajustar botoes para 1000 por 10 periodos de clock
//       caso = 16;
//       @(negedge clock_in);
//       botoes_in = 4'b0001;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);
      
//       @(negedge clock_in);
//       botoes_in = 4'b0010;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);
      
//       @(negedge clock_in);
//       botoes_in = 4'b0100;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);
      
//       @(negedge clock_in);
//       botoes_in = 4'b1000;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       @(negedge clock_in);
//       botoes_in = 4'b0100;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       @(negedge clock_in);
//       botoes_in = 4'b0010;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       @(negedge clock_in);
//       botoes_in = 4'b0001;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       @(negedge clock_in);
//       botoes_in = 4'b0001;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       @(negedge clock_in);
//       botoes_in = 4'b0010;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       @(negedge clock_in);
//       botoes_in = 4'b0010;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       @(negedge clock_in);
//       botoes_in = 4'b0100;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       @(negedge clock_in);
//       botoes_in = 4'b0100;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       @(negedge clock_in);
//       botoes_in = 4'b1000;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       @(negedge clock_in);
//       botoes_in = 4'b1000;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       // Teste 17. jogada #15 (ajustar botoes para 0001 por 10 periodos de clock
//       caso = 17;
//       @(negedge clock_in);
//       botoes_in = 4'b0001;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);
      
//       @(negedge clock_in);
//       botoes_in = 4'b0010;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);
      
//       @(negedge clock_in);
//       botoes_in = 4'b0100;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);
      
//       @(negedge clock_in);
//       botoes_in = 4'b1000;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       @(negedge clock_in);
//       botoes_in = 4'b0100;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       @(negedge clock_in);
//       botoes_in = 4'b0010;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       @(negedge clock_in);
//       botoes_in = 4'b0001;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       @(negedge clock_in);
//       botoes_in = 4'b0001;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       @(negedge clock_in);
//       botoes_in = 4'b0010;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       @(negedge clock_in);
//       botoes_in = 4'b0010;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       @(negedge clock_in);
//       botoes_in = 4'b0100;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       @(negedge clock_in);
//       botoes_in = 4'b0100;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       @(negedge clock_in);
//       botoes_in = 4'b1000;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       @(negedge clock_in);
//       botoes_in = 4'b1000;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       @(negedge clock_in);
//       botoes_in = 4'b0001;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       // Teste 18. jogada #16 (ajustar botoes para 0100 por 10 periodos de clock
//       caso = 18;
//       @(negedge clock_in);
//       botoes_in = 4'b0001;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);
      
//       @(negedge clock_in);
//       botoes_in = 4'b0010;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);
      
//       @(negedge clock_in);
//       botoes_in = 4'b0100;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);
      
//       @(negedge clock_in);
//       botoes_in = 4'b1000;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       @(negedge clock_in);
//       botoes_in = 4'b0100;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       @(negedge clock_in);
//       botoes_in = 4'b0010;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       @(negedge clock_in);
//       botoes_in = 4'b0001;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       @(negedge clock_in);
//       botoes_in = 4'b0001;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       @(negedge clock_in);
//       botoes_in = 4'b0010;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       @(negedge clock_in);
//       botoes_in = 4'b0010;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       @(negedge clock_in);
//       botoes_in = 4'b0100;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       @(negedge clock_in);
//       botoes_in = 4'b0100;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       @(negedge clock_in);
//       botoes_in = 4'b1000;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       @(negedge clock_in);
//       botoes_in = 4'b1000;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       @(negedge clock_in);
//       botoes_in = 4'b0001;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       @(negedge clock_in);
//       botoes_in = 4'b0100;
//       #(10*clockPeriod);
//       botoes_in = 4'b0000;
//       // espera entre jogadas
//       #(10*clockPeriod);

//       // final dos casos de teste da simulacao
//       caso = 99;
//       #100;
//       $display("Fim da simulacao");
//       $stop;
//     end

//   endmodule
