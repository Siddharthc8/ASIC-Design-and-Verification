module tb_a22();
    
    reg [3:0] a,b;
    wire [3:0] y;

    a22 dut (a, b, y);
    
    initial begin
        for(int i = 0; i<10; i++)
        begin
            a = $urandom()%16;
            b = $urandom()%16;
            #5;
        end
        
        a = 0;
        b = 1;
    end
    
endmodule