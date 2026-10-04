
class apb_environment extends uvm_env;
 `uvm_component_utils(apb_environment)

 function new(string path = "apb_environment", uvm_component parent = null);
   super.new(path,parent);
 endfunction

apb_agent agt;
apb_scoreboard scb;
apb_coverage cov;
//monitor moni;

 virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
       // moni=monitor::create("moni",this);
        agt = apb_agent::type_id::create("agt",this);
        scb = apb_scoreboard::type_id::create("scb",this);
	cov =
  apb_coverage::type_id::create(
    "cov",
    this
  );
        `uvm_info("Environment","Test buil Phase Executed In build Phase", UVM_NONE);
 endfunction
 function void connect_phase(uvm_phase phase);
    agt.monitor.item_collected_port.connect(scb.item_collected_export);
	agt.monitor.item_collected_port.connect(cov.analysis_export);
  endfunction : connect_phase

endclass
