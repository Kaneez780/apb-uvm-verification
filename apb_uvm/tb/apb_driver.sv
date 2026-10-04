//`define DRIV_IF vif.DRIVER.drv_cb

class apb_driver extends uvm_driver #(transaction);

  virtual apb_intr vif;
  `uvm_component_utils(apb_driver)
    // transaction tr;
  //--------------------------------------- 
  // Constructor
  //--------------------------------------- 
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  //--------------------------------------- 
  // build phase
  //---------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("Driver"," Build Phase Executed In Driver", UVM_NONE);
     if(!uvm_config_db#(virtual apb_intr)::get(this, "", "vif", vif))
       `uvm_fatal("NO_VIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
  endfunction: build_phase
// function void build_phase(uvm_phase phase);
//     super.build_phase(phase);
//      if(!uvm_config_db#(virtual mem_if)::get(this, "", "vif", vif))
//        `uvm_fatal("NO_VIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
//   endfunction: build_phase
  //---------------------------------------  
  // run phase
  //---------------------------------------  
  virtual task run_phase(uvm_phase phase);
    forever begin
      seq_item_port.get_next_item(req);
      drive();
      seq_item_port.item_done();
    end
  endtask : run_phase
  virtual task drive();
       // ---- SETUP Phase ----
      // vif.PWRITE  <= 0;
        @(vif.drv_cb);
        // #1;   // to avoid race conditions
        vif.drv_cb.PSELx   <= 1'b1;
        vif.drv_cb.PENABLE <= 1'b0;
        vif.drv_cb.PWRITE  <= req.write;
        vif.drv_cb.PADDR   <= req.addr;
        vif.drv_cb.PWDATA  <= req.data;
        vif.drv_cb.PSTRB   <= req.strb;

        // `uvm_info("[DRV]" ,$sformatf("ID=%0d SETUP   @%0t | %s addr=0x%08h data=0x%016h",
        //          req.id, $time, req.write ? "WRITE" : "READ ", req.addr, req.data),UVM_NONE);

        // ---- ACCESS Phase ----
        @(vif.drv_cb);

        // #1;
        vif.drv_cb.PENABLE <= 1'b1;

        // ---- Wait for PREADY (with timeout) ----
        begin : wait_ready_block
            int cycle = 0;
            while (vif.PREADY !== 1'b1) begin
                @(vif.drv_cb);

                #1;
                cycle++;
                //  `uvm_info("[DRV]" ,$sformatf("ID=%0d CYCLE %0d @%0t | PSELx=%b PENABLE=%b PREADY=%b PRDATA=0x%016h",
                //          req.id, cycle, $time, vif.PSELx, vif.PENABLE,
                //          vif.PREADY, vif.PRDATA),UVM_NONE);
                // if (cycle > 50) begin
                //     `uvm_info("[DRV]", "TIMEOUT! PREADY never asserted",UVM_NONE);
                    
                // end
            end
        end

        // ---- Capture Response ----
        req.rdata   <= vif.drv_cb.PRDATA;
        req.pslverr <= vif.drv_cb.PSLVERR;

          // if (req.write)begin
          //   // $display("[DRV] ID=%0d DONE    @%0t | WRITE complete",
          //   //          req.id, $time);
          //  `uvm_info("[DRV]",$sformatf("ID=%0d DONE  | WRITE complete",req.id), UVM_NONE); end
          // else
          //        `uvm_info("[DRV]",$sformatf(" ID=%0d DONE    @%0t | READ rdata=0x%016h pslverr=%0b",
          //            req.id, $time, req.rdata, req.pslverr), UVM_NONE);
            // $display("[DRV] ID=%0d DONE    @%0t | READ rdata=0x%016h pslverr=%0b",
            //          req.id, $time, req.rdata, req.pslverr);

        // ---- Deassert ----
        @( vif.drv_cb);
        #1;
        vif.drv_cb.PSELx   <= 1'b0;
        vif.drv_cb.PENABLE <= 1'b0;
        vif.drv_cb.PWRITE  <= 1'b0;
        vif.drv_cb.PADDR   <= '0;
        vif.drv_cb.PWDATA  <= '0;
        vif.drv_cb.PSTRB   <= '0;
    endtask

endclass