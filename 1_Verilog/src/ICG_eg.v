module ICG (
    input clk,         // Main clock input
    input enable,       // Enable signal to control clock gating
    input [7:0] data_in,
    output reg [7:0] data_out
);

// Clock gating cell
reg gated_clk;

// Use asynchronous enable to control clock gating
always @(posedge clk or posedge enable) begin
    if (enable)
        gated_clk <= clk;  // Enable clock if enable signal is asserted
    else
        gated_clk <= 1'b0;  // Disable clock if enable signal is deasserted
end

// Use gated clock for sequential logic
always @(posedge gated_clk) begin
    // Your sequential logic here
    data_out <= data_in;  // Example: pass data through
end

endmodule
