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

wire pr02 = (A[0] & B[2]) | (A[2] & B[0]);
wire g02 = A[0] & B[2] & A[2] & B[0];

wire pr03 = (A[0] & B[3]) | (A[3] & B[0]);
wire g03 = A[0] & B[3] & A[3] & B[0];

wire pr12 = (A[1] & B[2]) | (A[2] & B[1]);
wire g12 = A[1] & B[2] & A[2] & B[1];

wire pr13 = (A[1] & B[3]) | (A[3] & B[1]);
wire g13 = A[1] & B[3] & A[3] & B[1];

wire pr23 = (A[2] & B[3]) | (A[3] & B[2]);
wire g23 = A[2] & B[3] & A[3] & B[2];

wire or1 = g03|g12;

// wire s1,c1;
// approx_full_adder f1(pp1_1,pr02,g02,s1,c1);

// wire s2,c2;
// approx_full_adder f2(or1,pr03,pr12,s2,c2);

wire s1,c1;
//approx_full_adder f1(pp1_1,pr02,g02,s1,c1); //11
//approx_full_adder f1(pp1_1,g02,pr02,s1,c1); 12
//approx_full_adder f1(g02,pr02,pp1_1,s1,c1); 11
approx_full_adder f1(g02,pp1_1,pr02,s1,c1); //11
//approx_full_adder f1(pr02,pp1_1,g02,s1,c1); //14
//approx_full_adder f1(pr02,g02,pp1_1,s1,c1); //16

wire s2,c2;
approx_full_adder f2(pr03,pr12,or1,s2,c2);

wire s3,c3;
full_adder f3(pp2_2,pr13,g13,s3,c3);

wire s4,c4;
half_adder f4(pr23,g23,s4,c4);

assign P[0] = pp0_0;
assign P[1] = (A[1] & B[0]) | (A[0] & B[1]);

wire s5,c5;
assign P[2] = s1;

wire s6,c6;
half_adder f6(s2,c1,s6,c6);
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

assign sum = b;
assign carry = a;

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



