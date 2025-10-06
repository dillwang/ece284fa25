// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module mac (out, A, B, format, acc, clk, reset);

parameter bw = 8;
parameter psum_bw = 16;

input clk;
input acc;
input reset;
input format;

input signed [bw-1:0] A;
input signed [bw-1:0] B;

output signed [psum_bw-1:0] out;

reg signed [psum_bw-1:0] psum_q;
reg signed [bw-1:0] a_q;
reg signed [bw-1:0] b_q;

assign out = psum_q;

// Your code goes here
always_ff @(posedge clk) begin
    if (reset) begin
        psum_q <= 0;
        a_q <= 0;
        b_q <= 0;
    end else begin
        a_q <= A;
        b_q <= B;
        if (format) begin
            if (acc) begin
                psum_q <= psum_q + (a_q * b_q); // Accumulate the product
            end else begin
                psum_q <= psum_q; // Maintain the previous value
            end
        end else begin
            if (acc) begin
                psum_q <= a_q * b_q; // Just the product
            end else begin
                psum_q <= 0; // Reset to zero if not accumulating
            end 
        end
    end
end

endmodule
