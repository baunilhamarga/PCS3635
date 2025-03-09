`timescale 1us/1ns

module jogo_playseq_tb2;

    // Sinais para conectar com o DUT
    reg        clock_in   = 1;
    reg        reset_in   = 0;
    reg        jogar_in   = 0;
    reg  [3:0] botoes_in  = 4'b0000;
    reg  [1:0] nivel_in   = 2'b00;
    reg  [1:0] memoria_in = 2'b00;

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
    wire       db_seletor_memoria_out;
    wire       db_pare_out;
    wire [1:0] db_contagem_jogo_out;

    // Configuração do clock
    parameter clock_period = 1000; // in us, f=1KHz

    // Identificação do caso de teste
    reg [31:0] caso = 0;

    // Gerador de clock
    always #((clock_period / 2)) clock_in = ~clock_in;

    // Instanciação do DUT
    jogo_playseq dut (
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
        .db_seletor_memoria(db_seletor_memoria_out),
        .db_pare(db_pare_out),
        .db_contagem_jogo(db_contagem_jogo_out)
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
