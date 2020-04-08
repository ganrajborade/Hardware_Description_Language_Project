//Decode stage

/*
Basically we have to generate a control signal by looking at a[31:24] (first 8 bits of the input which we are giving).
We are considering here that if a[31] = 1;then our control signal(s) = 1 and otherwise s = 0.So that it will cover all the cases for a[31:24].
*/




module decode(input [31:24] a ,output s);
   wire s = a[31];
endmodule




//Execute Stage

/*
In the Execute stage,Firstly the a[23:0] and s will go into register(Reg1),As soon as the positive edge of clock comes ,thent the data at the input side of Reg1
will get loaded into second block where it will perform the desired operation:Addition and Bitwise AND,(of a[15:8] and a[7:0])  
if s=1;then the block will perform addition operation and gives its output to o.
if s=0;then the block will perform Bitwise AND operation and gives its output to o. 

NOTE THAT THIS OPERATION IS PERFORMED AT THE POSITIVE EDGE OF THE CLOCK PULSE (pipeline concept).Because then it will not get inputs :: a[23:0],s. 
*/




module execute(output [7:0]o,output reg [7:0]d_out ,output cout,input [31:0]a,input clk,reset,cin);
    reg [7:0] mem [0:255];  //Later used in WriteBack Stage
    wire [7:0] z;
//Defining Register1 :  
    reg [23:0]b;
    wire [7:0]x,y;
    wire s;
    wire [7:0] o1,o2;
    decode d1(a[31:24],s);
    always @(posedge clk, reset) begin
        if (reset) begin
            b = 24'b000000000000000000000000;
        end
        else begin
            b <= a[23:0];
        end     
    end
//End of defining first register    
    assign z = a[23:16];
    assign {x,y} = {a[15:8], a[7:0]};

    wide_adder w1(o1,cout,x,y,cin);
    andoperation a1 (o2,x,y);   
   
    wire o = a[31]? o1:o2; 




//WriteBack Stage

/*
In this WriteBack Stage,Firstly at the positive edge of the clock pulse,the Register(Reg2) passes a[23:16] and ouput o from Execute Stage to writeback stage block.
The WriteBack will basically write the output generated (o) to a memory location pointed by bits[23:16] in input a.
*/


//Defining Register2 :
    always @(posedge clk)  begin //Writing the data into a memory
	mem[z] = o;
        d_out=mem[z];
    end

     //Reading the data from memory and storing it into d_out.
 
endmodule


//-------------------------DEFINING FUNCTIONS THAT WILL BE USED IN EXECUTE STAGE.-------------------//


//Defining function for Addition Operation

module fa(output wire s, cout, input wire a, b, cin);
    assign {cout, s} = cin + a + b;
endmodule

module wide_adder #(parameter [7:0] width = 8) (output wire [width-1:0] o, 
    output wire cout, input wire [width-1:0] a, b, input wire cin);

    wire [width:0] c;
    assign c[0] = cin;
    assign cout = c[width];

    genvar n;
    generate
        for(n=0; n<width; n=n+1)
            fa fa(o[n], c[n+1], a[n], b[n], c[n]);
    endgenerate
endmodule

//Defining function for Bitwise AND Operation

module andoperation #(parameter [7:0] width = 8)(output wire [width-1:0] s,input wire [width-1:0] a,b);
    genvar n;
    generate 
        for(n=0; n<width; n=n+1)
            assign s[n] = (a[n] & b[n]);
    endgenerate 
endmodule  


        














 
