`timescale 1us/1ns

module jogo_playseq_tb2;

    // Sinais para conectar com o DUT
    reg        clock_in   = 1;
    reg        reset_in   = 0;
    reg        jogar_in   = 0;
    reg  [3:0] botoes_in  = 4'b0000;
    reg  [1:0] nivel_in   = 2'b00;
    reg  [1:0] memoria_in = 2'b00;
    reg        quer_escrever_in = 0;
    reg  [1:0] timeoutD_in = 2'b10;

    wire       ganhou_out;
    wire       perdeu_out;
    wire [3:0] leds_out;
    wire       db_clock_out;
    wire [6:0] vitorias_out;
    wire [6:0] derrotas_out;

    // Configuração do clock
    parameter clock_period = 1000; // in us, f=1KHz

    // Identificação do caso de teste
    reg [31:0] caso = 0;

    // Gerador de clock
    always #((clock_period / 2)) clock_in = ~clock_in;

    // Instanciação do DUT
    jogo_playseq dut (
        .clockFPGA(clock_in),
        .reset(reset_in),
        .jogar(jogar_in),
        .botoes(botoes_in),
        .nivel(nivel_in),
        .memoria(memoria_in),
        .timeoutD(timeoutD_in),
        .quer_escrever(quer_escrever_in),
        .ganhou(ganhou_out),
        .perdeu(perdeu_out),
        .leds(leds_out),
        .db_clock(db_clock_out),
        .vitorias(vitorias_out),
        .derrotas(derrotas_out)
    );

    // Gabarito
    reg [3:0] jogadas[0:15];

    initial begin
        jogadas[0]  = 4'b0001;
        jogadas[1]  = 4'b0010;
        jogadas[2]  = 4'b1000;
        jogadas[3]  = 4'b0100;
        jogadas[4]  = 4'b0010;
        jogadas[5]  = 4'b1000;
        jogadas[6]  = 4'b0100;
        jogadas[7]  = 4'b0001;
        jogadas[8]  = 4'b1000;
        jogadas[9]  = 4'b0100;
        jogadas[10] = 4'b0001;
        jogadas[11] = 4'b0010;
        jogadas[12] = 4'b0100;
        jogadas[13] = 4'b0001;
        jogadas[14] = 4'b0010;
        jogadas[15] = 4'b1000;
    end

    // Variáveis de loop
    integer i, num_jogadas;

    // Geração dos estímulos de entrada
    initial begin
        $display("Inicio da simulacao");

        // Condições iniciais
        caso = 0;
        clock_in = 1;
        reset_in = 0;
        jogar_in = 0;
        botoes_in = 4'b0000;
        #(clock_period);

        // Caso 1: Reset do circuito
        caso = 1;
        @(negedge clock_in);
        reset_in = 1;
        #(clock_period);
        reset_in = 0;
        #(10 * clock_period);

        // Caso 2: Configuração das dificuldades
        caso = 2;
        #(2 * clock_period);
        nivel_in = 1;  // Número de jogadas por rodada = nivel_in + 1
        memoria_in = 1;  // Memória selecionada
        timeoutD_in = 1;  // Timeout de 10 segundos
        #(2 * clock_period);
        jogar_in = 1;
        #(5 * clock_period);
        jogar_in = 0;
        #(10 * clock_period);

        // num_jogadas = quantidade de termos da sequência mostrados
        // A cada rodada, esperamos num_jogadas segundos para mostrar a sequência
        for (num_jogadas=9; num_jogadas<16; num_jogadas=num_jogadas+nivel_in+2) begin
            caso = caso + 1;
            #(1_000_000 * num_jogadas);
            #(500_000);
            for (i = 0; i <= nivel_in && num_jogadas + i < 16; i = i + 1) begin
                if (num_jogadas + i == 12) begin
                    #(10500 * clock_period);
                end
                botoes_in = jogadas[num_jogadas + i];
                #(500_000);
                botoes_in = 4'b0000;
                #(500_000);
            end
            #(1_000_000);
        end

        #(2 * clock_period);
        nivel_in = 1;  // Número de jogadas por rodada = nivel_in + 1
        memoria_in = 1;  // Memória selecionada
        timeoutD_in = 2;  // Timeout de 5 segundos
        #(2 * clock_period);
        jogar_in = 1;
        #(5 * clock_period);
        jogar_in = 0;
        #(10 * clock_period);

        // num_jogadas = quantidade de termos da sequência mostrados
        // A cada rodada, esperamos num_jogadas segundos para mostrar a sequência
        for (num_jogadas=9; num_jogadas<16; num_jogadas=num_jogadas+nivel_in+2) begin
            caso = caso + 1;
            #(1_000_000 * num_jogadas);
            #(500_000);
            for (i = 0; i <= nivel_in && num_jogadas + i < 16; i = i + 1) begin
                if (num_jogadas + i == 10) begin
                    #(5500 * clock_period);
                end
                botoes_in = jogadas[num_jogadas + i];
                #(500_000);
                botoes_in = 4'b0000;
                #(500_000);
            end
            #(1_000_000);
        end

        // Final da simulação
        caso = 99;
        #1;
        $display("Fim da simulacao");
        $stop;
    end
endmodule
