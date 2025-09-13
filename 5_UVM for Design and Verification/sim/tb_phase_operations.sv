module tb_phase_operations();

/*

                        RUN_PHASES

PRE_RESET_PHASE

    Upon Entry
        o POWER has been applied but not yet valid or stable
        o There should not have been any active clock edges

    Uses
        o Used when to check if power is good
        o Initialize clock to a valid value
        o Initlialize all other signals to X or Z

    Exit criteria
        o Reset signal, if asserted by Verification Environment, is asserted
        o Reset signal, if not asserted by Verification Environment, is asserted

RESET_PHASE

    Upon Entry
        o Indicates reset is ready to be asserted

    Uses
        o Assert the reset signals
        o All components connected should drive their output to idle or reset values
        o Components and variables should initiliaze their state variables
        o Clock generators start generating active edges
        o De-assert the reset signals just before exit
        o Wait for the reset signals to be deaserted 

    Exit Criteria
        o Reset signal has just been de-asserted 
        o Main/Base clock is working and stable
        o Atleast one clock edge has occured
        o Output signals and state variables have been initialized

Check more at UVM_ESSENTIALS Session 21

*/

endmodule 
