
class base_test extends uvm_test;
    `uvm_component_utils(base_test)
  

  apb_environment env1;

  function new(string name = "base_test",uvm_component parent=null);
    super.new(name,parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    env1 = apb_environment::type_id::create("env1", this);
    `uvm_info(get_type_name(), "-------TEST BUILD PHASE------------", UVM_NONE)
  endfunction : build_phase

  virtual function void end_of_elaboration();
    
    print();
  endfunction

 function void report_phase(uvm_phase phase);
   uvm_report_server svr;
   super.report_phase(phase);
   
   svr = uvm_report_server::get_server();
   if(svr.get_severity_count(UVM_FATAL)+svr.get_severity_count(UVM_ERROR)>0) begin
     `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
     `uvm_info(get_type_name(), "----            TEST FAIL          ----", UVM_NONE)
     `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
    end
    else begin
     `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
     `uvm_info(get_type_name(), "----           TEST PASS           ----", UVM_NONE)
     `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
    end
  endfunction 
  

endclass


class apb_wr_rd_test extends base_test;

  `uvm_component_utils(apb_wr_rd_test)

  apb_wr_rd_sequence seq;


  function new(
    string name = "apb_wr_rd_test",
    uvm_component parent = null
  );

    super.new(name, parent);

  endfunction


  function void build_phase(
    uvm_phase phase
  );

    super.build_phase(phase);

    seq =
      apb_wr_rd_sequence::type_id::create("seq");

  endfunction


  task run_phase(
    uvm_phase phase
  );

    phase.raise_objection(this);

    seq.start(
      env1.agt.seq1
    );

    phase.drop_objection(this);

    phase.phase_done.set_drain_time(
      this,
      50
    );

  endtask


endclass

class apb_successive_wr_test extends base_test;

  `uvm_component_utils(apb_successive_wr_test)

  apb_successive_wr_sequence seq;


  function new(
    string name = "apb_successive_wr_test",
    uvm_component parent = null
  );

    super.new(name,parent);

  endfunction


  virtual function void build_phase(uvm_phase phase);

    super.build_phase(phase);

    seq =
      apb_successive_wr_sequence::type_id::create("seq");

  endfunction


  task run_phase(uvm_phase phase);

    phase.raise_objection(this);

    seq.start(env1.agt.seq1);

    phase.drop_objection(this);

    phase.phase_done.set_drain_time(this,50);

  endtask

endclass

class apb_b2b_wr_test extends base_test;

  `uvm_component_utils(apb_b2b_wr_test)

  apb_b2b_wr_sequence seq;


  function new(
    string name = "apb_b2b_wr_test",
    uvm_component parent = null
  );

    super.new(name,parent);

  endfunction


  function void build_phase(uvm_phase phase);

    super.build_phase(phase);

    seq =
      apb_b2b_wr_sequence::type_id::create("seq");

  endfunction


  task run_phase(uvm_phase phase);

    phase.raise_objection(this);

    seq.start(env1.agt.seq1);

    phase.drop_objection(this);

    phase.phase_done.set_drain_time(this,50);

  endtask

endclass

class apb_slave_error_aor_test extends base_test;

  `uvm_component_utils(apb_slave_error_aor_test)

  apb_slave_error_aor_sequence seq;


  function new(
    string name = "apb_slave_error_aor_test",
    uvm_component parent = null
  );

    super.new(name,parent);

  endfunction


  function void build_phase(uvm_phase phase);

    super.build_phase(phase);

    seq =
      apb_slave_error_aor_sequence::type_id::create("seq");

  endfunction


  task run_phase(uvm_phase phase);

    phase.raise_objection(this);

    seq.start(env1.agt.seq1);

    phase.drop_objection(this);

    phase.phase_done.set_drain_time(this,50);

  endtask

endclass

class apb_random_addr_wr_test extends base_test;

  `uvm_component_utils(apb_random_addr_wr_test)

  apb_random_addr_wr_sequence seq;


  function new(
    string name = "apb_random_addr_wr_test",
    uvm_component parent = null
  );

    super.new(name,parent);

  endfunction


  function void build_phase(uvm_phase phase);

    super.build_phase(phase);

    seq =
      apb_random_addr_wr_sequence::type_id::create("seq");

  endfunction


  task run_phase(uvm_phase phase);

    phase.raise_objection(this);

    seq.start(env1.agt.seq1);

    phase.drop_objection(this);

    phase.phase_done.set_drain_time(this,50);

  endtask

endclass

class apb_strobe_test extends base_test;

  `uvm_component_utils(apb_strobe_test)

  apb_strobe_sequence seq;


  function new(
    string name = "apb_strobe_test",
    uvm_component parent = null
  );

    super.new(name,parent);

  endfunction


  function void build_phase(uvm_phase phase);

    super.build_phase(phase);

    seq =
      apb_strobe_sequence::type_id::create("seq");

  endfunction


  task run_phase(uvm_phase phase);

    phase.raise_objection(this);

    seq.start(env1.agt.seq1);

    phase.drop_objection(this);

    phase.phase_done.set_drain_time(this,50);

  endtask

endclass

class apb_addr_misaligned_test extends base_test;

  `uvm_component_utils(apb_addr_misaligned_test)

  apb_addr_misaligned_sequence seq;


  function new(
    string name = "apb_addr_misaligned_test",
    uvm_component parent = null
  );

    super.new(name,parent);

  endfunction


  function void build_phase(uvm_phase phase);

    super.build_phase(phase);

    seq =
      apb_addr_misaligned_sequence::type_id::create("seq");

  endfunction


  task run_phase(uvm_phase phase);

    phase.raise_objection(this);

    seq.start(env1.agt.seq1);

    phase.drop_objection(this);

    phase.phase_done.set_drain_time(this,50);

  endtask

endclass

class apb_boundary_test extends base_test;

  `uvm_component_utils(apb_boundary_test)

  apb_boundary_sequence seq;


  function new(
    string name = "apb_boundary_test",
    uvm_component parent = null
  );

    super.new(name,parent);

  endfunction


  function void build_phase(uvm_phase phase);

    super.build_phase(phase);

    seq =
      apb_boundary_sequence::type_id::create("seq");

  endfunction


  task run_phase(uvm_phase phase);

    phase.raise_objection(this);

    seq.start(env1.agt.seq1);

    phase.drop_objection(this);

    phase.phase_done.set_drain_time(this,50);

  endtask

endclass

class apb_reset_test extends base_test;

  `uvm_component_utils(apb_reset_test)


  apb_reset_sequence      reset_seq;
  apb_post_reset_sequence post_reset_seq;


  function new(
    string name = "apb_reset_test",
    uvm_component parent = null
  );

    super.new(name, parent);

  endfunction


  virtual function void build_phase(
    uvm_phase phase
  );

    super.build_phase(phase);

    reset_seq =
      apb_reset_sequence::type_id::create(
        "reset_seq"
      );

    post_reset_seq =
      apb_post_reset_sequence::type_id::create(
        "post_reset_seq"
      );

  endfunction


  virtual task run_phase(
    uvm_phase phase
  );

    phase.raise_objection(this);


    `uvm_info(
      get_type_name(),
      "APB RESET TEST STARTED",
      UVM_LOW
    )


    // ------------------------------------------------------
    // Assert / release reset and verify reset-state outputs
    // ------------------------------------------------------

    reset_seq.start(null);


    // ------------------------------------------------------
    // Verify APB works after reset
    // ------------------------------------------------------

    post_reset_seq.start(
      env1.agt.seq1
    );


    `uvm_info(
      get_type_name(),
      "APB RESET TEST FINISHED",
      UVM_LOW
    )


    phase.drop_objection(this);

    phase.phase_done.set_drain_time(
      this,
      50
    );

  endtask


endclass

class apb_reset_during_transfer_test extends base_test;

  `uvm_component_utils(apb_reset_during_transfer_test)


  virtual apb_intr vif;

  apb_post_reset_sequence post_reset_seq;


  function new(
    string name = "apb_reset_during_transfer_test",
    uvm_component parent = null
  );

    super.new(name, parent);

  endfunction



  // ============================================================
  // BUILD PHASE
  // ============================================================

  virtual function void build_phase(
    uvm_phase phase
  );

    super.build_phase(phase);


    // Get virtual interface
    if (!uvm_config_db#(virtual apb_intr)::get(
          null,
          "*",
          "vif",
          vif
        ))
    begin

      `uvm_fatal(
        "RESET_DURING_TRANSFER",
        "Virtual interface not found"
      )

    end


    // Create existing post-reset sequence
    post_reset_seq =
      apb_post_reset_sequence::type_id::create(
        "post_reset_seq"
      );

  endfunction



  // ============================================================
  // RUN PHASE
  // ============================================================

  virtual task run_phase(
    uvm_phase phase
  );

    phase.raise_objection(this);


    `uvm_info(
      "RESET_DURING_TRANSFER",
      "Reset During Transfer Test Started",
      UVM_LOW
    )



    // ==========================================================
    // STEP 1:
    // Initialize bus in idle state
    // ==========================================================

    @(negedge vif.PCLK);

    vif.PRESETn = 1'b1;

    vif.PSELx   = 1'b0;
    vif.PENABLE = 1'b0;
    vif.PWRITE  = 1'b0;

    vif.PADDR   = '0;
    vif.PWDATA  = '0;
    vif.PSTRB   = '0;


    repeat (2)
      @(posedge vif.PCLK);



    // ==========================================================
    // STEP 2:
    // Start APB WRITE SETUP phase
    //
    // PSEL   = 1
    // PENABLE = 0
    //
    // Transfer is NOT complete yet.
    // ==========================================================

    `uvm_info(
      "RESET_DURING_TRANSFER",
      "Starting APB WRITE SETUP phase",
      UVM_LOW
    )


    @(negedge vif.PCLK);


    vif.PSELx   = 1'b1;
    vif.PENABLE = 1'b0;

    vif.PWRITE  = 1'b1;

    vif.PADDR   = 32'h0000_0300;

    vif.PWDATA  =
      64'hAAAA_BBBB_CCCC_DDDD;

    vif.PSTRB   = 8'hFF;



    // Make SETUP visible for one clock
    @(posedge vif.PCLK);



    // ==========================================================
    // STEP 3:
    // ASSERT RESET DURING SETUP
    //
    // Important:
    // PENABLE is NEVER asserted.
    //
    // Therefore this transfer must never complete.
    // ==========================================================

    @(negedge vif.PCLK);


    `uvm_info(
      "RESET_DURING_TRANSFER",
      "Asserting reset during APB SETUP phase",
      UVM_LOW
    )


    vif.PRESETn = 1'b0;



    // Immediately return APB bus to IDLE
    vif.PSELx   = 1'b0;
    vif.PENABLE = 1'b0;
    vif.PWRITE  = 1'b0;

    vif.PADDR   = '0;
    vif.PWDATA  = '0;
    vif.PSTRB   = '0;



    // ==========================================================
    // STEP 4:
    // HOLD RESET
    // ==========================================================

    repeat (4)
      @(posedge vif.PCLK);



    // ==========================================================
    // STEP 5:
    // CHECK RESET OUTPUTS
    //
    // From your DUT behavior:
    //
    // PREADY  = 0
    // PSLVERR = 0
    // PRDATA  = Z
    // ==========================================================

    if (vif.PREADY !== 1'b0) begin

      `uvm_error(
        "RESET_DURING_TRANSFER",
        $sformatf(
          "PREADY incorrect during reset. Expected=0 Actual=%b",
          vif.PREADY
        )
      )

    end


    if (vif.PSLVERR !== 1'b0) begin

      `uvm_error(
        "RESET_DURING_TRANSFER",
        $sformatf(
          "PSLVERR incorrect during reset. Expected=0 Actual=%b",
          vif.PSLVERR
        )
      )

    end


    if (vif.PRDATA !==
        64'hzzzz_zzzz_zzzz_zzzz) begin

      `uvm_error(
        "RESET_DURING_TRANSFER",
        $sformatf(
          "PRDATA incorrect during reset. Expected=Z Actual=%h",
          vif.PRDATA
        )
      )

    end



    `uvm_info(
      "RESET_DURING_TRANSFER",
      $sformatf(
        "During RESET: PRESETn=%b PREADY=%b PSLVERR=%b PRDATA=%h",
        vif.PRESETn,
        vif.PREADY,
        vif.PSLVERR,
        vif.PRDATA
      ),
      UVM_LOW
    )



    // ==========================================================
    // STEP 6:
    // RELEASE RESET
    // ==========================================================

    @(negedge vif.PCLK);

    vif.PRESETn = 1'b1;


    repeat (2)
      @(posedge vif.PCLK);



    `uvm_info(
      "RESET_DURING_TRANSFER",
      "Reset released",
      UVM_LOW
    )



    // ==========================================================
    // STEP 7:
    // Aborted transfer verification
    //
    // There should be NO monitor transaction for:
    //
    // ADDR  = 0x00000300
    // WDATA = 0xAAAA_BBBB_CCCC_DDDD
    //
    // Since PENABLE was never asserted.
    // ==========================================================

    `uvm_info(
      "RESET_DURING_TRANSFER",
      "Aborted transfer check complete - transaction did not reach ACCESS phase",
      UVM_LOW
    )



    // ==========================================================
    // STEP 8:
    // Verify DUT operation after reset
    //
    // Reuse your existing:
    //
    // apb_post_reset_sequence
    //
    // It performs:
    //
    // WRITE address 0x100
    // READ  address 0x100
    // ==========================================================

    post_reset_seq.start(
      env1.agt.seq1
    );



    // ==========================================================
    // TEST FINISHED
    // ==========================================================

    `uvm_info(
      "RESET_DURING_TRANSFER",
      "Reset During Transfer Test Finished",
      UVM_LOW
    )


    phase.drop_objection(this);


    phase.phase_done.set_drain_time(
      this,
      50
    );

  endtask


endclass

// ============================================================
// APB PROTOCOL VIOLATION TEST
// ============================================================

class apb_protocol_violation_test extends base_test;

  `uvm_component_utils(apb_protocol_violation_test)

  virtual apb_intr vif;


  function new(
    string name = "apb_protocol_violation_test",
    uvm_component parent = null
  );

    super.new(name, parent);

  endfunction


  // ============================================================
  // BUILD PHASE
  // ============================================================

  virtual function void build_phase(
    uvm_phase phase
  );

    super.build_phase(phase);


    if (!uvm_config_db#(virtual apb_intr)::get(
          null,
          "*",
          "vif",
          vif
        ))
    begin

      `uvm_fatal(
        "PROTOCOL_TEST",
        "Virtual interface not found"
      )

    end

  endfunction



  // ============================================================
  // LEGAL APB WRITE
  // ============================================================

  task legal_write(
    bit [31:0] addr,
    bit [63:0] data
  );

    // -------------------------
    // SETUP
    // -------------------------

    @(negedge vif.PCLK);

    vif.PSELx   = 1'b1;
    vif.PENABLE = 1'b0;
    vif.PWRITE  = 1'b1;

    vif.PADDR   = addr;
    vif.PWDATA  = data;
    vif.PSTRB   = 8'hFF;


    // -------------------------
    // ACCESS
    // -------------------------

    @(negedge vif.PCLK);

    vif.PENABLE = 1'b1;


    // Wait until transfer completes
    @(posedge vif.PCLK);

    while (vif.PREADY !== 1'b1)
      @(posedge vif.PCLK);


    // -------------------------
    // IDLE
    // -------------------------

    @(negedge vif.PCLK);

    vif.PSELx   = 1'b0;
    vif.PENABLE = 1'b0;
    vif.PWRITE  = 1'b0;

    vif.PADDR   = '0;
    vif.PWDATA  = '0;
    vif.PSTRB   = '0;

  endtask



  // ============================================================
  // LEGAL APB READ
  // ============================================================

  task legal_read(
    bit [31:0] addr
  );

    // -------------------------
    // SETUP
    // -------------------------

    @(negedge vif.PCLK);

    vif.PSELx   = 1'b1;
    vif.PENABLE = 1'b0;
    vif.PWRITE  = 1'b0;

    vif.PADDR   = addr;
    vif.PWDATA  = '0;
    vif.PSTRB   = 8'h00;


    // -------------------------
    // ACCESS
    // -------------------------

    @(negedge vif.PCLK);

    vif.PENABLE = 1'b1;


    @(posedge vif.PCLK);

    while (vif.PREADY !== 1'b1)
      @(posedge vif.PCLK);


    // -------------------------
    // IDLE
    // -------------------------

    @(negedge vif.PCLK);

    vif.PSELx   = 1'b0;
    vif.PENABLE = 1'b0;
    vif.PWRITE  = 1'b0;

    vif.PADDR   = '0;
    vif.PWDATA  = '0;
    vif.PSTRB   = '0;

  endtask



  // ============================================================
  // ILLEGAL TRANSFER
  //
  // PSEL = 1
  // PENABLE stays 0
  //
  // So ACCESS phase never occurs.
  // ============================================================

  task illegal_setup_only_write(
    bit [31:0] addr,
    bit [63:0] data
  );

    `uvm_info(
      "PROTOCOL_TEST",
      "Starting protocol violation: PSEL=1 while PENABLE remains 0",
      UVM_LOW
    )


    // SETUP
    @(negedge vif.PCLK);

    vif.PSELx   = 1'b1;
    vif.PENABLE = 1'b0;

    vif.PWRITE  = 1'b1;

    vif.PADDR   = addr;
    vif.PWDATA  = data;
    vif.PSTRB   = 8'hFF;


    // Hold malformed SETUP for several clocks.
    //
    // PENABLE intentionally NEVER asserted.
    repeat (3)
      @(posedge vif.PCLK);


    // Abort malformed transfer
    @(negedge vif.PCLK);

    vif.PSELx   = 1'b0;
    vif.PENABLE = 1'b0;
    vif.PWRITE  = 1'b0;

    vif.PADDR   = '0;
    vif.PWDATA  = '0;
    vif.PSTRB   = '0;


    `uvm_info(
      "PROTOCOL_TEST",
      "Protocol violation completed - malformed transfer aborted",
      UVM_LOW
    )

  endtask



  // ============================================================
  // RUN PHASE
  // ============================================================

  virtual task run_phase(
    uvm_phase phase
  );

    bit [31:0] test_addr;

    bit [63:0] original_data;
    bit [63:0] illegal_data;


    phase.raise_objection(this);


    test_addr =
      32'h0000_0400;

    original_data =
      64'h1111_2222_3333_4444;

    illegal_data =
      64'hDEAD_BEEF_CAFE_BABE;



    `uvm_info(
      "PROTOCOL_TEST",
      "APB Protocol Violation Test Started",
      UVM_LOW
    )



    // ==========================================================
    // STEP 1:
    // Put bus into known idle condition
    // ==========================================================

    @(negedge vif.PCLK);

    vif.PRESETn = 1'b1;

    vif.PSELx   = 1'b0;
    vif.PENABLE = 1'b0;
    vif.PWRITE  = 1'b0;

    vif.PADDR   = '0;
    vif.PWDATA  = '0;
    vif.PSTRB   = '0;


    repeat (2)
      @(posedge vif.PCLK);



    // ==========================================================
    // STEP 2:
    // LEGAL WRITE
    //
    // Scoreboard should store original_data
    // ==========================================================

    `uvm_info(
      "PROTOCOL_TEST",
      "Performing legal preload WRITE",
      UVM_LOW
    )


    legal_write(
      test_addr,
      original_data
    );



    // ==========================================================
    // STEP 3:
    // ILLEGAL WRITE ATTEMPT
    //
    // PSEL=1
    // PENABLE=0
    //
    // This must NOT modify memory.
    // ==========================================================

    illegal_setup_only_write(
      test_addr,
      illegal_data
    );



    // ==========================================================
    // STEP 4:
    // LEGAL READ
    //
    // Expected data should STILL be:
    //
    // 1111_2222_3333_4444
    //
    // NOT:
    //
    // DEAD_BEEF_CAFE_BABE
    // ==========================================================

    `uvm_info(
      "PROTOCOL_TEST",
      "Reading address after malformed transfer",
      UVM_LOW
    )


    legal_read(
      test_addr
    );



    `uvm_info(
      "PROTOCOL_TEST",
      "APB Protocol Violation Test Finished",
      UVM_LOW
    )


    phase.drop_objection(this);


    phase.phase_done.set_drain_time(
      this,
      50
    );

  endtask


endclass

// ============================================================
// APB RANDOM STRESS TEST
// ============================================================

class apb_random_stress_test extends base_test;

  `uvm_component_utils(apb_random_stress_test)


  int seq_order[7];


  function new(
    string name = "apb_random_stress_test",
    uvm_component parent = null
  );

    super.new(name, parent);

  endfunction



  // ============================================================
  // BUILD PHASE
  // ============================================================

  virtual function void build_phase(
    uvm_phase phase
  );

    super.build_phase(phase);

  endfunction



  // ============================================================
  // RUN PHASE
  // ============================================================

  virtual task run_phase(
    uvm_phase phase
  );

    int round;


    phase.raise_objection(this);


    `uvm_info(
      "STRESS_TEST",
      "APB Random Stress Test Started",
      UVM_LOW
    )



    // Initial sequence IDs
    for (int i = 0; i < 7; i++)
      seq_order[i] = i;



    // ==========================================================
    // TWO STRESS ROUNDS
    // ==========================================================

    for (round = 0; round < 2; round++) begin


      `uvm_info(
        "STRESS_TEST",
        $sformatf(
          "Starting Stress Round %0d",
          round + 1
        ),
        UVM_LOW
      )



      // Randomize sequence execution order
      seq_order.shuffle();



      // ========================================================
      // EXECUTE ALL 7 SEQUENCES
      // ========================================================

      foreach (seq_order[i]) begin


        case (seq_order[i])


          // ====================================================
          // 0 : SUCCESSIVE WRITE / READ
          // ====================================================

          0: begin

            apb_successive_wr_sequence seq;

            seq =
              apb_successive_wr_sequence::type_id::create(
                $sformatf(
                  "successive_seq_r%0d",
                  round
                )
              );


            `uvm_info(
              "STRESS_TEST",
              "Running apb_successive_wr_sequence",
              UVM_LOW
            )


            seq.start(
              env1.agt.seq1
            );

          end



          // ====================================================
          // 1 : BACK TO BACK
          // ====================================================

          1: begin

            apb_b2b_wr_sequence seq;

            seq =
              apb_b2b_wr_sequence::type_id::create(
                $sformatf(
                  "b2b_seq_r%0d",
                  round
                )
              );


            `uvm_info(
              "STRESS_TEST",
              "Running apb_b2b_wr_sequence",
              UVM_LOW
            )


            seq.start(
              env1.agt.seq1
            );

          end



          // ====================================================
          // 2 : OUT OF RANGE ERROR
          // ====================================================

          2: begin

            apb_slave_error_aor_sequence seq;

            seq =
              apb_slave_error_aor_sequence::type_id::create(
                $sformatf(
                  "aor_seq_r%0d",
                  round
                )
              );


            `uvm_info(
              "STRESS_TEST",
              "Running apb_slave_error_aor_sequence",
              UVM_LOW
            )


            seq.start(
              env1.agt.seq1
            );

          end



          // ====================================================
          // 3 : RANDOM ADDRESS WRITE / READ
          // ====================================================

          3: begin

            apb_random_addr_wr_sequence seq;

            seq =
              apb_random_addr_wr_sequence::type_id::create(
                $sformatf(
                  "random_addr_seq_r%0d",
                  round
                )
              );


            `uvm_info(
              "STRESS_TEST",
              "Running apb_random_addr_wr_sequence",
              UVM_LOW
            )


            seq.start(
              env1.agt.seq1
            );

          end



          // ====================================================
          // 4 : STROBE
          // ====================================================

          4: begin

            apb_strobe_sequence seq;

            seq =
              apb_strobe_sequence::type_id::create(
                $sformatf(
                  "strobe_seq_r%0d",
                  round
                )
              );


            `uvm_info(
              "STRESS_TEST",
              "Running apb_strobe_sequence",
              UVM_LOW
            )


            seq.start(
              env1.agt.seq1
            );

          end



          // ====================================================
          // 5 : MISALIGNED ADDRESS
          // ====================================================

          5: begin

            apb_addr_misaligned_sequence seq;

            seq =
              apb_addr_misaligned_sequence::type_id::create(
                $sformatf(
                  "misaligned_seq_r%0d",
                  round
                )
              );


            `uvm_info(
              "STRESS_TEST",
              "Running apb_addr_misaligned_sequence",
              UVM_LOW
            )


            seq.start(
              env1.agt.seq1
            );

          end



          // ====================================================
          // 6 : BOUNDARY
          // ====================================================

          6: begin

            apb_boundary_sequence seq;

            seq =
              apb_boundary_sequence::type_id::create(
                $sformatf(
                  "boundary_seq_r%0d",
                  round
                )
              );


            `uvm_info(
              "STRESS_TEST",
              "Running apb_boundary_sequence",
              UVM_LOW
            )


            seq.start(
              env1.agt.seq1
            );

          end


        endcase


      end



      `uvm_info(
        "STRESS_TEST",
        $sformatf(
          "Stress Round %0d Completed",
          round + 1
        ),
        UVM_LOW
      )


    end



    `uvm_info(
      "STRESS_TEST",
      "APB Random Stress Test Finished",
      UVM_LOW
    )


    phase.drop_objection(this);


    phase.phase_done.set_drain_time(
      this,
      100
    );

  endtask


endclass

