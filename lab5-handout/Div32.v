/* Div32.v
 * 32-bit Radix-2 signed & unsigned divider
 * Based off of the algorithm in P&H
 *
 * Author: Joshua Wise
 */

module Div32(quotient, remainder, busy, dividend, divisor, start, clk, signd, rst_b);

	input              clk, rst_b;
	
	input              start, signd;
	output wire        busy;
	
	input       [31:0] dividend, divisor;
	output reg  [31:0] quotient, remainder;
	
	reg [63:0] qr;
	reg  [5:0] curbit = 0;
	
	wire busy_0a = (curbit != 0);
	reg busy_1a = 0; /* It takes one more cycle to make it through. */
	assign busy = busy_0a || busy_1a;
	
	reg [31:0] cur_divisor;
	wire [32:0] diff = qr[63:31] - {1'b0,cur_divisor};
	reg sign_dividend = 0, sign_divisor = 0;
	
	always @(posedge clk or negedge rst_b) begin
		if (!rst_b) begin
			qr <= {64{1'bx}};
			cur_divisor <= {32{1'bx}};
			curbit <= 6'h0;
			sign_dividend <= 0;
			sign_divisor <= 0;
			busy_1a <= 0;
		end else begin
			busy_1a <= busy_0a;
			if (!busy && start) begin
				curbit <= 32;
				sign_dividend <= signd && dividend[31];
				sign_divisor  <= signd && divisor[31];
				
				qr <= {32'h0, (signd && dividend[31]) ? ~dividend + 1 : dividend};
				cur_divisor <= (signd && divisor[31]) ? ~divisor + 1 : divisor;
			end else if (busy_0a) begin
				if (diff[32])
					qr <= {qr[62:0], 1'b0};
				else
					qr <= {diff[31:0], qr[30:0], 1'b1};
				
				curbit <= curbit - 6'h1;
			end
			
			if (!busy_0a) begin
				quotient  <= (sign_dividend ^ sign_divisor) ? ~qr[31:0] + 1 : qr[31:0];
				remainder <= sign_dividend ? ~qr[63:32] + 1 : qr[63:32];
			end
		end
	end
endmodule
