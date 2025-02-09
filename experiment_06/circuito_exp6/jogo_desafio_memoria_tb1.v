`timescale 1us/1ns

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
    wire       db_clock_out;
    wire       db_tem_jogada_out;
    wire       db_chavesIgualMemoria_out;
    wire       db_enderecoIgualSequencia_out;
    wire       db_fimS_out;
    wire [6:0] db_contagem_out;
    wire [6:0] db_memoria_out;
    wire [6:0] db_jogadafeita_out;
    wire [6:0] db_sequencia_out;
    wire [6:0] db_estado_out;

    // Configuração do clock
    parameter clockPeriod = 1000; // in us, f=1KHz

    // Identificação do caso de teste
    reg [31:0] caso = 0;

    // Gerador de clock
    always #((clockPeriod / 2)) clock_in = ~clock_in;

    // Instanciação do DUT
    jogo_desafio_memoria dut (
        .clock(clock_in),
        .reset(reset_in),
        .jogar(jogar_in),
        .botoes(botoes_in),
        .ganhou(ganhou_out),
        .perdeu(perdeu_out),
        .timeout(timeout_out),
        .pronto(pronto_out),
        .leds(leds_out),
        .db_clock(db_clock_out),
        .db_tem_jogada(db_tem_jogada_out),
        .db_chavesIgualMemoria(db_chavesIgualMemoria_out),
        .db_enderecoIgualSequencia(db_enderecoIgualSequencia_out),
        .db_fimS(db_fimS_out),
        .db_contagem(db_contagem_out),
        .db_memoria(db_memoria_out),
        .db_jogadafeita(db_jogadafeita_out),
        .db_sequencia(db_sequencia_out),
        .db_estado(db_estado_out)
    );

    // Gabarito
    reg [3:0] jogadas[0:15];
    initial begin
        jogadas[0] = 4'b0001;
        jogadas[1] = 4'b0010;
        jogadas[2] = 4'b0100;
        jogadas[3] = 4'b1000;
        jogadas[4] = 4'b0100;
        jogadas[5] = 4'b0010;
        jogadas[6] = 4'b0001;
        jogadas[7] = 4'b0001;
        jogadas[8] = 4'b0010;
        jogadas[9] = 4'b0010;
        jogadas[10] = 4'b0100;
        jogadas[11] = 4'b0100;
        jogadas[12] = 4'b1000;
        jogadas[13] = 4'b1000;
        jogadas[14] = 4'b0001;
        jogadas[15] = 4'b0100;
    end

    // Variáveis de loop
    integer i, j;

    // Geração dos estímulos de entrada
    initial begin
        $display("Inicio da simulacao");

        // Condições iniciais
        caso = 0;
                $display("case");

        clock_in = 1;
                $display("clock_in");

        reset_in = 0;
                $display("reset");

        jogar_in = 0;
                $display("jogar");


        botoes_in = 4'b0000;
        #(clockPeriod);
                $display("clock");


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
        for (i = 3; i <= 18; i = i + 1) begin
            #(1_000_000 * (i - 2));
            caso = i;
            @(negedge clock_in);

            for (j = 0; j < 16; j = j + 1) begin
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
