module tb_uvm_transaction_vs_uvm_sequence_item;

/*

UVM_TRANSACTION

Extended from uvm_object
Transaction ID is added 
Used for communication between scoreboard and checker
Should not be used in drv -> sqr communication

// Fields
local integer m_transaction_id = -1;
local time begin_time = -1;
local time end_time = -1;
local time accept_time = -1;
.... and a few more 



UVM_SEQUENCE_ITEM

Extended from uvm_transaction
Used in drv -> sqr communication
Sequencer item will have an ID and a SEQ NAME associated with the item, which is missing in uvm_transaction

// Extra Fields
local int m_sequence_id = -1;
protected bit m_use_sequence_info;
protected int m_depth = -1;
protected uvm_sequencer_base  m_sequencer;
protected uvm_sequence_base  m_parent_sequence;
static bit issued1, issued2;
bit print_sequence_info;

*/

endmodule