`timescale 1ms/1ns

module jogo_desafio_memoria_tb1;

    // Sinais para conectar com o DUT
    reg        clock_in   = 1;
    reg        reset_in   = 0;
    reg        jogar_in = 0;
    reg  [3:0] botoes_in  = 4'b0000;

    wire       ganhou_out;
    wire       perdeu_out;
    wire       pronto_out;
    wire [3:0] leds_out;

    // Configuração do clock
    parameter clockPeriod = 1; // in ms, f=1KHz // in ns, f=1KHz

    // Identificação do caso de teste
    reg [31:0] caso = 0;

    // Gerador de clock
    always #((clockPeriod / 2)) clock_in = ~clock_in;

    // Instanciação do DUT
    jogo_desafio_memoria_desafio dut (
        .clock(clock_in),
        .reset(reset_in),
        .jogar(jogar_in),
        .botoes(botoes_in),
        .ganhou(ganhou_out),
        .perdeu(perdeu_out),
        .timeout(timeout_out),
        .pronto(pronto_out),
        .leds(leds_out)
    );

    // Geração dos estímulos de entrada
    initial begin
        $display("Inicio da simulacao");

        // Condições iniciais
        caso = 0;
        clock_in = 1;
        reset_in = 0;
        jogar_in = 0;
        botoes_in = 4'b0000;
        #clockPeriod;

        // Teste 1: Reset do circuito
        caso = 1;
        @(negedge clock_in);
        reset_in = 1;
        #(clockPeriod);
        reset_in = 0;
        #(10 * clockPeriod);

        // Teste 2: Jogar por 5 períodos de clock
        caso = 2;
        #(2 * clockPeriod);
        jogar_in = 1;
        #(5 * clockPeriod);
        jogar_in = 0;
        #(10 * clockPeriod);

        // Testes de jogadas
        for (integer i = 3; i <= 18; i = i + 1) begin
            #(1000 * (i - 2));
            caso = i;
            @(negedge clock_in);

            reg [3:0] jogadas[0:15] = '{4'b0001, 4'b0010, 4'b0100, 4'b1000, 4'b0100, 4'b0010, 4'b0001, 4'b0001, 4'b0010, 4'b0010, 4'b0100, 4'b0100, 4'b1000, 4'b1000, 4'b0001, 4'b0100};
            for (integer j = 0; j < 16; j = j + 1) begin
                botoes_in = jogadas[j];
                #(10 * clockPeriod);
                botoes_in = 4'b0000;
                #(10 * clockPeriod);
            end
        end

        // Final da simulação
        caso = 99;
        #1;
        $display("Fim da simulacao");
        $stop;
    end
endmodule
