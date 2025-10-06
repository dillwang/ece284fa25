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

// For sign-magnitude multiplication
wire sign_a = a_q[bw-1];
wire sign_b = b_q[bw-1];
wire [bw-2:0] mag_a = a_q[bw-2:0];
wire [bw-2:0] mag_b = b_q[bw-2:0];
wire sign_mult = sign_a ^ sign_b;
wire [2*bw-3:0] mag_mult = mag_a * mag_b;
wire signed [psum_bw-1:0] mult_signed = sign_mult ? -$signed({1'b0, mag_mult}) : $signed({1'b0, mag_mult});

assign out = format ? (psum_q[psum_bw-1] ? {1'b1, -psum_q[psum_bw-2:0]} : {1'b0, psum_q[psum_bw-2:0]}) : psum_q;

always_ff @(posedge clk) begin
    if (reset) begin
        psum_q <= 0;
        a_q <= 0;
        b_q <= 0;
    end else begin
        a_q <= A;
        b_q <= B;
        if (acc) begin
            if (format) begin
                psum_q <= psum_q + mult_signed; // Accumulate the product using sign-magnitude
            end else begin
                psum_q <= psum_q + (a_q * b_q); // Accumulate the product using 2's complement
            end
        end else begin
            psum_q <= psum_q; // Maintain the previous value
        end
    end
end

endmodule
