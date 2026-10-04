
class apb_agent extends uvm_agent;

`uvm_component_utils(apb_agent)
 
function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction 
apb_driver driver1;
apb_monitor monitor;
apb_sequencer seq1;

virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
monitor = apb_monitor::type_id::create("monitor", this);
if(get_is_active() == UVM_ACTIVE) begin
 driver1 = apb_driver::type_id::create("driver1",this);
   
   seq1 = apb_sequencer::type_id::create("seq1", this);

`uvm_info("agent","Test build Phase Executed In agent", UVM_NONE);
 end
  endfunction 
  function void connect_phase(uvm_phase phase);
    if(get_is_active() == UVM_ACTIVE) begin
      driver1.seq_item_port.connect(seq1.seq_item_export);
    end
  endfunction 
  
endclass
