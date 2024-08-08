module conv1_buf #(parameter WIDTH = 28, HEIGHT = 36, DATA_BITS = 32)( 
   input clk,
   input rst_n, 
   input valid_in,
   input [DATA_BITS - 1:0] data_in,
   output reg [DATA_BITS - 1:0] data_out[0:8],
   output reg valid_out_buf
 );

 localparam FILTER_SIZE = 3;// kernel size = 3x3, so FILTER_SIZE = 3

 reg [DATA_BITS - 1:0] buffer [0:WIDTH * HEIGHT - 1];
 reg [9:0] buf_idx;
 reg [5:0] w_idx, h_idx; // kernel size is 3x3, so w_idx, h_idx = 3bit
 reg state;


 always @(posedge clk or negedge rst_n) begin
 /*--------- reset code ----------*/  
   if(!rst_n) begin
     buf_idx <= 0; // At next cycle, buf_idx will be zero.
     w_idx <= 0;
     h_idx <= 0;
     state <= 0;
     valid_out_buf <= 0;
      data_out[0] <= 32'bx;
      data_out[1] <= 32'bx;
      data_out[2] <= 32'bx;
      data_out[3] <= 32'bx;
      data_out[4] <= 32'bx;
      data_out[5] <= 32'bx;
      data_out[6] <= 32'bx;
      data_out[7] <= 32'bx;
      data_out[8] <= 32'bx;
 /*------------------------------*/    
   end else begin
      // buf_idx definition --------------------
      if(buf_idx == WIDTH * HEIGHT - 1 && state == 0 && valid_in == 1) begin
         state <= 1'b1;
         buf_idx <= 0;
         buffer[buf_idx] <= data_in;
         end else if (state == 0 && valid_in == 1) begin
           buf_idx <= buf_idx + 1;
           buffer[buf_idx] <= data_in;
         end
      
      
      if (state == 0) begin
         valid_out_buf <= 0;
      // State == 1 -> data out start.
      end else if (state == 1) begin
           w_idx <= w_idx + 1;
           valid_out_buf <= 1;
           if (w_idx == WIDTH - FILTER_SIZE) begin
              w_idx <= 0;
              h_idx <= h_idx + 1;
              if (h_idx == HEIGHT - FILTER_SIZE) begin
                  state <= 0;
                  w_idx <= 0;
                  h_idx <= 0;
              end
           end
           data_out[0] <= buffer [w_idx + WIDTH * h_idx];
           data_out[1] <= buffer [w_idx + WIDTH * h_idx + 1];
           data_out[2] <= buffer [w_idx + WIDTH * h_idx + 2];
           
           data_out[3] <= buffer [w_idx + WIDTH * (h_idx + 1)];
           data_out[4] <= buffer [w_idx + WIDTH * (h_idx + 1) + 1];
           data_out[5] <= buffer [w_idx + WIDTH * (h_idx + 1) + 2];
           
           data_out[6] <= buffer [w_idx + WIDTH * (h_idx + 2)];
           data_out[7] <= buffer [w_idx + WIDTH * (h_idx + 2) + 1];
           data_out[8] <= buffer [w_idx + WIDTH * (h_idx + 2) + 2];
      end
    end
  end
endmodule
