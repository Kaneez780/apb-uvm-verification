class apb_scoreboard extends uvm_scoreboard;

  `uvm_component_utils(apb_scoreboard)



  // ---------------------------------------------------
  // Reference Memory
  //
  // DUT memory size = 64 KB
  //
  // 64 KB = 65536 bytes
  //
  // One APB data word = 64 bits = 8 bytes
  //
  // Number of locations:
  //
  // 65536 / 8 = 8192
  //
  // ---------------------------------------------------

  bit [63:0] ref_mem [0:8191];



  // ---------------------------------------------------
  // valid_bytes
  //
  // Keeps track of which bytes were actually written.
  //
  // This is useful because DUT RAM might not be
  // initialized after reset.
  //
  // Example:
  //
  // PSTRB = 00001111
  //
  // only lower 4 bytes are valid.
  //
  // ---------------------------------------------------

  bit [7:0] valid_bytes [0:8191];



  // Transaction queue
  transaction pkt_qu[$];



  // Analysis implementation
  uvm_analysis_imp #(
    transaction,
    apb_scoreboard
  ) item_collected_export;



  // ---------------------------------------------------
  // Constructor
  // ---------------------------------------------------

  function new(
    string name,
    uvm_component parent
  );

    super.new(name, parent);

  endfunction



  // ---------------------------------------------------
  // Build Phase
  // ---------------------------------------------------

  function void build_phase(
    uvm_phase phase
  );

    super.build_phase(phase);


    item_collected_export =
      new(
        "item_collected_export",
        this
      );


    // Initialize reference model
    foreach(ref_mem[i])
    begin

      ref_mem[i] = '0;

      valid_bytes[i] = '0;

    end


    `uvm_info(
      "SCOREBOARD",
      "Build phase executed",
      UVM_LOW
    )


  endfunction



  // ===================================================
  // ADDRESS TO MEMORY INDEX
  // ===================================================
  //
  // Address is byte address.
  //
  // Each memory word = 8 bytes.
  //
  // Example:
  //
  // Address 0x0000 -> index 0
  // Address 0x0008 -> index 1
  // Address 0x0010 -> index 2
  //
  // ===================================================

  function automatic int unsigned addr_to_idx(
    bit [31:0] addr
  );

    return (addr >> 3);

  endfunction



  // ===================================================
  // CHECK VALID ADDRESS
  // ===================================================
  //
  // Valid memory range:
  //
  // 0x00000000
  //      to
  // 0x0000FFF8
  //
  // Addresses must also be 8-byte aligned.
  //
  // ===================================================

  function automatic bit is_valid_addr(
    bit [31:0] addr
  );


    // Outside 64 KB
    if (addr >= 32'h0001_0000)

      return 1'b0;


    // Misaligned address
    if (addr[2:0] != 3'b000)

      return 1'b0;


    return 1'b1;


  endfunction



  // ===================================================
  // WRITE WITH PSTRB
  // ===================================================
  //
  // Example:
  //
  // data =
  // 1122334455667788
  //
  // strb =
  // 00001111
  //
  // Only:
  //
  // 55667788
  //
  // is written into lower 4 bytes.
  //
  // ===================================================

  function automatic void write_with_strb(

    bit [31:0] addr,

    bit [63:0] data,

    bit [7:0] strb

  );


    int unsigned idx;


    idx = addr_to_idx(addr);



    for(
      int lane = 0;
      lane < 8;
      lane++
    )
    begin


      if(strb[lane])
      begin


        ref_mem[idx]
          [8*lane +: 8]

          =

        data
          [8*lane +: 8];


        // Mark this byte as valid
        valid_bytes[idx][lane] =
          1'b1;


      end

    end


  endfunction



  // ===================================================
  // ANALYSIS WRITE FUNCTION
  // ===================================================

  virtual function void write(
    transaction pkt
  );


    transaction pkt_copy;



    // Clone transaction so scoreboard has
    // its own copy.
    if(!$cast(
        pkt_copy,
        pkt.clone()
       ))
    begin

      `uvm_fatal(
        "SCB_CLONE",
        "Failed to clone transaction received by scoreboard"
      )

    end



    pkt_qu.push_back(
      pkt_copy
    );


  endfunction



  // ===================================================
  // COMPARE KNOWN BYTES
  // ===================================================
  //
  // Only compare bytes which were previously written.
  //
  // ===================================================

  function automatic bit compare_known_bytes(

    int unsigned idx,

    bit [63:0] actual

  );


    bit match;


    match = 1'b1;



    for(
      int lane = 0;
      lane < 8;
      lane++
    )
    begin


      if(valid_bytes[idx][lane])
      begin


        if(

          actual[8*lane +: 8]

          !==

          ref_mem[idx][8*lane +: 8]

        )
        begin

          match = 1'b0;

        end


      end

    end


    return match;


  endfunction



  // ===================================================
  // RUN PHASE
  // ===================================================

  virtual task run_phase(
    uvm_phase phase
  );


    transaction tr_pkt;


    int unsigned idx;


    bit expected_error;



    forever
    begin


      // Wait until monitor sends a transaction
      wait(pkt_qu.size() > 0);



      tr_pkt =
        pkt_qu.pop_front();



      // -----------------------------------------------
      // Calculate expected PSLVERR
      // -----------------------------------------------

      expected_error =
        !is_valid_addr(
          tr_pkt.addr
        );



      // ===============================================
      // PSLVERR CHECKING
      // ===============================================

      if(
        tr_pkt.pslverr
        !==
        expected_error
      )
      begin


        `uvm_error(

          "APB_SCB_ERR",

          $sformatf(

            "PSLVERR mismatch: ADDR=0x%08h WRITE=%0b EXPECTED_ERR=%0b ACTUAL_ERR=%0b",

            tr_pkt.addr,

            tr_pkt.write,

            expected_error,

            tr_pkt.pslverr

          )

        )


      end

      else
      begin


        `uvm_info(

          "APB_SCB_ERR",

          $sformatf(

            "PSLVERR correct: ADDR=0x%08h EXPECTED=%0b ACTUAL=%0b",

            tr_pkt.addr,

            expected_error,

            tr_pkt.pslverr

          ),

          UVM_HIGH

        )


      end



      // -----------------------------------------------
      // Invalid transaction should not modify/check
      // normal reference memory.
      // -----------------------------------------------

      if(expected_error)

        continue;



      // Convert address into memory index
      idx =
        addr_to_idx(
          tr_pkt.addr
        );



      // =================================================
      // WRITE TRANSACTION
      // =================================================

      if(tr_pkt.write)
      begin


        write_with_strb(

          tr_pkt.addr,

          tr_pkt.data,

          tr_pkt.strb

        );



        `uvm_info(

          "APB_SCB_WRITE",

          $sformatf(

            "WRITE OK: ADDR=0x%08h IDX=%0d DATA=0x%016h STRB=0x%02h MODEL=0x%016h VALID_BYTES=0x%02h",

            tr_pkt.addr,

            idx,

            tr_pkt.data,

            tr_pkt.strb,

            ref_mem[idx],

            valid_bytes[idx]

          ),

          UVM_LOW

        )


      end



      // =================================================
      // READ TRANSACTION
      // =================================================

      else
      begin



        // -----------------------------------------------
        // Address was never written
        // -----------------------------------------------

        if(
          valid_bytes[idx]
          ==
          8'h00
        )
        begin


          `uvm_warning(

            "APB_SCB_UNWRITTEN",

            $sformatf(

              "READ from never-written address 0x%08h. Data comparison skipped because DUT RAM initial value is unknown.",

              tr_pkt.addr

            )

          )


        end



        // -----------------------------------------------
        // Read matched
        // -----------------------------------------------

        else if(

          compare_known_bytes(
            idx,
            tr_pkt.rdata
          )

        )
        begin


          `uvm_info(

            "APB_SCB_READ",

            $sformatf(

              "READ MATCH: ADDR=0x%08h IDX=%0d EXPECTED=0x%016h ACTUAL=0x%016h VALID_BYTES=0x%02h",

              tr_pkt.addr,

              idx,

              ref_mem[idx],

              tr_pkt.rdata,

              valid_bytes[idx]

            ),

            UVM_LOW

          )


        end



        // -----------------------------------------------
        // Read mismatch
        // -----------------------------------------------

        else
        begin


          `uvm_error(

            "APB_SCB_READ",

            $sformatf(

              "READ MISMATCH: ADDR=0x%08h IDX=%0d EXPECTED=0x%016h ACTUAL=0x%016h VALID_BYTES=0x%02h",

              tr_pkt.addr,

              idx,

              ref_mem[idx],

              tr_pkt.rdata,

              valid_bytes[idx]

            )

          )


        end


      end


    end


  endtask


endclass