module tb_m_sequencer_vs_p_sequencer;

/*
    Virtual Sequencer Notes (UVM)

    What is the difference between m_sequencer and p_sequencer?
    - m_sequencer is a generic sequencer pointer of type uvm_sequencer_base that will always exist in an uvm_sequence, and is initialized when the sequence is started.
    - p_sequencer is a type-specific sequence pointer. It will not exist if `uvm_declare_p_sequencer is not defined.
    - Whenever we want to access properties of user defined sequencer then we need p_sequencer.
    Eg-Virtual Sequencer

    What is a Virtual Sequencer?
    - user defined sequencer(extended from uvm_sequencer) runs the sequence & hands over the transaction to the driver through TLM.
    - Virtual seqr is a top-level sequencer which has handles of all other sequencers that exist in our environment, so that one can control which sequence to run on which seqr easily 
    In SOC,
    Subsystem1 ->apb ,axi,ahb
    Subsystem2 -> i2c,uart,spi

    From test to start the sequencer,
    apb_seq.start(env.subsystem1.apb_agent.apb_seqr),i2c_seq.start(env.subsystem2.i2c_agent.i2c_seqr),

    You need to remember these sequencers’s path, which is difficult.

*/

// Implementation:
// 1.Creating Virtual sequencer class 
class my_virtual_sequencer extends uvm_sequencer;
  apb_sequencer apb_seqr;
  i2c_sequencer i2c_seqr;
…..//no need to build the seqrs,as they will be built in individual agents
endclass


// 2. Env class
class env;
  sub_system_1 subsystem1;
  sub_system_2 subsystem2;
  my_virtual_sequencer vseqr;

/*
    Build_phase: create subsystem1/2 ,vseqr
    Connect Phase: vseqr.apb_seqr = subsystem1.apb_agent.apb_seqr;
    vseqr.i2c_seqr = subsystem2.i2c_agent.i2c_seqr;
*/

// 3.Creating Virtual sequence
class my_virtual_sequence extends uvm_sequence;
  apb_sequence apb_seq;
  i2c_sequence i2c_seq;

`uvm_declare_p_sequencer(my_virtual_sequencer)
virtual task body(); 
fork
 `uvm_do_on(axi_seq, p_sequencer.axi_seqr);
begin
    `uvm_do_on(apb_seq, p_sequencer.apb_seqr);
  `uvm_do_on(i2c_seq, p_sequencer.i2c_seqr);
End
…
join
endtask
..
endclass

Understanding what happens under the hood,
uvm_sequencer_base  
  ↑  
uvm_sequencer  
  ↑  
my_virtual_sequencer


class uvm_sequence #(REQ=uvm_sequence_item, RSP=REQ) extends uvm_sequence_base;
  protected uvm_sequencer_base m_sequencer;
task start(uvm_sequencer_base sequencer);
m_sequencer=sequencer; // base pointing to derived
..
endclass

/* 
If we call vseq.start(env.vseqr) in test class, m_sequencer=vseqr;
Note:with m_sequencer handle ,you can’t access vseqr’s properties,meaning apb_seqr,i2c_seqr…
What uvm_declare_p_sequencer(my_virtual_sequencer) will do?
my_virtual_sequencer p_sequencer;
$cast(p_sequencer,m_sequencer);
As m_sequencer can’t access my_virtual_sequencer’s properties,we use $cast.
So at RT,
m_sequencer=vseqr;
p_sequencer=m_sequencer;
So,using p_sequencer we can access.

*/

// 4.test class
 task main_phase;
  my_virtual_sequence vseq;
  vseq = virtual_sequence::type_id::create("vseq", this);
  
  phase.raise_objection(this, "raised");
  vseq.start(this.env.vseqr);
  phase.drop_objection(this, "dropped");
endtask


endmodule