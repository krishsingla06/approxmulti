

module multiplier_4x4 (
    input  [3:0] A,    // 4-bit input A
    input  [3:0] B,    // 4-bit input B
    output [7:0] P     // 8-bit output product
);

// Partial product generation (AND gates)
wire pp0_0 = A[0] & B[0];
wire pp0_1 = A[1] & B[0];
wire pp0_2 = A[2] & B[0];
wire pp0_3 = A[3] & B[0];

wire pp1_0 = A[0] & B[1];
wire pp1_1 = A[1] & B[1];
wire pp1_2 = A[2] & B[1];
wire pp1_3 = A[3] & B[1];

wire pp2_0 = A[0] & B[2];
wire pp2_1 = A[1] & B[2];
wire pp2_2 = A[2] & B[2];
wire pp2_3 = A[3] & B[2];

wire pp3_0 = A[0] & B[3];
wire pp3_1 = A[1] & B[3];
wire pp3_2 = A[2] & B[3];
wire pp3_3 = A[3] & B[3];

assign P[0] = pp0_0;

assign P[1] = pp0_1|pp1_0; // Approximate compressors to reduce error , p(pp1_0=1 , pp0_1=1) = 1/16

wire s0,c0;
approx_full_adder f0(.a(pp2_0),.b(pp1_1),.cin(pp0_2),.sum(s0),.carry(c0));

wire s1,c1;
approx_4_2compressor f1(.a(pp3_0),.b(pp2_1),.c(pp1_2),.d(pp0_3),.sum(s1),.carry(c1));

wire s2,c2;
full_adder f2(.a(pp3_1),.b(pp2_2),.cin(pp1_3),.sum(s2),.carry(c2));

wire s3,c3;
half_adder f3(.a(pp2_3),.b(pp3_2),.sum(s3),.carry(c3));

assign P[2] = s0;

wire s4,c4;
half_adder f4(.a(s1),.b(c0),.sum(s4),.carry(c4));

wire s5,c5;
full_adder f5(.a(s2),.b(c1),.cin(c4),.sum(s5),.carry(c5));

wire s6,c6;
full_adder f6(.a(s3),.b(c2),.cin(c5),.sum(s6),.carry(c6));

wire s7,c7;
full_adder f7(.a(pp3_3),.b(c3),.cin(c6),.sum(s7),.carry(c7));

assign P[3] = s4;
assign P[4] = s5;
assign P[5] = s6;
assign P[6] = s7;
assign P[7] = c7;



// Approximate compressors to reduce error

// First 3-2 compressor (approximate sum and carry reduction)
// wire s1, s2, c1, c2;
// approx_compressor3_2 comp1 (.a(pp3_0), .b(pp2_1), .c(pp1_2), .sum(s1), .carry(c1));
// approx_compressor3_2 comp2 (.a(pp3_1), .b(pp2_2), .c(pp1_3), .sum(s2), .carry(c2));

// // Second 3-2 compressor (approximate sum and carry reduction)
// wire s3, s4, c3, c4;
// approx_compressor3_2 comp3 (.a(pp0_2), .b(pp1_0), .c(pp2_0), .sum(s3), .carry(c3));
// approx_compressor3_2 comp4 (.a(pp0_3), .b(pp1_1), .c(pp2_3), .sum(s4), .carry(c4));

// // Full adders for additional reduction and final sum
// wire s5, c5;
// full_adder fa1 (.a(s1), .b(s3), .cin(c1), .sum(s5), .carry(c5));

// wire s6, c6;
// full_adder fa2 (.a(s2), .b(s4), .cin(c2), .sum(s6), .carry(c6));

// // Final reduction using full adders
// wire s7, c7;
// full_adder fa3 (.a(s5), .b(s6), .cin(c3), .sum(s7), .carry(c7));

// wire s8, c8;
// full_adder fa4 (.a(c5), .b(c6), .cin(c4), .sum(s8), .carry(c8));

// // Output assignment
// assign P[0] = pp0_0;
// assign P[1] = s1;
// assign P[2] = s3;
// assign P[3] = s5;
// assign P[4] = s7;
// assign P[5] = s8;
// assign P[6] = c7;
// assign P[7] = c8;

endmodule

module approx_half_adder (
    input a, b,
    output sum, carry
);

assign sum = a | b;
assign carry = a & b;

endmodule

module approx_full_adder (
    input a, b, cin,
    output sum, carry
);

assign sum = (a|b) ^ cin;
assign carry = (a&b) | (b&cin);

endmodule

module approx_4_2compressor (
    input a, b, c, d,
    output sum, carry
);

//assign sum = (a&b)&(c&d) | (a&b)&(c|d);
assign sum = a|b|c|d;
assign carry = a|b;

endmodule

module full_adder(
    input a, b, cin,
    output sum, carry
);

assign sum = a ^ b ^ cin;
assign carry = (a & b) | (b & cin) | (a & cin);

endmodule

module half_adder(
    input a, b,
    output sum, carry
);

assign sum = a ^ b;
assign carry = a & b;

endmodule



