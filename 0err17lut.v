

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

wire pr01=pp0_1|pp1_0;
wire g01=pp0_1&pp1_0;
wire pr02=pp0_2|pp2_0;
wire g02=pp0_2&pp2_0;
wire pr03=pp0_3|pp3_0;
wire g03=pp0_3&pp3_0;
wire pr12=pp1_2|pp2_1;
wire g12=pp1_2&pp2_1;
wire pr13=pp1_3|pp3_1;
wire g13=pp1_3&pp3_1;
wire pr23=pp2_3|pp3_2;
wire g23=pp2_3&pp3_2;


wire or1 = g03|g12;


wire s0,c0;
half_adder f0(pr01,g01,s0,c0);

wire s1,c1;
full_adder f1(pp1_1,pr02,g02,s1,c1);

wire s2,c2;
full_adder f2(pr03,pr12,or1,s2,c2);

wire s3,c3;
full_adder f3(pp2_2,pr13,g13,s3,c3);

wire s4,c4;
half_adder f4(pr23,g23,s4,c4);

assign P[0] = pp0_0;
assign P[1] = s0;

wire s5,c5;
half_adder f5(s1,c0,s5,c5);
assign P[2] = s5;

wire s6,c6;
full_adder f6(s2,c1,c5,s6,c6);
assign P[3] = s6;

wire s7,c7;
full_adder f7(s3,c2,c6,s7,c7);
assign P[4] = s7;

wire s8,c8;
full_adder f8(s4,c3,c7,s8,c8);
assign P[5] = s8;

wire s9,c9;
full_adder f9(pp3_3,c4,c8,s9,c9);
assign P[6] = s9;

assign P[7] = c9;

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



