// class apb_sequence extends uvm_sequence#(transaction);
  
//   `uvm_object_utils(apb_sequence)
  
//   //--------------------------------------- 
//   //Constructor
//   //---------------------------------------
//   function new(string name = "apb_sequence");
//     super.new(name);
//   endfunction
  
//   `uvm_declare_p_sequencer(apb_sequencer)
  
//   //---------------------------------------
//   // create, randomize and send the item to driver
//   //---------------------------------------
//   virtual task body();
//    repeat(2) begin
//     req = transaction::type_id::create("req");
//     wait_for_grant();
//     req.randomize();
//     send_request(req);
//     wait_for_item_done();
//    end 
//   endtask

  
//   endclass


class apb_sequence extends uvm_sequence#(transaction);
  
  `uvm_object_utils(apb_sequence)
  
  //--------------------------------------- 
  //Constructor
  //---------------------------------------
  function new(string name = "apb_sequence");
    super.new(name);
  endfunction
  
   `uvm_declare_p_sequencer(apb_sequencer)
  
  //---------------------------------------
  // create, randomize and send the item to driver
  //---------------------------------------
  virtual task body();
   repeat(5) begin
    req = transaction::type_id::create("req");
    wait_for_grant();
    req.randomize();
    send_request(req);
    wait_for_item_done();
   end 
  endtask
  endclass
  class write_sequence extends uvm_sequence#(transaction);
  
  `uvm_object_utils(write_sequence)
   
  //--------------------------------------- 
  //Constructor
  //---------------------------------------
  function new(string name = "write_sequence");
    super.new(name);
     `uvm_info("Seq","Enter", UVM_LOW);
  endfunction
  
  // virtual task body();
  //   repeat(5) begin
  //    `uvm_do_with(req,{req.pwrite==1;})
  //   end
  // endtask
  virtual task body();
    // repeat(4) begin
    //   req = transaction::type_id::create("req");
    //   wait_for_grant();
    //   req.randomize();
    //   //  req.write=1;
    //   //  req.data=64'h9;
    //   //  req.addr=32'h0123_4567_89AB_C000;
    //   //  req.strb=8'hff;
    //   send_request(req);
    //   wait_for_item_done();
    // end 
    repeat(10) begin
    `uvm_do_with(req,{req.write==1;req.strb==8'hff;}) end
   endtask
endclass
//=========================================================================
// read_sequence - "read" type
//=========================================================================
class read_sequence extends uvm_sequence#(transaction);
  
  `uvm_object_utils(read_sequence)
   
  //--------------------------------------- 
  //Constructor
  //---------------------------------------
  function new(string name = "read_sequence");
    super.new(name);
  endfunction
   // virtual task body();
    // repeat(1) begin
    //   req = transaction::type_id::create("req");
    //   wait_for_grant();
    //  // req.randomize();
    //   // req.data=64'h9;
    //    req.addr=32'h0123_4567_89AB_C000;
    //   // req.strb=8'hff;
    //   send_request(req);
    //   wait_for_item_done();
   // end 
   virtual task body(); 
   repeat (10) begin 
    `uvm_do_with(req,{req.write==0;}) end
  endtask
   //endtask
endclass
//=========================================================================

//=========================================================================
// write_read_sequence - "write" followed by "read" 
//=========================================================================
class write_read_sequence extends uvm_sequence#(transaction);
  
  `uvm_object_utils(write_read_sequence)
   
  //--------------------------------------- 
  //Constructor
  //---------------------------------------
  function new(string name = "write_read_sequence");
    super.new(name);
  endfunction
  
  virtual task body();
    `uvm_do_with(req,{req.write==1;})
   //`uvm_do_with(req,{req.write==0;})
  endtask
endclass
//=========================================================================


//=========================================================================
// wr_rd_sequence - "write" followed by "read" (sequence's inside sequences)
//=========================================================================
class apb_wr_rd_sequence extends uvm_sequence #(transaction);

  `uvm_object_utils(apb_wr_rd_sequence)

  function new(string name = "apb_wr_rd_sequence");
    super.new(name);
  endfunction


  virtual task body();

    transaction req;

    bit [31:0] addr;
    bit [63:0] data;


    `uvm_info(
      get_type_name(),
      "APB Write/Read Sequence Started",
      UVM_LOW
    )


    // Run 10 write -> read operations
    repeat (10) begin

      // -------------------------------------------------
      // Generate one valid aligned address
      // -------------------------------------------------

      addr = $urandom_range(0, 8191) * 8;

      // Generate 64-bit random data
      data = {
        $urandom(),
        $urandom()
      };


      // =================================================
      // WRITE
      // =================================================

      req =
        transaction::type_id::create("write_req");

      start_item(req);

      req.write = 1'b1;
      req.addr  = addr;
      req.data  = data;
      req.strb  = 8'hFF;

      finish_item(req);



      // =================================================
      // READ SAME ADDRESS
      // =================================================

      req =
        transaction::type_id::create("read_req");

      start_item(req);

      req.write = 1'b0;
      req.addr  = addr;
      req.data  = '0;
      req.strb  = 8'h00;

      finish_item(req);

    end


    `uvm_info(
      get_type_name(),
      "APB Write/Read Sequence Finished",
      UVM_LOW
    )

  endtask


endclass
//=========================================================================
// ============================================================
// SUCCESSIVE WRITE / READ SEQUENCE
// ============================================================

class apb_successive_wr_sequence extends uvm_sequence #(transaction);

  `uvm_object_utils(apb_successive_wr_sequence)

  function new(string name = "apb_successive_wr_sequence");
    super.new(name);
  endfunction


  virtual task body();

    transaction req;

    bit [31:0] addr;
    bit [63:0] data;


    `uvm_info(get_type_name(),
              "Successive Write/Read Sequence Started",
              UVM_LOW)


    // --------------------------------------------------------
    // Write 31 successive locations
    // 0x0000, 0x0008, 0x0010 ...
    // --------------------------------------------------------

    for (int i = 0; i < 31; i++) begin

      addr = i * 8;

      data = 64'h1000_0000_0000_0000 + i;


      req = transaction::type_id::create(
              $sformatf("write_req_%0d", i));


      start_item(req);

      req.write = 1'b1;
      req.addr  = addr;
      req.data  = data;
      req.strb  = 8'hFF;

      finish_item(req);

    end


    // --------------------------------------------------------
    // Read exactly the same locations
    // --------------------------------------------------------

    for (int i = 0; i < 31; i++) begin

      addr = i * 8;


      req = transaction::type_id::create(
              $sformatf("read_req_%0d", i));


      start_item(req);

      req.write = 1'b0;
      req.addr  = addr;
      req.data  = '0;
      req.strb  = 8'h00;

      finish_item(req);

    end


    `uvm_info(get_type_name(),
              "Successive Write/Read Sequence Finished",
              UVM_LOW)

  endtask


endclass



// ============================================================
// BACK-TO-BACK WRITE -> READ
// ============================================================

class apb_b2b_wr_sequence extends uvm_sequence #(transaction);

  `uvm_object_utils(apb_b2b_wr_sequence)

  function new(string name = "apb_b2b_wr_sequence");
    super.new(name);
  endfunction


  virtual task body();

    transaction req;

    bit [31:0] target_addr;
    bit [63:0] write_data;


    target_addr = 32'h0000_0100;


    for (int i = 0; i < 10; i++) begin

      write_data =
        64'hA000_0000_0000_0000 + i;


      // WRITE
      req = transaction::type_id::create(
              $sformatf("b2b_write_req_%0d", i));

      start_item(req);

      req.write = 1'b1;
      req.addr  = target_addr;
      req.data  = write_data;
      req.strb  = 8'hFF;

      finish_item(req);


      // READ SAME ADDRESS
      req = transaction::type_id::create(
              $sformatf("b2b_read_req_%0d", i));

      start_item(req);

      req.write = 1'b0;
      req.addr  = target_addr;
      req.data  = '0;
      req.strb  = 8'h00;

      finish_item(req);

    end

  endtask

endclass



// ============================================================
// SLAVE ERROR / OUT-OF-RANGE SEQUENCE
// ============================================================

class apb_slave_error_aor_sequence extends uvm_sequence #(transaction);

  `uvm_object_utils(apb_slave_error_aor_sequence)

  function new(string name = "apb_slave_error_aor_sequence");
    super.new(name);
  endfunction


  virtual task body();

    transaction req;


    // OUT-OF-RANGE WRITE
    req = transaction::type_id::create("aor_write_req_0");

    start_item(req);

    req.write = 1'b1;
    req.addr  = 32'h0001_0000;
    req.data  = 64'hAAAA_BBBB_CCCC_DDDD;
    req.strb  = 8'hFF;

    finish_item(req);


    // OUT-OF-RANGE READ
    req = transaction::type_id::create("aor_read_req_0");

    start_item(req);

    req.write = 1'b0;
    req.addr  = 32'h0001_0000;
    req.data  = '0;
    req.strb  = 8'h00;

    finish_item(req);


    // SECOND OUT-OF-RANGE WRITE
    req = transaction::type_id::create("aor_write_req_1");

    start_item(req);

    req.write = 1'b1;
    req.addr  = 32'h0001_0008;
    req.data  = 64'h1111_2222_3333_4444;
    req.strb  = 8'hFF;

    finish_item(req);


    // SECOND OUT-OF-RANGE READ
    req = transaction::type_id::create("aor_read_req_1");

    start_item(req);

    req.write = 1'b0;
    req.addr  = 32'h0001_0008;
    req.data  = '0;
    req.strb  = 8'h00;

    finish_item(req);
	for (int bit_no = 17; bit_no <= 31; bit_no++) begin

  req = transaction::type_id::create(
          $sformatf("high_aor_write_%0d", bit_no));

  start_item(req);

  req.write = 1'b1;
  req.addr  = (32'h1 << bit_no);
  req.data  = 64'hAAAA_0000_0000_0000 + bit_no;
  req.strb  = 8'hFF;

  finish_item(req);


  req = transaction::type_id::create(
          $sformatf("high_aor_read_%0d", bit_no));

  start_item(req);

  req.write = 1'b0;
  req.addr  = (32'h1 << bit_no);
  req.data  = '0;
  req.strb  = 8'h00;

  finish_item(req);

end

  endtask


endclass



// ============================================================
// RANDOM ADDRESS WRITE -> SAME ADDRESS READ
// ============================================================

class apb_random_addr_wr_sequence extends uvm_sequence #(transaction);

  `uvm_object_utils(apb_random_addr_wr_sequence)

  function new(string name = "apb_random_addr_wr_sequence");
    super.new(name);
  endfunction


  virtual task body();

    transaction req;

    bit [31:0] addr;
    bit [63:0] data;


    repeat (20) begin

      // valid 8-byte aligned address
      addr = $urandom_range(0,8191) * 8;

      data = {$urandom(), $urandom()};


      // WRITE
      req =
        transaction::type_id::create("random_write_req");

      start_item(req);

      req.write = 1'b1;
      req.addr  = addr;
      req.data  = data;
      req.strb  = 8'hFF;

      finish_item(req);


      // READ SAME ADDRESS
      req =
        transaction::type_id::create("random_read_req");

      start_item(req);

      req.write = 1'b0;
      req.addr  = addr;
      req.data  = '0;
      req.strb  = 8'h00;

      finish_item(req);

    end

  endtask

endclass
class apb_strobe_sequence extends uvm_sequence #(transaction);

  `uvm_object_utils(apb_strobe_sequence)

  transaction req;

  bit [31:0] test_addr = 32'h0000_0200;

  bit [7:0] strb_list[14] = '{
    8'hFF,
    8'h01,
    8'h80,
    8'h0F,
    8'hF0,
    8'h55,
    8'hAA,
    8'h03,
    8'h0C,
    8'h30,
    8'hC0,
    8'h81,
    8'h18,
    8'h00
  };

  bit [63:0] data_list[14] = '{
    64'h1122_3344_5566_7788,
    64'h0000_0000_0000_00AA,
    64'hBB00_0000_0000_0000,
    64'h0000_0000_DEAD_BEEF,
    64'hCAFE_BABE_0000_0000,
    64'h0102_0304_0506_0708,
    64'h1020_3040_5060_7080,
    64'h0000_0000_0000_BBCC,
    64'h0000_0000_DDEE_0000,
    64'h0000_1122_0000_0000,
    64'h3344_0000_0000_0000,
    64'hAA00_0000_0000_00BB,
    64'h0000_0000_CC00_DD00,
    64'hFFFF_FFFF_FFFF_FFFF
  };


  function new(string name = "apb_strobe_sequence");
    super.new(name);
  endfunction


  virtual task body();

    `uvm_info(
      "STROBE_SEQ",
      "APB Strobe Sequence Started",
      UVM_LOW
    )


    // ==========================================================
    // Run all strobe patterns
    // ==========================================================

    foreach (strb_list[i]) begin


      // --------------------------------------------------------
      // WRITE
      // --------------------------------------------------------

      req = transaction::type_id::create(
        $sformatf("strobe_write_%0d", i)
      );

      start_item(req);

      req.write = 1'b1;
      req.addr  = test_addr;
      req.data  = data_list[i];
      req.strb  = strb_list[i];

      finish_item(req);


      // --------------------------------------------------------
      // READ BACK
      // --------------------------------------------------------

      req = transaction::type_id::create(
        $sformatf("strobe_read_%0d", i)
      );

      start_item(req);

      req.write = 1'b0;
      req.addr  = test_addr;
      req.data  = '0;
      req.strb  = 8'h00;

      finish_item(req);

    end


    `uvm_info(
      "STROBE_SEQ",
      "APB Strobe Sequence Finished",
      UVM_LOW
    )

  endtask

endclass

class apb_addr_misaligned_sequence extends uvm_sequence #(transaction);

  `uvm_object_utils(apb_addr_misaligned_sequence)

  transaction req;

  bit [31:0] misaligned_addr[7] = '{
    32'h0000_0101,
    32'h0000_0102,
    32'h0000_0103,
    32'h0000_0104,
    32'h0000_0105,
    32'h0000_0106,
    32'h0000_0107
  };


  function new(
    string name = "apb_addr_misaligned_sequence"
  );

    super.new(name);

  endfunction


  virtual task body();

    `uvm_info(
      "MISALIGNED_SEQ",
      "APB Misaligned Address Sequence Started",
      UVM_LOW
    )


    // ==========================================================
    // Test every invalid byte offset for 64-bit APB
    //
    // Valid alignment:
    // addr[2:0] = 000
    //
    // Invalid:
    // 001 - 111
    // ==========================================================

    foreach (misaligned_addr[i]) begin


      // --------------------------------------------------------
      // MISALIGNED WRITE
      // --------------------------------------------------------

      req = transaction::type_id::create(
        $sformatf(
          "misaligned_write_%0d",
          i
        )
      );


      start_item(req);

      req.write = 1'b1;

      req.addr =
        misaligned_addr[i];

      req.data =
        64'hA100_0000_0000_0000 + i;

      req.strb =
        8'hFF;

      finish_item(req);



      // --------------------------------------------------------
      // MISALIGNED READ
      // --------------------------------------------------------

      req = transaction::type_id::create(
        $sformatf(
          "misaligned_read_%0d",
          i
        )
      );


      start_item(req);

      req.write = 1'b0;

      req.addr =
        misaligned_addr[i];

      req.data =
        64'h0;

      req.strb =
        8'h00;

      finish_item(req);

    end


    `uvm_info(
      "MISALIGNED_SEQ",
      "APB Misaligned Address Sequence Finished",
      UVM_LOW
    )

  endtask


endclass

class apb_boundary_sequence extends uvm_sequence #(transaction);

  `uvm_object_utils(apb_boundary_sequence)

  function new(string name = "apb_boundary_sequence");
    super.new(name);
  endfunction


  virtual task body();

    transaction req;


    // LOWEST ADDRESS WRITE
    req = transaction::type_id::create("low_boundary_write");

    start_item(req);

    req.write = 1'b1;
    req.addr  = 32'h0000_0000;
    req.data  = 64'h1111_2222_3333_4444;
    req.strb  = 8'hFF;

    finish_item(req);



    // HIGHEST ALIGNED VALID ADDRESS WRITE
    req = transaction::type_id::create("high_boundary_write");

    start_item(req);

    req.write = 1'b1;
    req.addr  = 32'h0000_FFF8;
    req.data  = 64'hAAAA_BBBB_CCCC_DDDD;
    req.strb  = 8'hFF;

    finish_item(req);



    // READ LOW
    req = transaction::type_id::create("low_boundary_read");

    start_item(req);

    req.write = 1'b0;
    req.addr  = 32'h0000_0000;
    req.data  = '0;
    req.strb  = 8'h00;

    finish_item(req);



    // READ HIGH
    req = transaction::type_id::create("high_boundary_read");

    start_item(req);

    req.write = 1'b0;
    req.addr  = 32'h0000_FFF8;
    req.data  = '0;
    req.strb  = 8'h00;

    finish_item(req);

  endtask

endclass

// ============================================================
// APB RESET SEQUENCE
// ============================================================

class apb_reset_sequence extends uvm_sequence #(transaction);

  `uvm_object_utils(apb_reset_sequence)


  virtual apb_intr vif;


  function new(
    string name = "apb_reset_sequence"
  );

    super.new(name);

  endfunction


  virtual task body();


    // --------------------------------------------------------
    // Get interface
    // --------------------------------------------------------

    if (!uvm_config_db#(virtual apb_intr)::get(
          null,
          "*",
          "vif",
          vif
        ))
    begin

      `uvm_fatal(
        "RESET_SEQ",
        "Virtual interface not found"
      )

    end


    // --------------------------------------------------------
    // ASSERT RESET
    // --------------------------------------------------------

    `uvm_info(
      "RESET_SEQ",
      "Asserting APB reset",
      UVM_LOW
    )


    @(negedge vif.PCLK);

    vif.PRESETn = 1'b0;


    // Hold reset for 4 clocks
    repeat (4)
      @(posedge vif.PCLK);


    // --------------------------------------------------------
    // CHECK RESET OUTPUTS
    //
    // According to current DUT behavior:
    //
    // PREADY  = Z
    // PSLVERR = Z
    // PRDATA  = Z
    // --------------------------------------------------------

    if (vif.PREADY !== 1'bz) begin

      `uvm_error(
        "RESET_SEQ",
        $sformatf(
          "PREADY incorrect during reset. Expected=Z Actual=%b",
          vif.PREADY
        )
      )

    end


    if (vif.PSLVERR !== 1'bz) begin

      `uvm_error(
        "RESET_SEQ",
        $sformatf(
          "PSLVERR incorrect during reset. Expected=Z Actual=%b",
          vif.PSLVERR
        )
      )

    end


    if (vif.PRDATA !== 64'hzzzz_zzzz_zzzz_zzzz) begin

      `uvm_error(
        "RESET_SEQ",
        $sformatf(
          "PRDATA incorrect during reset. Expected=Z Actual=%h",
          vif.PRDATA
        )
      )

    end


    `uvm_info(
      "RESET_SEQ",
      $sformatf(
        "During RESET: PRESETn=%b PREADY=%b PSLVERR=%b PRDATA=%h",
        vif.PRESETn,
        vif.PREADY,
        vif.PSLVERR,
        vif.PRDATA
      ),
      UVM_LOW
    )


    // --------------------------------------------------------
    // RELEASE RESET
    // --------------------------------------------------------

    @(negedge vif.PCLK);

    vif.PRESETn = 1'b1;


    // Give DUT time to return to idle
    repeat (2)
      @(posedge vif.PCLK);


    `uvm_info(
      "RESET_SEQ",
      "APB reset released",
      UVM_LOW
    )


  endtask


endclass



// ============================================================
// POST-RESET WRITE / READ SEQUENCE
// ============================================================

class apb_post_reset_sequence extends uvm_sequence #(transaction);

  `uvm_object_utils(apb_post_reset_sequence)


  function new(
    string name = "apb_post_reset_sequence"
  );

    super.new(name);

  endfunction


  virtual task body();

    transaction req;

    bit [31:0] test_addr;
    bit [63:0] test_data;


    test_addr =
      32'h0000_0100;

    test_data =
      64'h1234_5678_ABCD_EF01;


    `uvm_info(
      get_type_name(),
      "Post-reset APB check started",
      UVM_LOW
    )


    // ========================================================
    // WRITE AFTER RESET
    // ========================================================

    req =
      transaction::type_id::create(
        "post_reset_write"
      );


    start_item(req);

    req.write = 1'b1;
    req.addr  = test_addr;
    req.data  = test_data;
    req.strb  = 8'hFF;

    finish_item(req);



    // ========================================================
    // READ SAME ADDRESS
    // ========================================================

    req =
      transaction::type_id::create(
        "post_reset_read"
      );


    start_item(req);

    req.write = 1'b0;
    req.addr  = test_addr;
    req.data  = '0;
    req.strb  = 8'h00;

    finish_item(req);


    `uvm_info(
      get_type_name(),
      "Post-reset APB check finished",
      UVM_LOW
    )


  endtask


endclass



