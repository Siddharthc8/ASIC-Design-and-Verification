`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/16/2024 01:35:30 AM
// Design Name: 
// Module Name: tb_mailbox_custom_constructor
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_mailbox_custom_constructor();


    class Generator;
    
        int data = 12;
        mailbox mbx;         // Syntax : mailbox mailbox_name       //   Declared a mailbox
        
        function new(mailbox mbx);      // with an argument that holds mailbox type and name
            
            this.mbx = mbx;
        
        endfunction
        
        
        task run();
            
            mbx.put(data);     //  Mailbox used to send data to another mailbox in another class
            $display("[GEN] : Sent data: %0d", data);
            
        endtask
    endclass
    
    
    class Driver;
        
        int datac = 0;     // to store the data captured or got
        mailbox mbx;   // Decalred a mailbox 
        
        function new(mailbox mbx);      // with an argument that holds mailbox type and name
            
            this.mbx = mbx;
        
        endfunction                                                  
        
        task run();
            
            mbx.get(datac);   //   //  Mailbox used to receive data from another mailbox in another class
            $display("[DRV] : Received data: %0d", datac);
            
        endtask
    endclass
    
    class Main;
        
        Generator gen;
        Driver drv;
        mailbox mbx;        //  Mailbox handler whoch means we have to call a constructor
        
        task run();    
            
            mbx = new();
            
            // This custom constructor passes the name to the mailbox in that particular task
            gen = new(mbx);   //  Eliminates     ==> gen.mbx = mbx;     |    data  ---->|    |  Both the mailboxes are now linked 
            drv = new(mbx);   //  the need for   ==> drv.mbx = mbx;     |    datac <----|    |  internally within their own classes
            
            gen.run();
            drv.run();
                    
        endtask
    
    endclass
    
    
 // .........................Main module starts....................... 
    
    Main main;
    
    initial begin
    
        main = new();
        main.run();
        
    end

endmodule
