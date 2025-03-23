module square_wave #(
    parameter CLK_FREQ = 50000000  // Default to 50 MHz; override during instantiation
)(
    input wire clk,
    input wire rst,
    input wire [31:0] freq,        // Desired frequency in Hz
    output reg out                 // Output to active buzzer
);
    reg        out_reg = 0;
    reg [31:0] counter = 0;
    reg [31:0] half_period = 1;

    assign out = out_reg;

    always @(*) begin
        // Avoid division by zero
        if (freq == 0)
            half_period = 32'hFFFFFFFF;
        else
            half_period = CLK_FREQ / (freq * 2);
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 0;
            out_reg <= 0;
        end else begin
            if (counter >= half_period) begin
                counter <= 0;
                out_reg <= ~out_reg;  // Toggle output for square wave
            end else begin
                counter <= counter + 1;
            end
        end
    end
endmodule
