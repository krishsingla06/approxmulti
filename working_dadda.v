
module multiplier_4x4 (
    input  [3:0] A,   // 4-bit input A
    input  [3:0] B,   // 4-bit input B
    output [7:0] P    // 8-bit output product
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
    

    //Dadda tree


    wire s1, c1;
    half_adder ha1 (.a(pp3_0),.b(pp2_1),.sum(s1),.carry(c1));

    wire s2,c2;
    half_adder ha2 (.a(pp3_1),.b(pp2_2),.sum(s2),.carry(c2));

    wire s3,c3;
    half_adder ha3 (.a(pp1_1),.b(pp0_2),.sum(s3),.carry(c3));

    wire s4,c4;
    full_adder fa1 (.a(s1), .b(pp1_2), .cin(pp0_3), .sum(s4), .carry(c4));

    wire s5,c5;
    full_adder fa2 (.a(s2), .b(pp1_3), .cin(c1), .sum(s5), .carry(c5));


    wire s6,c6;
    full_adder fa3 (.a(c2),.b(pp2_3),.cin(pp3_2),.sum(s6),.carry(c6));
    
    wire s7,c7;
    half_adder ha4(.a(pp1_0),.b(pp0_1),.sum(s7),.carry(c7));

    wire s8,c8;
    full_adder fa4 (.a(s3), .b(pp2_0), .cin(c7), .sum(s8), .carry(c8));

    wire s9,c9;
    full_adder fa5 (.a(s4), .b(c8), .cin(c3), .sum(s9), .carry(c9));

    wire s10,c10;   
    full_adder fa6 (.a(s5), .b(c9), .cin(c4), .sum(s10), .carry(c10));

    wire s11,c11;
    full_adder fa7 (.a(s6), .b(c10), .cin(c5), .sum(s11), .carry(c11));

    wire s12,c12;
    full_adder fa8 (.a(pp3_3), .b(c11), .cin(c6), .sum(s12), .carry(c12));

    assign P[0] = pp0_0;
    assign P[1] = s7;
    assign P[2] = s8;
    assign P[3] = s9;
    assign P[4] = s10;
    assign P[5] = s11;
    assign P[6] = s12;
    assign P[7] = c12;

endmodule


module half_adder (
    input a,
    input b,
    output sum,
    output carry
);
    assign sum = a ^ b;
    assign carry = a & b;
endmodule

// Full adder module
module full_adder (
    input a,
    input b,
    input cin,
    output sum,
    output carry
);
    assign sum = a ^ b ^ cin;
    assign carry = (a & b) | (b & cin) | (a & cin);
endmodule