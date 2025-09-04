`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/07/2025 10:07:06 AM
// Design Name: 
// Module Name: tb_remove_duplicates_meta_coding_2
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


module tb_remove_duplicates_meta_coding_2();

class meta_coding_sec;
    
    int arr[] = '{ 1, 2, 3, 3, 4, 5, 5 };
    int res[int];
    int out[];
    int j;
    
    task rem();
    
        foreach(arr[i]) begin
            
            if (!res.exists(arr[i])) begin
                res[arr[i]] = 1;
            end
        
        end
        
        out = new[res.size()];
        j = 0;
        foreach(res[i]) begin
            out[j] = i;
            j++;
        end
        
        $display("%p", out);
    endtask

endclass



initial begin
    meta_coding_sec mc = new();
    mc.rem();
end


    int arr_r[] = '{ 1, 2, 3, 3, 4, 5, 5 };
    int res_r[$];
    int arr_rr[];
    int l;
    int j;
    
    initial begin
        
        l = arr_r.size();
        arr_rr = new[l](arr_r);
        j = 1;
        
        for(int i = 1; i < arr_rr.size(); i++ ) begin
            if(arr_rr[i] != arr_rr[i-1]) begin
                arr_rr[j] = arr_rr[i];
                j++;
            end
        end       
        
        arr_rr = new[j](arr_rr);
        $display("1: %p", arr_rr);    
    
    end
    
    initial begin
    res_r.push_back(arr_r[0]);
    for(int i = 1; i < arr_r.size(); i++) begin
        if(arr_r[i] != arr_r[i-1]) begin
            res_r.push_back(arr_r[i]);
        end
    end

    
    $display("2: %p", res_r);
    end

endmodule

