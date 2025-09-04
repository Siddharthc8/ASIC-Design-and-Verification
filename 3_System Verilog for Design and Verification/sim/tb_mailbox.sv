`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/16/2024 12:54:07 AM
// Design Name: 
// Module Name: tb_mailbox
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

// Used to transfer data between classes

module tb_mailbox();

    class Generator;
    
        int data = 12;
        mailbox mbx;         // Syntax : mailbox mailbox_name       //   Declared a mailbox
        
        task run();
            
            mbx.put(data);     //  Mailbox used to send data to another mailbox in another class
            $display("[GEN] : Sent data: %0d", data);
            
        endtask
    endclass
    
    
    class Driver;
        
        int datac = 0;     // to store the data captured or got
        mailbox mbx;   // Decalred a mailbox                                                   
        
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
            
            gen = new();
            drv = new();
            mbx = new();
            
            gen.mbx = mbx;  // data  ---->|       // Linking mailboxes to establish connectivity 
            drv.mbx = mbx;  // datac <----|       // Basically saying the mailboxes are connected by a name    
            
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
