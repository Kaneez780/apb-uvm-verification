`include "uvm_macros.svh"
import uvm_pkg::*;

class transaction extends uvm_sequence_item;

  static int count = 0;
  int id;

  // Request fields
  rand bit [31:0] addr;
  rand bit [63:0] data;
  rand bit        write;
  rand bit [7:0]  strb;

  // Observed/response fields
  bit             pselx;
  bit             penable;
  bit             pready;
  bit [63:0]      prdata;
  bit [63:0]      rdata;
  bit             pslverr;

  int repeat_count;
  virtual apb_intr vif;

  function new(string name = "transaction");
    super.new(name);
  endfunction

  // 64-bit bus = 8 bytes per transfer
  // Therefore valid addresses must be 8-byte aligned
  constraint addr_range_c {
    addr inside {[32'h0000_0000 : 32'h0000_FFF8]};
    addr[2:0] == 3'b000;
  }

  constraint write_dist_c {
    write dist {
      1'b1 := 50,
      1'b0 := 50
    };
  }

  constraint strobe_c {

    if (write) {

      strb dist {

        8'hFF := 15,   // all 8 bytes
        8'h0F := 10,   // lower 4 bytes
        8'hF0 := 10,   // upper 4 bytes

        8'h01 := 10,
        8'h80 := 10,

        8'h55 := 10,
        8'hAA := 10,

        8'h33 := 5,
        8'hCC := 5,

        8'h11 := 5,
        8'h22 := 5,
        8'h44 := 5,
        8'h88 := 5,

        [8'h01:8'hFE] := 5
      };

    }
    else {

      // Strobe does not matter for APB read.
      strb == 8'h00;

    }

  }

  constraint data_dist_c {

    data dist {

      64'h0000_0000_0000_0000 := 10,
      64'hFFFF_FFFF_FFFF_FFFF := 10,

      64'hAAAA_AAAA_AAAA_AAAA := 10,
      64'h5555_5555_5555_5555 := 10,

      64'h0123_4567_89AB_CDEF := 5,
      64'hFEDC_BA98_7654_3210 := 5,

      64'h8000_0000_0000_0000 := 5,
      64'h0000_0000_0000_0001 := 5,

      [64'h1:64'hFFFF_FFFF_FFFF_FFFE] := 35
    };

  }

  function void assign_id();

    id = count;
    count++;

  endfunction


  `uvm_object_utils_begin(transaction)

    `uvm_field_int(id,      UVM_DEFAULT)

    `uvm_field_int(addr,    UVM_DEFAULT)
    `uvm_field_int(data,    UVM_DEFAULT)
    `uvm_field_int(write,   UVM_DEFAULT)
    `uvm_field_int(strb,    UVM_DEFAULT)

    `uvm_field_int(pselx,   UVM_DEFAULT)
    `uvm_field_int(penable, UVM_DEFAULT)
    `uvm_field_int(pready,  UVM_DEFAULT)

    `uvm_field_int(prdata,  UVM_DEFAULT)
    `uvm_field_int(rdata,   UVM_DEFAULT)

    `uvm_field_int(pslverr, UVM_DEFAULT)

  `uvm_object_utils_end


endclass
