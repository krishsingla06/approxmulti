

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

wire or0 = pr02|g02;
wire or1 =pr12|g12|g03; // maybe changes req

wire s0,c0;
half_adder f0(.a(pr13),.b(g13),.sum(s0),.carry(c0));

wire s1,c1;
half_adder f1(.a(pr23),.b(g23),.sum(s1),.carry(c1));


wire s2,c2;
half_adder f2(.a(pr01),.b(g01),.sum(s2),.carry(c2));

wire s3,c3;
full_adder f3(.a(pp1_1),.b(or0),.cin(c2),.sum(s3),.carry(c3));

wire s4,c4;
full_adder f4(.a(pr03),.b(or1),.cin(c3),.sum(s4),.carry(c4));

wire s5,c5;
full_adder f5(.a(pp2_2),.b(s0),.cin(c4),.sum(s5),.carry(c5));

wire s6,c6;
full_adder f6(.a(s1),.b(c0),.cin(c5),.sum(s6),.carry(c6));

wire s7,c7;
full_adder f7(.a(pp3_3),.b(c1),.cin(c6),.sum(s7),.carry(c7));

assign P[0] = pp0_0;
assign P[1] = s2;
assign P[2] = s3;
assign P[3] = s4;
assign P[4] = s5;
assign P[5] = s6;
assign P[6] = s7;
assign P[7] = c7;

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



