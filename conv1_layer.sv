`timescale 1ns / 1ps
module conv1_layer(
    input clk,
    input rst_n,
    input [31:0] data_in,
    input valid_in,
    output [31:0] conv1_out[0:31], // 31 <= filter_num
    output valid_out
    );
wire [31:0] buf_data [0:8];
wire valid_out_buf;

conv1_buf #(.WIDTH(28), .HEIGHT(36), .DATA_BITS(32)) conv1_buf (
    .clk(clk),
    .rst_n(rst_n),
    .valid_in(valid_in),
    .data_in(data_in),
    .data_out(buf_data),
    .valid_out_buf(valid_out_buf)
    );
    
conv1_calc conv1_calc (
    .clk(clk),
    .rst_n(rst_n),
    .data_out(buf_data),
    .valid_in(valid_out_buf),
    .conv1_out(conv1_out),
    .valid_conv1(valid_out)
    );
    
endmodule
