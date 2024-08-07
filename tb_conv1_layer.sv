`timescale 1ns / 1ps

module tb_conv1_layer;
reg clk;
reg rst_n;
reg [31:0] data;
reg valid_in;
wire valid_out;
wire [31:0] conv1_out[0:8];
conv1_layer conv1_layer (
   .clk(clk),
   .rst_n(rst_n),
   .valid_in(valid_in),
   .valid_out(valid_out),
   .data_in(data),
   .conv1_out(conv1_out)
   );

// Clock generation
initial begin
clk = 0;
forever #5 clk = ~clk;
end

initial begin
valid_in = 0 ;
rst_n = 1;
#2 rst_n = 0;
#2 rst_n = 1;
#1 valid_in = 1;
data = $random;
for (int i = 0; i<28*36;i=i+1) begin
#10 data = $random;
end
valid_in = 0;
#5000
$finish;
end

endmodule
