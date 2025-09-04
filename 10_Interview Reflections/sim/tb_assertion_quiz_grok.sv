`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/13/2025 04:41:23 PM
// Design Name: 
// Module Name: tb_assertion_quiz_grok
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


module tb_assertion_quiz_grok(

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

// # SystemVerilog Assertions Quiz

// This quiz contains 100 questions on SystemVerilog assertion operators and 10 additional questions on checking setup and hold time violations using assertions. Each question includes at least one correct answer, with up to three alternatives where applicable.

// ## Part 1: Assertion Operators (100 Questions)

// ### Sequence Operators

// 1. How would you write an assertion to check that signal `a` is high for 3 cycles followed by signal `b` being high for 2 cycles?
   Answer_1a: assert property (@(posedge clk) a[*3] ##1 b[*2]);
   Answer_1b: assert property (@(posedge clk) (a && !b)[*3] ##1 (!a && b)[*2]);

// 2. Write an assertion to verify that `req` is high, and within 5 to 10 cycles, `ack` becomes high.
   Answer_2a: assert property (@(posedge clk) req |-> ##[5:10] ack);
   Answer_2b: assert property (@(posedge clk) req ##[5:10] ack);
   Answer_2c: assert property (@(posedge clk) req && !ack |-> ##[5:10] ack);

// 3. How do you assert that `data_valid` is high, followed by `data` being stable for 4 cycles?
   Answer_3a: assert property (@(posedge clk) data_valid |-> $stable(data)[*4]);
   Answer_3b: assert property (@(posedge clk) data_valid ##1 $stable(data)[*3]);

// 4. Write an assertion to check that `start` is followed by `stop` after exactly 7 cycles.
   Answer_4a: assert property (@(posedge clk) start |-> ##7 stop);
   Answer_4b: assert property (@(posedge clk) start ##7 stop);

// 5. How would you verify that `flag` is high, and `error` does not occur in the next 3 cycles?
   Answer_5a: assert property (@(posedge clk) flag |-> !error[*3]);
   Answer_5b: assert property (@(posedge clk) flag ##1 !error[*3]);

// 6. Write an assertion to check that `req` is followed by `ack` within 1 to 3 cycles, and `grant` is high in the same cycle as `ack`.
   Answer_6a: assert property (@(posedge clk) req |-> ##[1:3] (ack && grant));
   Answer_6b: assert property (@(posedge clk) req ##[1:3] (ack && grant));

// 7. How do you assert that `a` is high, followed by `b` being high in any cycle within the next 10 cycles?
   Answer_7a: assert property (@(posedge clk) a |-> ##[1:10] b);
   Answer_7b: assert property (@(posedge clk) a ##[1:10] b);

// 8. Write an assertion to check that `sig1` is high for 2 cycles, overlapped with `sig2` being high for 1 cycle.
   Answer_8a: assert property (@(posedge clk) sig1[*2] and sig2);
   Answer_8b: assert property (@(posedge clk) (sig1 && sig2) ##1 sig1);

// 9. How would you verify that `enable` is high, followed by `data` changing in the next cycle?
   Answer_9a: assert property (@(posedge clk) enable |-> ##1 $changed(data));
   Answer_9b: assert property (@(posedge clk) enable ##1 $changed(data));

// 10. Write an assertion to ensure that `req` is high, and `ack` occurs repeatedly for 3 cycles within 10 cycles.
   Answer_10a: assert property (@(posedge clk) req |-> ##[1:10] ack[*3]);
   Answer_10b: assert property (@(posedge clk) req ##[1:10] ack[*3]);

// 11. How do you assert that `a` and `b` are high simultaneously for 2 cycles?
   Answer_11a: assert property (@(posedge clk) (a && b)[*2]);
   Answer_11b: assert property (@(posedge clk) a[*2] and b[*2]);
//   Answer_11b: assert property (@(posedge clk) a[*2] && b[*2]);  // Not allowed

// 12. Write an assertion to check that `start` is followed by `done` after at least 5 cycles.
   Answer_12a: assert property (@(posedge clk) start |-> ##[5:$] done);
   Answer_12b: assert property (@(posedge clk) start ##[5:$] done);

// 13. How would you verify that `sig` is high, and `error` does not occur until `sig` goes low?
   Answer_13a: assert property (@(posedge clk) sig |-> !error throughout sig);
   Answer_13b: assert property (@(posedge clk) sig |-> !error until !sig);

// 14. Write an assertion to ensure that `req` is high, and `ack` occurs in the next cycle, followed by `grant` in the cycle after.
   Answer_14a: assert property (@(posedge clk) req |-> ##1 ack ##1 grant);
   Answer_14b: assert property (@(posedge clk) req ##1 ack ##1 grant);

// 15. How do you assert that `a` is high for 2 cycles, non-consecutively within 5 cycles?
   Answer_15a: assert property (@(posedge clk) a[=2] within ##[0:5] 1);
   Answer_15b: assert property (@(posedge clk) a ##[0:3] a within ##[0:5] 1);

// 16. Write an assertion to check that `sig1` is high, followed by `sig2` being high for 3 cycles within 10 cycles.
   Answer_16a: assert property (@(posedge clk) sig1 |-> ##[1:10] sig2[*3]);
   Answer_16b: assert property (@(posedge clk) sig1 ##[1:10] sig2[*3]);

// 17. How would you verify that `req` is high, and `ack` occurs exactly 3 times within 10 cycles?
   Answer_17a: assert property (@(posedge clk) req |-> ack[=3] within ##[1:10] 1);
   Answer_17b: assert property (@(posedge clk) req ##[1:10] ack[=3]);

// 18. Write an assertion to ensure that `start` is high, and `stop` does not occur for the next 5 cycles.
   Answer_18a: assert property (@(posedge clk) start |-> !stop[*5]);
   Answer_18b: assert property (@(posedge clk) start ##1 !stop[*5]);

// 19. How do you assert that `a` is high, followed by `b` being high in the next cycle, and `c` in the cycle after?
   Answer_19a: assert property (@(posedge clk) a |-> ##1 b ##1 c);
   Answer_19b: assert property (@(posedge clk) a ##1 b ##1 c);

// 20. Write an assertion to check that `sig` is high for 3 cycles, and `error` is low during those cycles.
   Answer_20a: assert property (@(posedge clk) sig[*3] |-> !error[*3]);
   Answer_20b: assert property (@(posedge clk) (sig && !error)[*3]);

// 21. How would you verify that `req` is high, and `ack` occurs at least once within 5 cycles?
   Answer_21a: assert property (@(posedge clk) req |-> ##[1:5] ack);
   Answer_21b: assert property (@(posedge clk) req ##[1:5] ack);

// 22. Write an assertion to ensure that `a` is high, and `b` is high for 2 cycles starting 3 cycles later.
   Answer_22a: assert property (@(posedge clk) a |-> ##3 b[*2]);
   Answer_22b: assert property (@(posedge clk) a ##3 b[*2]);

// 23. How do you assert that `sig1` is high, and `sig2` is high repeatedly for 4 cycles within 10 cycles?
   Answer_23a: assert property (@(posedge clk) sig1 |-> ##[1:10] sig2[*4]);
   Answer_23b: assert property (@(posedge clk) sig1 ##[1:10] sig2[*4]);

// 24. Write an assertion to check that `start` is high, and `done` occurs after 2 to 4 cycles.
   Answer_24a: assert property (@(posedge clk) start |-> ##[2:4] done);
   Answer_24b: assert property (@(posedge clk) start ##[2:4] done);

// 25. How would you verify that `a` is high, and `b` does not occur until `c` is high?
   Answer_25a: assert property (@(posedge clk) a |-> !b until c);
   Answer_25b: assert property (@(posedge clk) a |-> !b throughout c);

// 26. Write an assertion to ensure that `req` is high, and `ack` occurs in the same cycle.
   Answer_26a: assert property (@(posedge clk) req |-> ack);
   Answer_26b: assert property (@(posedge clk) req && ack);

// 27. How do you assert that `sig` is high for 5 cycles consecutively?
   Answer_27a: assert property (@(posedge clk) sig[*5]);
   Answer_27b: assert property (@(posedge clk) sig ##1 sig ##1 sig ##1 sig ##1 sig);

// 28. Write an assertion to check that `a` is high, followed by `b` being high non-consecutively 3 times within 10 cycles.
   Answer_28a: assert property (@(posedge clk) a |-> b[=3] within ##[1:10] 1);
   Answer_28b: assert property (@(posedge clk) a ##[1:10] b[=3]);

// 29. How would you verify that `start` is high, and `stop` occurs exactly once within 5 cycles?
   Answer_29a: assert property (@(posedge clk) start |-> stop[=1] within ##[1:5] 1);
   Answer_29b: assert property (@(posedge clk) start ##[1:5] stop);

// 30. Write an assertion to ensure that `sig1` is high, and `sig2` is high for 2 cycles overlapped with `sig1`.
   Answer_30a: assert property (@(posedge clk) sig1 |-> (sig1 && sig2)[*2]);
   Answer_30b: assert property (@(posedge clk) (sig1 && sig2)[*2]);

// 31. How do you assert that `a` is high, and `b` is high in the next cycle, followed by `c` being high for 2 cycles?
   Answer_31a: assert property (@(posedge clk) a |-> ##1 b ##1 c[*2]);
   Answer_31b: assert property (@(posedge clk) a ##1 b ##1 c[*2]);

// 32. Write an assertion to check that `req` is high, and `ack` occurs repeatedly 2 to 4 times within 10 cycles.
   Answer_32a: assert property (@(posedge clk) req |-> ack[=2:4] within ##[1:10] 1);
   Answer_32b: assert property (@(posedge clk) req ##[1:10] ack[=2:4]);

// 33. How would you verify that `sig` is high, and `error` is low until `sig` goes low?
   Answer_33a: assert property (@(posedge clk) sig |-> !error until !sig);
   Answer_33b: assert property (@(posedge clk) sig |-> !error throughout sig);

// 34. Write an assertion to ensure that `a` is high, and `b` is high for 3 cycles starting 2 cycles later.
   Answer_34a: assert property (@(posedge clk) a |-> ##2 b[*3]);
   Answer_34b: assert property (@(posedge clk) a ##2 b[*3]);

// 35. How do you assert that `start` is high, and `done` occurs after at most 10 cycles?
   Answer_35a: assert property (@(posedge clk) start |-> ##[1:10] done);
   Answer_35b: assert property (@(posedge clk) start ##[1:10] done);

// 36. Write an assertion to check that `sig1` is high, and `sig2` is high for 2 cycles non-consecutively within 5 cycles.
   Answer_36a: assert property (@(posedge clk) sig1 |-> sig2[=2] within ##[1:5] 1);
   Answer_36b: assert property (@(posedge clk) sig1 ##[1:5] sig2[=2]);

// 37. How would you verify that `req` is high, and `ack` does not occur for the next 3 cycles?
   Answer_37a: assert property (@(posedge clk) req |-> !ack[*3]);
   Answer_37b: assert property (@(posedge clk) req ##1 !ack[*3]);

// 38. Write an assertion to ensure that `a` is high, and `b` occurs exactly 2 times within 5 cycles.
   Answer_38a: assert property (@(posedge clk) a |-> b[=2] within ##[1:5] 1);
   Answer_38b: assert property (@(posedge clk) a ##[1:5] b[=2]);

// 39. How do you assert that `sig` is high, and `data` is stable until `sig` goes low?
   Answer_39a: assert property (@(posedge clk) sig |-> $stable(data) throughout sig);
   Answer_39b: assert property (@(posedge clk) sig |-> $stable(data) until !sig);

// 40. Write an assertion to check that `start` is high, and `stop` occurs after 3 to 7 cycles.
   Answer_40a: assert property (@(posedge clk) start |-> ##[3:7] stop);
   Answer_40b: assert property (@(posedge clk) start ##[3:7] stop);

// 41. How would you verify that `a` is high, and `b` is high for 2 cycles overlapped with `a`?
   Answer_41a: assert property (@(posedge clk) a |-> (a && b)[*2]);
   Answer_41b: assert property (@(posedge clk) (a && b)[*2]);

// 42. Write an assertion to ensure that `req` is high, and `ack` occurs in the next cycle, followed by `grant` for 2 cycles.
   Answer_42a: assert property (@(posedge clk) req |-> ##1 ack ##1 grant[*2]);
   Answer_42b: assert property (@(posedge clk) req ##1 ack ##1 grant[*2]);

// 43. How do you assert that `sig1` is high, and `sig2` occurs exactly 3 times non-consecutively within 10 cycles?
   Answer_43a: assert property (@(posedge clk) sig1 |-> sig2[=3] within ##[1:10] 1);
   Answer_43b: assert property (@(posedge clk) sig1 ##[1:10] sig2[=3]);

// 44. Write an assertion to check that `a` is high, and `b` does not occur for the next 4 cycles.
   Answer_44a: assert property (@(posedge clk) a |-> !b[*4]);
   Answer_44b: assert property (@(posedge clk) a ##1 !b[*4]);

// 45. How would you verify that `start` is high, and `done` occurs repeatedly 2 to 3 times within 10 cycles?
   Answer_45a: assert property (@(posedge clk) start |-> done[=2:3] within ##[1:10] 1);
   Answer_45b: assert property (@(posedge clk) start ##[1:10] done[=2:3]);

// 46. Write an assertion to ensure that `sig` is high, and `error` is low for 3 cycles starting 2 cycles later.
   Answer_46a: assert property (@(posedge clk) sig |-> ##2 !error[*3]);
   Answer_46b: assert property (@(posedge clk) sig ##2 !error[*3]);

// 47. How do you assert that `a` is high, and `b` is high in the next cycle, followed by `c` in the cycle after?
   Answer_47a: assert property (@(posedge clk) a |-> ##1 b ##1 c);
   Answer_47b: assert property (@(posedge clk) a ##1 b ##1 c);

// 48. Write an assertion to check that `req` is high, and `ack` occurs at least twice within 5 cycles.
   Answer_48a: assert property (@(posedge clk) req |-> ack[=2] within ##[1:5] 1);
   Answer_48b: assert property (@(posedge clk) req ##[1:5] ack[=2]);

// 49. How would you verify that `sig` is high, and `data` changes exactly once within 5 cycles?
   Answer_49a: assert property (@(posedge clk) sig |-> $changed(data)[=1] within ##[1:5] 1);
   Answer_49b: assert property (@(posedge clk) sig ##[1:5] $changed(data));

// 50. Write an assertion to ensure that `start` is high, and `stop` occurs after exactly 5 cycles.
   Answer_50a: assert property (@(posedge clk) start |-> ##5 stop);
   Answer_50b: assert property (@(posedge clk) start ##5 stop);

// ### Property Operators

// 51. How do you assert that if `req` is high, `ack` must be high in the next cycle, and this holds throughout the simulation?
   Answer_51a: assert property (@(posedge clk) always (req |-> ##1 ack));
   Answer_51b: assert property (@(posedge clk) always[0:$] (req |-> ##1 ack));
//   Answer_51b: assert property (@(posedge clk) s_always (req |-> ##1 ack));   // There is no s_always

// 52. Write an assertion to check that `sig` is high at least once in every 10 cycles.
   Answer_52a: assert property (@(posedge clk) always ##[1:10] sig);
   Answer_52b: assert property (@(posedge clk) always[0:$] ##[1:10] sig); // Corrected: Replaced s_always with always[0:$]
//   Answer_52b: assert property (@(posedge clk) s_always ##[1:10] sig);

// 53. How would you verify that `error` is never high during the simulation?
   Answer_53a: assert property (@(posedge clk) always !error);
   Answer_53b: assert property (@(posedge clk) not error);
//   Answer_53b: assert property (@(posedge clk) never error);

// 54. Write an assertion to ensure that `req` is high, `ack` occurs within 5 cycles, and this holds until `reset` is high.
   Answer_54a: assert property (@(posedge clk) req |-> ##[1:5] ack until reset);
   Answer_54b: assert property (@(posedge clk) req |-> ##[1:5] ack throughout !reset);

// 55. How do you assert that `sig` is high, and `data` is stable until `sig` goes low, and this holds always?
   Answer_55a: assert property (@(posedge clk) always (sig |-> $stable(data) until !sig));
   Answer_55b: assert property (@(posedge clk) always[0:$] (sig |-> $stable(data) throughout sig)); // Corrected: Replaced s_always with always[0:$]
//   Answer_55b: assert property (@(posedge clk) s_always (sig |-> $stable(data) throughout sig));

// 56. Write an assertion to check that `start` is followed by `stop` within 5 cycles, and this holds eventually.
   Answer_56a: assert property (@(posedge clk) eventually[2:3] (start |-> ##[1:5] stop));  // Wrong but it is to show that eventually should contian a range
   Answer_56b: assert property (@(posedge clk) s_eventually (start |-> ##[1:5] stop));

// 57. How would you verify that `req` and `ack` are never high simultaneously?
   Answer_57a: assert property (@(posedge clk) always !(req && ack));
   Answer_57b: assert property (@(posedge clk) never (req && ack));

// 58. Write an assertion to ensure that `sig` is high, and `error` is low until `reset`, and this holds throughout.
   Answer_58a: assert property (@(posedge clk) always (sig |-> !error until reset));
   Answer_58b: assert property (@(posedge clk) always[0:$] (sig |-> !error throughout !reset)); // Corrected: Replaced s_always with always[0:$]
//   Answer_58b: assert property (@(posedge clk) s_always (sig |-> !error throughout !reset));

// 59. How do you assert that `a` is high, and `b` occurs within 3 cycles, and this holds eventually?
   Answer_59a: assert property (@(posedge clk) eventually[0:3] (a |-> ##[1:3] b));
   Answer_59b: assert property (@(posedge clk) s_eventually (a |-> ##[1:3] b));

// 60. Write an assertion to check that `sig` is high at least once within 5 cycles, and this holds always.
   Answer_60a: assert property (@(posedge clk) always ##[1:5] sig);
   Answer_60b: assert property (@(posedge clk) always[0:$] ##[1:5] sig); // Corrected: Replaced s_always with always[0:$]
//   Answer_60b: assert property (@(posedge clk) s_always ##[1:5] sig);

// 61. How would you verify that `error` is low until `reset` is high?
   Answer_61a: assert property (@(posedge clk) !error until reset);
   Answer_61b: assert property (@(posedge clk) !error throughout !reset);

// 62. Write an assertion to ensure that `req` is high, and `ack` occurs in the next cycle, and this holds always.
   Answer_62a: assert property (@(posedge clk) always (req |-> ##1 ack));
   Answer_62b: assert property (@(posedge clk) always[0:$] (req |-> ##1 ack)); // Corrected: Replaced s_always with always[0:$]
//   Answer_62b: assert property (@(posedge clk) s_always (req |-> ##1 ack));

// 63. How do you assert that `sig` is never high for 3 consecutive cycles?
   Answer_63a: assert property (@(posedge clk) always not (sig[*3]));
//   Answer_63b: assert property (@(posedge clk) always !(sig[*3]));  // To negate a whole sequence use not
//   Answer_63c: assert property (@(posedge clk) never sig[*3]); // Never does not exist

// 64. Write an assertion to check that `start` is high, and `stop` occurs within 10 cycles, and this holds until `reset`.
   Answer_64a: assert property (@(posedge clk) start |-> ##[1:10] stop until reset);
   Answer_64b: assert property (@(posedge clk) start |-> ##[1:10] stop throughout !reset);

// 65. How would you verify that `a` and `b` are high simultaneously at least once within 5 cycles?
   Answer_65a: assert property (@(posedge clk) always ##[1:5] (a && b));
   Answer_65b: assert property (@(posedge clk) always[0:$] ##[1:5] (a && b)); // Corrected: Replaced s_always with always[0:$]
//   Answer_65b: assert property (@(posedge clk) s_always ##[1:5] (a && b));

// 66. Write an assertion to ensure that `sig` is high, and `data` changes within 3 cycles, and this holds eventually.
   Answer_66a: assert property (@(posedge clk) eventually[2:3] (sig |-> ##[1:3] $changed(data)));
   Answer_66b: assert property (@(posedge clk) s_eventually (sig |-> ##[1:3] $changed(data)));

// 67. How do you assert that `req` is high, and `ack` does not occur until `grant` is high?
   Answer_67a: assert property (@(posedge clk) req |-> !ack until grant);
   Answer_67b: assert property (@(posedge clk) req |-> !ack throughout !grant);

// 68. Write an assertion to check that `sig` is high for 2 cycles at least once within 10 cycles.
   Answer_68a: assert property (@(posedge clk) always ##[1:10] sig[*2]);
   Answer_68b: assert property (@(posedge clk) always[0:$] ##[1:10] sig[*2]); // Corrected: Replaced s_always with always[0:$]
//   Answer_68b: assert property (@(posedge clk) s_always ##[1:10] sig[*2]);

// 69. How would you verify that `error` is never high for 2 consecutive cycles?
   Answer_69a: assert property (@(posedge clk) always not (error[*2]));
   Answer_69b: assert property (@(posedge clk) not error[*2]); // Corrected: Replaced never with not for sequence negation
//   Answer_69b: assert property (@(posedge clk) never error[*2]);

// 70. Write an assertion to ensure that `start` is high, and `done` occurs within 5 cycles, and this holds always.
   Answer_70a: assert property (@(posedge clk) always (start |-> ##[1:5] done));
   Answer_70b: assert property (@(posedge clk) always[0:$] (start |-> ##[1:5] done)); // Corrected: Replaced s_always with always[0:$]
//   Answer_70b: assert property (@(posedge clk) s_always (start |-> ##[1:5] done));

// ### Overlapping and Non-Overlapping Operators

// 71. How do you assert that `req` is high, and `ack` is high in the next cycle (non-overlapping)?
   Answer_71a: assert property (@(posedge clk) req |-> ##1 ack);
   Answer_71b: assert property (@(posedge clk) req ##1 ack);

// 72. Write an assertion to check that `req` is high, and `ack` is high in the same cycle (overlapping)?
   Answer_72a: assert property (@(posedge clk) req |-> ack);
   Answer_72b: assert property (@(posedge clk) req && ack);

// 73. How would you verify that `sig1` is high, and `sig2` is high in the next cycle (non-overlapping)?
   Answer_73a: assert property (@(posedge clk) sig1 |-> ##1 sig2);
   Answer_73b: assert property (@(posedge clk) sig1 ##1 sig2);

// 74. Write an assertion to ensure that `a` is high, and `b` is high in the same cycle (overlapping)?
   Answer_74a: assert property (@(posedge clk) a |-> b);
   Answer_74b: assert property (@(posedge clk) a && b);

// 75. How do you assert that `start` is high, and `stop` is high in the next cycle (non-overlapping)?
   Answer_75a: assert property (@(posedge clk) start |-> ##1 stop);
   Answer_75b: assert property (@(posedge clk) start ##1 stop);

// ### Consecutive and Non-Consecutive Repetition

// 76. How do you assert that `sig` is high for exactly 4 consecutive cycles?
   Answer_76a: assert property (@(posedge clk) sig[*4]);
   Answer_76b: assert property (@(posedge clk) sig ##1 sig ##1 sig ##1 sig);

// 77. Write an assertion to check that `sig` is high exactly 3 times non-consecutively within 10 cycles.
   Answer_77a: assert property (@(posedge clk) sig[=3] within ##[1:10] 1);
   Answer_77b: assert property (@(posedge clk) ##[1:10] sig[=3]);

// 78. How would you verify that `sig` is high for 2 to 4 consecutive cycles?
   Answer_78a: assert property (@(posedge clk) sig[*2:4]);
   Answer_78b: assert property (@(posedge clk) sig[*2] or sig[*3] or sig[*4]); // Corrected: Replaced || with or for sequence disjunction
//   Answer_78b: assert property (@(posedge clk) sig[*2] || sig[*3] || sig[*4]);   // Wrong use "or"

// 79. Write an assertion to ensure that `sig` is high at least 2 times non-consecutively within 5 cycles.
   Answer_79a: assert property (@(posedge clk) sig[=2] within ##[1:5] 1);
   Answer_79b: assert property (@(posedge clk) ##[1:5] sig[=2]);

// 80. How do you assert that `sig` is high for at least 3 consecutive cycles?
   Answer_80a: assert property (@(posedge clk) sig[*3:$]);
   Answer_80b: assert property (@(posedge clk) sig[*3] ##1 sig[*0:$]);

// ### Throughout and Until Operators

// 81. How do you assert that `data` is stable while `sig` is high?
   Answer_81a: assert property (@(posedge clk) sig |-> $stable(data) throughout sig);
   Answer_81b: assert property (@(posedge clk) sig |-> $stable(data) until !sig);

// 82. Write an assertion to check that `error` is low while `enable` is high.
   Answer_82a: assert property (@(posedge clk) enable |-> !error throughout enable);
   Answer_82b: assert property (@(posedge clk) enable |-> !error until !enable);

// 83. How would you verify that `ack` does not occur until `grant` is high?
   Answer_83a: assert property (@(posedge clk) !ack until grant);
   Answer_83b: assert property (@(posedge clk) !ack throughout !grant);

// 84. Write an assertion to ensure that `sig1` is high while `sig2` is high.
   Answer_84a: assert property (@(posedge clk) sig2 |-> sig1 throughout sig2);
   Answer_84b: assert property (@(posedge clk) sig2 |-> sig1 until !sig2);

// 85. How do you assert that `req` is high until `ack` is high?
   Answer_85a: assert property (@(posedge clk) req until ack);
   Answer_85b: assert property (@(posedge clk) req throughout !ack);

// ### Past and Future Operators

// 86. How do you assert that if `sig` is high, it was high in the previous cycle?
   Answer_86a: assert property (@(posedge clk) sig |-> $past(sig));
   Answer_86b: assert property (@(posedge clk) sig && $past(sig));

// 87. Write an assertion to check that `data` is stable compared to 2 cycles ago.
   Answer_87a: assert property (@(posedge clk) data == $past(data, 2));
   Answer_87b: assert property (@(posedge clk) always[0:2] data == $past(data, 2)); // Corrected: Replaced since with always to check stability over cycles
//   Answer_87b: assert property (@(posedge clk) $stable(data) since ##2 1);   // Since does not exist

// 88. How would you verify that if `ack` is high, `req` was high 3 cycles ago?
   Answer_88a: assert property (@(posedge clk) ack |-> $past(req, 3));
   Answer_88b: assert property (@(posedge clk) ack && $past(req, 3));

// 89. Write an assertion to ensure that `sig` is high, and it will be high in the next cycle.
   Answer_89a: assert property (@(posedge clk) sig |-> ##1 sig);
   Answer_89b: assert property (@(posedge clk) sig ##1 sig);

// 90. How do you assert that `error` was low 2 cycles ago if `sig` is high?
   Answer_90a: assert property (@(posedge clk) sig |-> $past(!error, 2));
   Answer_90b: assert property (@(posedge clk) sig && $past(!error, 2));

// ### Logical Operators in Assertions

// 91. How do you assert that either `a` or `b` is high, but not both, in the same cycle?
   Answer_91a: assert property (@(posedge clk) (a || b) && !(a && b));
   Answer_91b: assert property (@(posedge clk) a ^ b);

// 92. Write an assertion to check that `req` is high, and either `ack` or `grant` is high in the next cycle.
   Answer_92a: assert property (@(posedge clk) req |-> ##1 (ack || grant));
   Answer_92b: assert property (@(posedge clk) req ##1 (ack || grant));

// 93. How would you verify that `sig1` and `sig2` are never high together?
   Answer_93a: assert property (@(posedge clk) !(sig1 && sig2));
   Answer_93b: assert property (@(posedge clk) always !(sig1 && sig2));

// 94. Write an assertion to ensure that `a` is high, and both `b` and `c` are high in the next cycle.
   Answer_94a: assert property (@(posedge clk) a |-> ##1 (b && c));
   Answer_94b: assert property (@(posedge clk) a ##1 (b && c));

// 95. How do you assert that `req` is high, and neither `ack` nor `grant` is high in the next cycle?
   Answer_95a: assert property (@(posedge clk) req |-> ##1 !(ack || grant));
   Answer_95b: assert property (@(posedge clk) req ##1 (!ack && !grant));

// ### Miscellaneous Operators

// 96. How do you assert that `sig` rises in the next cycle?
   Answer_96a: assert property (@(posedge clk) $rose(sig));
   Answer_96b: assert property (@(posedge clk) !sig ##1 sig);

// 97. Write an assertion to check that `sig` falls in the next cycle.
   Answer_97a: assert property (@(posedge clk) $fell(sig));
   Answer_97b: assert property (@(posedge clk) sig ##1 !sig);

// 98. How would you verify that `data` is stable across 3 cycles?
   Answer_98a: assert property (@(posedge clk) $stable(data)[*3]);
   Answer_98b: assert property (@(posedge clk) data == $past(data) ##1 data == $past(data));

// 99. Write an assertion to ensure that `sig` changes in the next cycle.
   Answer_99a: assert property (@(posedge clk) $changed(sig));
   Answer_99b: assert property (@(posedge clk) sig != $past(sig));

// 100. How do you assert that `req` is high, and `ack` occurs within 5 cycles or `error` is high?
   Answer_100a: assert property (@(posedge clk) req |-> ##[1:5] ack || error);
   Answer_100b: assert property (@(posedge clk) req ##[1:5] (ack || error));

// ## Part 2: Setup and Hold Time Violation Checks (10 Questions)

// 101. How do you write an assertion to check for a setup time violation on `data` with respect to `clk`, assuming a setup time of 2 cycles?
   Answer_101a: assert property (@(posedge clk) $stable(data) throughout ##[0:2] 1);
   Answer_101b: assert property (@(posedge clk) $stable(data) until ##2 1);

// 102. Write an assertion to verify a hold time violation on `data` after `clk` rises, assuming a hold time of 1 cycle.
   Answer_102a: assert property (@(posedge clk) ##1 $stable(data));
   Answer_102b: assert property (@(posedge clk) data == $past(data));

// 103. How would you check for a setup time violation on `sig` before `clk` edge, with a setup time of 3 cycles?
   Answer_103a: assert property (@(posedge clk) $stable(sig) throughout ##[0:3] 1);
   Answer_103b: assert property (@(posedge clk) $stable(sig) until ##3 1);

// 104. Write an assertion to ensure no hold time violation on `data` for 2 cycles after `clk` rises.
   Answer_104a: assert property (@(posedge clk) $stable(data)[*2]);
   Answer_104b: assert property (@(posedge clk) ##1 data == $past(data) ##1 data == $past(data));

// 105. How do you assert a setup time check for `control` signal with respect to `clk`, with a setup time of 4 cycles?
   Answer_105a: assert property (@(posedge clk) $stable(control) throughout ##[0:4] 1);
   Answer_105b: assert property (@(posedge clk) $stable(control) until ##4 1);

// 106. Write an assertion to check for a hold time violation on `sig` for 3 cycles after `clk` edge.
   Answer_106a: assert property (@(posedge clk) $stable(sig)[*3]);
   Answer_106b: assert property (@(posedge clk) ##1 sig == $past(sig) ##1 sig == $past(sig) ##1 sig == $past(sig));

// 107. How would you verify that `data` does not change 2 cycles before `clk` edge (setup time check)?
   Answer_107a: assert property (@(posedge clk) $stable(data) throughout ##[0:2] 1);
   Answer_107b: assert property (@(posedge clk) $stable(data) until ##2 1);

// 108. Write an assertion to ensure `sig` remains stable for 1 cycle after `clk` edge (hold time check).
   Answer_108a: assert property (@(posedge clk) ##1 $stable(sig));
   Answer_108b: assert property (@(posedge clk) ##1 sig == $past(sig));

// 109. How do you assert that `control` has a setup time of 5 cycles before `clk` edge?
   Answer_109a: assert property (@(posedge clk) $stable(control) throughout ##[0:5] 1);
   Answer_109b: assert property (@(posedge clk) $stable(control) until ##5 1);

// 110. Write an assertion to check that `data` holds its value for 4 cycles after `clk` edge.
   Answer_110a: assert property (@(posedge clk) $stable(data)[*4]);
   Answer_110b: assert property (@(posedge clk) ##1 data == $past(data) ##1 data == $past(data) ##1 data == $past(data) ##1 data == $past(data));
      
   
   
endmodule
