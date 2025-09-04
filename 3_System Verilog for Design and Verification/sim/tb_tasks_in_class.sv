`timescale 1s/1ps

module tb_tasks_in_class();

    class First;
        
        int data1;
        bit [7:0] data2;
        shortint data3;
        //   Single argument 
        
//        function new(input int datain = 0);   // Data type for output can be ignored for constructor
//            data = datain;
//        endfunction

        
        // When addressing the same name, to avoid confusion use the keyword "this." inside a constructor
        function new(input int data1=0, input bit [7:0] data2=0, input shortint data3=0);
            this.data1 = data1;
            this.data2 = data2;
            this.data3 = data3;
        
        endfunction
        
        task disp();
            $display("Data1: %0d, Data2: %0d, Data3: %0d",this.data1, this.data2, this.data3);  // "this" keyword is not mandatory/necessary here    Coder's choice
        endtask
        
    endclass
    
    First f1; 
    First f2;
    
    initial begin
        f1 = new(23, , 35);       // Leave the position blank to not fill a value but gotta make sure to set default value in the function or constructor
        f2 = new( , .data1(2), .data2(3));    // Can't exceed 3 arguments as per the constructor
        f1.disp();
        f2.disp();
//        $display("Data1: %0d, Data2: %0d, Data3: %0d",f1.data1, f1.data2, f1.data3);
//        $display("Data1: %0d, Data2: %0d, Data3: %0d",f2.data1, f2.data2, f2.data3);
    end
    
endmodule
