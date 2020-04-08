
module test;
    reg [31:0] a;
    wire s;
    reg cin,clk,reset;
    wire [7:0]o,d_out ;
    wire cout;
    
   initial clk = 0;
   always #15 clk = ~clk; //We are actually taking the clock period = 30 nsec.
   initial reset=0;
   initial cin=0;
 
   execute e1(o,d_out,cout,a,clk,reset,cin);
    //At each 20 ns , we are supplying new input to the processor.
   initial begin
      # 20 a = 32'b10000000000000000000000000000000;
      # 20 a = 32'b10000000000000000000000000010000;
      # 20 a = 32'b00000000010000000000000000010000;
      # 20 a = 32'b00100000000000000000011010010010;
      # 20 a = 32'b10000000000000000000100000001000;
      # 20 a = 32'b10000000000000000000010000100000;
      # 20 a = 32'b10000000000000000000010000100000;
      # 20 a = 32'b10000000000000000000010000111111;
      # 20 a = 32'b10000000000000000000010000100100;
      # 20 a = 32'b10000000000000000000010000101100;
      # 20 a = 32'b10000000000000000000010000111100;
      # 20 a = 32'b10000000000000000000010000100011;
   $finish;
   end
   
   initial 
    begin 
    $monitor("Time=%d , a = %b , a[15:8]=%d , a[7:0]=%d , s = %d , o=%b , d_out=%b , cout = %d",$time , a ,a[15:8],a[7:0], a[31],o,d_out,cout);  //d_out is the ouput which we had stored in the memory. 
    
    end 
   initial begin
        $dumpfile("proc.vcd");
        $dumpvars;
    end
endmodule
