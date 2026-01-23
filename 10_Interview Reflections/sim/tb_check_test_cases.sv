`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/12/2025 09:37:31 AM
// Design Name: 
// Module Name: tb_check_test_cases
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


module tb_check_test_cases();


  int x, y;

  // 1️⃣ Pass-by-VALUE (default)
  function void pass_by_value(int a, int b);
    a = a + 10;
    b = b + 20;
    $display("  [pass_by_value] a=%0d, b=%0d", a, b);
  endfunction

  // 2️⃣ Pass-by-VALUE with AUTOMATIC
  function automatic void auto_no_ref(int a, int b);
    a = a + 10;
    b = b + 20;
    $display("  [auto_no_ref]   a=%0d, b=%0d", a, b);
  endfunction

  // 3️⃣ Pass-by-REFERENCE (ref)
  function void pass_by_ref(ref int a, ref int b);
    a = a + 10;
    b = b + 20;
    $display("  [pass_by_ref]   a=%0d, b=%0d", a, b);
  endfunction

  // 4️⃣ AUTOMATIC + REFERENCE
  function automatic void auto_ref(ref int a, ref int b);
    int temp_a = a + 10;
    int temp_b = b + 20;
    a = temp_a;
    b = temp_b;
    $display("  [auto_ref]      a=%0d, b=%0d", a, b);
  endfunction

  // 🧪 Run comparisons
  initial begin
    $display("===== SystemVerilog Argument Passing Demo =====\n");

    x = 1; y = 2;
    $display("Initial Values: x=%0d, y=%0d", x, y);

    pass_by_value(x, y);
    $display("After pass_by_value: x=%0d, y=%0d\n", x, y);

    auto_no_ref(x, y);
    $display("After auto_no_ref:   x=%0d, y=%0d\n", x, y);

    pass_by_ref(x, y);
    $display("After pass_by_ref:   x=%0d, y=%0d\n", x, y);

    auto_ref(x, y);
    $display("After auto_ref:      x=%0d, y=%0d\n", x, y);

    $display("===== End of Demo =====");
  end



endmodule
