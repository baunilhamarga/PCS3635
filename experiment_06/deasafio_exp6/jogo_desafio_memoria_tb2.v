`timescale 1us/1ns

module jogo_desafio_memoria_tb2;

    // Sinais para conectar com o DUT
    reg        clock_in   = 1;
    reg        reset_in   = 0;
    reg        jogar_in = 0;
    reg  [3:0] botoes_in  = 4'b0000;
    reg        nivel_in = 1;
    reg        memoria_in = 0;

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
    wire       db_timeout_out;
    wire       db_timeoutL_out;
    wire       db_seletor_memoria_out;

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
        .nivel(nivel_in),
        .memoria(memoria_in),
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
        .db_estado(db_estado_out),
        .db_timeout(db_timeout_out),
        .db_timeoutL(db_timeoutL_out),
        .db_seletor_memoria(db_seletor_memoria_out)
    );

    // Gabarito
    reg [3:0] jogadas_caso1[0:15];
    reg [3:0] jogadas_caso2[0:15];

    initial begin
        jogadas_caso1[0] = 4'b0001;
        jogadas_caso1[1] = 4'b0010;
        jogadas_caso1[2] = 4'b0100;
        jogadas_caso1[3] = 4'b1000;
        jogadas_caso1[4] = 4'b0100;
        jogadas_caso1[5] = 4'b0010;
        jogadas_caso1[6] = 4'b0001;
        jogadas_caso1[7] = 4'b0001;
        jogadas_caso1[8] = 4'b0010;
        jogadas_caso1[9] = 4'b0010;
        jogadas_caso1[10] = 4'b0100;
        jogadas_caso1[11] = 4'b0100;
        jogadas_caso1[12] = 4'b1000;
        jogadas_caso1[13] = 4'b1000;
        jogadas_caso1[14] = 4'b0001;
        jogadas_caso1[15] = 4'b0100;
    end

    initial begin
        jogadas_caso2[0] = 4'b0001;
        jogadas_caso2[1] = 4'b0001;
        jogadas_caso2[2] = 4'b0001;
        jogadas_caso2[3] = 4'b0001;
        jogadas_caso2[4] = 4'b0010;
        jogadas_caso2[5] = 4'b0010;
        jogadas_caso2[6] = 4'b0010;
        jogadas_caso2[7] = 4'b0010;
        jogadas_caso2[8] = 4'b0100;
        jogadas_caso2[9] = 4'b0100;
        jogadas_caso2[10] = 4'b0100;
        jogadas_caso2[11] = 4'b0100;
        jogadas_caso2[12] = 4'b1000;
        jogadas_caso2[13] = 4'b1000;
        jogadas_caso2[14] = 4'b1000;
        jogadas_caso2[15] = 4'b1000;
    end

    // Variáveis de loop
    integer i, j;

    // Geração dos estímulos de entrada
    initial begin
        $display("Inicio da simulacao");

        // Condições iniciais
        caso = 0;
        clock_in = 1;
        reset_in = 0;
        jogar_in = 0;
        botoes_in = 4'b0000;
        #(clockPeriod);

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
        for (i = 3; i <= 6; i = i + 1) begin
            #(1_000_000 * (i - 2));
            memoria_in = ~(memoria_in);
            #(500_000);
            caso = i;
            @(negedge clock_in);

            for (j = 0; j < i-2; j = j + 1) begin
                if (i == 6 &&  j == 2) begin
                    botoes_in = 4'b0010;
                    j = i - 2;
                end
                else begin
                    botoes_in = jogadas_caso1[j];
                end
                #(10 * clockPeriod);
                botoes_in = 4'b0000;
                #(10 * clockPeriod);
            end
        end

        // Teste 7: Acionar o sinal jogar e mudar nivel
        caso = 7;
        #(2 * clockPeriod);
        jogar_in = 1;
        memoria_in = 1;
        #(5 * clockPeriod);
        jogar_in = 0;
        #(10 * clockPeriod);

        // Testes de jogadas
        for (i = 8; i <= 9; i = i + 1) begin
            #(1_000_000 * (i - 7));
            #(500_000);
            caso = i;
            @(negedge clock_in);

            for (j = 0; j < i-7; j = j + 1) begin
                if (i == 9 &&  j == 1) begin
                    botoes_in = 4'b0100;
                    j = i - 7;
                end
                else begin
                    botoes_in = jogadas_caso2[j];
                end
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
