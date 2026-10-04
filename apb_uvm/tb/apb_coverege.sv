`include "uvm_macros.svh"
import uvm_pkg::*;

class apb_coverage extends uvm_subscriber #(transaction);

  `uvm_component_utils(apb_coverage)

  transaction tr;


  // ============================================================
  // COVERGROUP
  // ============================================================

  covergroup apb_cg;

    option.per_instance = 1;


    // ==========================================================
    // READ / WRITE COVERAGE
    // ==========================================================

    cp_write : coverpoint tr.write {

      bins read  = {1'b0};
      bins write = {1'b1};

    }


    // ==========================================================
    // ADDRESS COVERAGE
    // ==========================================================

    cp_addr : coverpoint tr.addr {

      // Lowest legal address
      bins lowest = {
        32'h0000_0000
      };


      // Low address region
      bins low_addr = {
        [32'h0000_0008 : 32'h0000_00F8]
      };


      // Middle address region
      bins mid_addr = {
        [32'h0000_0100 : 32'h0000_FEF8]
      };


      // High address region
      bins high_addr = {
        [32'h0000_FF00 : 32'h0000_FFF0]
      };


      // Highest legal aligned address
      bins highest = {
        32'h0000_FFF8
      };


      // Addresses outside 64 KB memory
      bins out_of_range = {
        [32'h0001_0000 : 32'hFFFF_FFFF]
      };

    }


    // ==========================================================
    // ADDRESS ALIGNMENT COVERAGE
    //
    // 64-bit APB = 8 bytes
    //
    // Aligned:
    // addr[2:0] = 000
    //
    // Misaligned:
    // 001 - 111
    // ==========================================================

    cp_alignment : coverpoint tr.addr[2:0] {

      bins aligned = {
        3'b000
      };


      bins offset_1 = {
        3'b001
      };


      bins offset_2 = {
        3'b010
      };


      bins offset_3 = {
        3'b011
      };


      bins offset_4 = {
        3'b100
      };


      bins offset_5 = {
        3'b101
      };


      bins offset_6 = {
        3'b110
      };


      bins offset_7 = {
        3'b111
      };

    }


    // ==========================================================
    // PSTRB COVERAGE
    //
    // Only sampled during WRITE transaction
    // ==========================================================

    cp_strb : coverpoint tr.strb iff (tr.write) {

      // No byte enabled
      bins no_byte = {
        8'h00
      };


      // All bytes enabled
      bins full_write = {
        8'hFF
      };


      // Lowest byte
      bins byte0 = {
        8'h01
      };


      // Highest byte
      bins byte7 = {
        8'h80
      };


      // Lower 4 bytes
      bins lower_half = {
        8'h0F
      };


      // Upper 4 bytes
      bins upper_half = {
        8'hF0
      };


      // Alternating bytes
      bins alternating_55 = {
        8'h55
      };


      bins alternating_AA = {
        8'hAA
      };


      // Two lowest bytes
      bins two_low_bytes = {
        8'h03
      };


      // Bytes 2 and 3
      bins middle_low = {
        8'h0C
      };


      // Bytes 4 and 5
      bins middle_high = {
        8'h30
      };


      // Two highest bytes
      bins two_high_bytes = {
        8'hC0
      };


      // First and last byte
      bins edge_bytes = {
        8'h81
      };


      // Middle byte pair
      bins inner_pair = {
        8'h18
      };


      // Other partial write patterns
      bins other_partial = {
        [8'h02 : 8'hFE]
      };

    }


    // ==========================================================
    // PSLVERR COVERAGE
    // ==========================================================

    cp_pslverr : coverpoint tr.pslverr {

      bins no_error = {
        1'b0
      };


      bins error = {
        1'b1
      };

    }


    // ==========================================================
    // CROSS COVERAGE
    // ==========================================================


    // ----------------------------------------------------------
    // READ / WRITE x PSLVERR
    //
    // Checks:
    // normal read
    // normal write
    // error read
    // error write
    // ----------------------------------------------------------

    cross_rw_error :
      cross cp_write, cp_pslverr;



    // ----------------------------------------------------------
    // READ / WRITE x ALIGNMENT
    //
    // Checks reads and writes for aligned/misaligned addresses
    // ----------------------------------------------------------

    cross_rw_alignment :
      cross cp_write, cp_alignment;



    // IMPORTANT:
    //
    // cross_write_strobe has intentionally been removed.
    //
    // cp_strb already has:
    //
    // iff (tr.write)
    //
    // Therefore cp_strb itself gives write-strobe coverage.
    //
    // A cross between cp_write and cp_strb would create
    // impossible READ x STROBE combinations.
    // ----------------------------------------------------------


  endgroup



  // ============================================================
  // CONSTRUCTOR
  // ============================================================

  function new(
    string name = "apb_coverage",
    uvm_component parent = null
  );

    super.new(name, parent);

    apb_cg = new();

  endfunction



  // ============================================================
  // RECEIVE TRANSACTION FROM MONITOR
  // ============================================================

  virtual function void write(transaction t);

    tr = t;

    apb_cg.sample();

  endfunction



  // ============================================================
  // REPORT FUNCTIONAL COVERAGE
  // ============================================================

  virtual function void report_phase(uvm_phase phase);

    real cov;

    super.report_phase(phase);

    cov = apb_cg.get_inst_coverage();


    `uvm_info(
      "APB_COVERAGE",
      $sformatf(
        "Functional Coverage = %0.2f%%",
        cov
      ),
      UVM_LOW
    )

  endfunction


endclass
