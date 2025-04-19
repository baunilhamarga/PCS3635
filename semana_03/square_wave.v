module square_wave #(
    parameter CLK_FREQ   = 50_000_000,  // Clock frequency in Hz
    parameter DUTY_CYCLE = 50         // Duty cycle as a percentage (0–100)
)(
    input  wire        clk,
    input  wire        rst,
    input  wire [31:0] freq,          // Desired frequency in Hz
    output wire        out            // Output square wave
);

    reg        out_reg   = 0;
    reg [31:0] counter   = 0;
    reg [31:0] period    = 1;
    reg [31:0] high_time = 1;

    assign out = out_reg;

    // Combinational block to calculate period and high_time.
    always @(*) begin
        if (freq == 0) begin
            period    = 32'hFFFFFFFF;  // Effectively disable toggling when freq is 0
            high_time = 0;
        end else begin
            // Compute period and ensure it is at least 1.
            if ((CLK_FREQ / freq) == 0)
                period = 1;
            else
                period = CLK_FREQ / freq;

            high_time = (period * DUTY_CYCLE) / 100;
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter  <= 0;
            out_reg  <= 0;
        end else begin
            if (counter >= period)
                counter <= 0;
            else
                counter <= counter + 1;

            out_reg <= (counter < high_time) ? 1'b1 : 1'b0;
        end
    end

endmodule
