`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/13/2025 06:12:24 PM
// Design Name: 
// Module Name: tb_assertion_quiz_setup_hold_grok
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


module tb_assertion_quiz_setup_hold_grok(

    input logic clk,
    input logic a,
    input logic b,
    input logic c,
    input logic req,
    input logic ack,
    input logic grant,
    input logic data_valid,
    input logic data,
    input logic start,
    input logic stop,
    input logic done,
    input logic flag,
    input logic error,
    input logic sig,
    input logic sig1,
    input logic sig2,
    input logic enable,
    input logic reset,
    input logic control
    
);
    
    
//    # Setup and Hold Time Violation Scenarios

//This artifact contains 20 scenarios for checking setup and hold time violations in SystemVerilog assertions with specific timing requirements (e.g., 200ps before or 500ps after a clock edge). Each scenario includes at least one correct assertion, with up to three alternatives where applicable.

//## Scenarios

// 1. Check that `data` is stable 200ps before `posedge clk` for setup time.
   //Description: Ensure `data` does not change within 200ps before the rising clock edge.
   Answer_1a: assert property (@(posedge clk) $stable(data) throughout ($realtime >= $realtime + 200ps));
   Answer_1b: assert property (@(posedge clk) ##[-0.2ns] $stable(data)); // Assuming 1ns = 1000ps`

// 2. Verify that `sig` holds its value for 300ps after `posedge clk` for hold time.
   //Description: Ensure `sig` remains stable for at least 300ps after the clock edge.
   Answer_2a: assert property (@(posedge clk) ##[0:0.3ns] $stable(sig));
   Answer_2b: assert property (@(posedge clk) sig == $past(sig) throughout ($realtime <= $realtime + 300ps));

// 3. Ensure `control` is stable 500ps before `posedge clk` for setup time.
   //Description: `control` must not change within 500ps before the clock edge.
   Answer_3a: assert property (@(posedge clk) $stable(control) throughout ($realtime >= $realtime 500ps));
   Answer_3b: assert property (@(posedge clk) ##[-0.5ns] $stable(control));

// 4. Check that `data` holds for 400ps after `posedge clk` for hold time.
   //Description: `data` must remain stable for 400ps after the clock edge.
   Answer_4a: assert property (@(posedge clk) ##[0:0.4ns] $stable(data));
   Answer_4b: assert property (@(posedge clk) data == $past(data) throughout ($realtime <= $realtime + 400ps));

// 5. Verify that `req` is stable 250ps before `posedge clk` when `enable` is high.
   //Description: When `enable` is high, `req` must not change 250ps before the clock edge.
   Answer_5a: assert property (@(posedge clk) enable |-> $stable(req) throughout ($realtime >= $realtime 250ps));
   Answer_5b: assert property (@(posedge clk) enable |-> ##[-0.25ns] $stable(req));

// 6. Ensure `ack` holds for 600ps after `posedge clk` when `grant` is high.
   //Description: When `grant` is high, `ack` must remain stable for 600ps after the clock edge.
   Answer_6a: assert property (@(posedge clk) grant |-> ##[0:0.6ns] $stable(ack));
   Answer_6b: assert property (@(posedge clk) grant |-> ack == $past(ack) throughout ($realtime <= $realtime + 600ps));

// 7. Check that `sig1` is stable 300ps before `posedge clk` and `sig2` is high.
   //Description: When `sig2` is high, `sig1` must not change 300ps before the clock edge.
   Answer_7a: assert property (@(posedge clk) sig2 |-> $stable(sig1) throughout ($realtime >= $realtime 300ps));
   Answer_7b: assert property (@(posedge clk) sig2 |-> ##[-0.3ns] $stable(sig1));

// 8. Verify that `data` holds for 200ps after `posedge clk` when `clk` is 2ns period.
   //Description: With a 2ns clock period, `data` must remain stable for 200ps after the clock edge.
   Answer_8a: assert property (@(posedge clk) ##[0:0.2ns] $stable(data));
   Answer_8b: assert property (@(posedge clk) data == $past(data) throughout ($realtime <= $realtime + 200ps));

// 9. Ensure `control` is stable 400ps before `negedge clk` for setup time.
   //Description: `control` must not change 400ps before the falling clock edge.
   Answer_9a: assert property (@(negedge clk) $stable(control) throughout ($realtime >= $realtime 400ps));
   Answer_9b: assert property (@(negedge clk) ##[-0.4ns] $stable(control));

// 10.asm
   //Description: `sig` must remain stable for 500ps after the falling clock edge.
   Answer_10a: assert property (@(negedge clk) ##[0:0.5ns] $stable(sig));
   Answer_10b: assert property (@(negedge clk) sig == $past(sig) throughout ($realtime <= $realtime + 500ps));

// 11. Verify that `data` is stable 150ps before `posedge clk` when `reset` is low.
   //Description: When `reset` is low, `data` must not change 150ps before the clock edge.
   Answer_11a: assert property (@(posedge clk) !reset |-> $stable(data) throughout ($realtime >= $realtime 150ps));
   Answer_11b: assert property (@(posedge clk) !reset |-> ##[-0.15ns] $stable(data));

// 12. Ensure `req` holds for 350ps after `posedge clk` when `ack` is high.
   //Description: When `ack` is high, `req` must remain stable for 350ps after the clock edge.
   Answer_12a: assert property (@(posedge clk) ack |-> ##[0:0.35ns] $stable(req));
   Answer_12b: assert property (@(posedge clk) ack |-> req == $past(req) throughout ($realtime <= $realtime + 350ps));

// 13. Check that `sig` is stable 600ps before `posedge clk` for a 3ns clock period.
   //Description: With a 3ns clock period, `sig` must not change 600ps before the clock edge.
   Answer_13a: assert property (@(posedge clk) $stable(sig) throughout ($realtime >= $realtime 600ps));
   Answer_13b: assert property (@(posedge clk) ##[-0.6ns] $stable(sig));

// 14. Verify that `data` holds for 250ps after `posedge clk` when `enable` is low.
   //Description: When `enable` is low, `data` must remain stable for 250ps after the clock edge.
   Answer_14a: assert property (@(posedge clk) !enable |-> ##[0:0.25ns] $stable(data));
   Answer_14b: assert property (@(posedge clk) !enable |-> data == $past(data) throughout ($realtime <= $realtime + 250ps));

// 15. Ensure `control` is stable 300ps before `posedge clk` and 200ps after for setup and hold.
   //Description: `control` must not change 300ps before and must hold 200ps after the clock edge.
   Answer_15a: assert property (@(posedge clk) $stable(control) throughout ($realtime >= $realtime 300ps && $realtime <= $realtime + 200ps));
   Answer_15b: assert property (@(posedge clk) ##[-0.3ns:0.2ns] $stable(control));

// 16. Check that `sig1` holds for 400ps after `posedge clk` when `sig2` rises.
   //Description: When `sig2` rises, `sig1` must remain stable for 400ps after the clock edge.
   Answer_16a: assert property (@(posedge clk) $rose(sig2) |-> ##[0:0.4ns] $stable(sig1));
   Answer_16b: assert property (@(posedge clk) $rose(sig2) |-> sig1 == $past(sig1) throughout ($realtime <= $realtime + 400ps));

// 17. Verify that `data` is stable 200ps before `negedge clk` when `clk` is 1.5ns period.
   //Description: With a 1.5ns clock period, `data` must not change 200ps before the falling clock edge.
   Answer_17a: assert property (@(negedge clk) $stable(data) throughout ($realtime >= $realtime 200ps));
   Answer_17b: assert property (@(negedge clk) ##[-0.2ns] $stable(data));

// 18. Ensure `req` holds for 500ps after `posedge clk` when `grant` falls.
   //Description: When `grant` falls, `req` must remain stable for 500ps after the clock edge.
   Answer_18a: assert property (@(posedge clk) $fell(grant) |-> ##[0:0.5ns] $stable(req));
   Answer_18b: assert property (@(posedge clk) $fell(grant) |-> req == $past(req) throughout ($realtime <= $realtime + 500ps));

// 19. Check that `sig` is stable 400ps before `posedge clk` when `error` is low.
   //Description: When `error` is low, `sig` must not change 400ps before the clock edge.
   Answer_19a: assert property (@(posedge clk) !error |-> $stable(sig) throughout ($realtime >= $realtime 400ps));
   Answer_19b: assert property (@(posedge clk) !error |-> ##[-0.4ns] $stable(sig));

// 20. Verify that `data` holds for 300ps after `negedge clk` and is stable 200ps before.
   //Description: `data` must not change 200ps before and must hold 300ps after the falling clock edge.
   Answer_20a: assert property (@(negedge clk) $stable(data) throughout ($realtime >= $realtime 200ps && $realtime <= $realtime + 300ps));
   Answer_20b: assert property (@(negedge clk) ##[-0.2ns:0.3ns] $stable(data));
endmodule
