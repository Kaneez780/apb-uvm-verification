
// `include "uvm_macros.svh"
// import uvm_pkg::*;
// `include "test.sv"
// `include "apb_wrapper.sv"
// `include "interface.sv"
// module tb;
// logic clk;
// logic resetn;
// apb_if if1();
// apb_wrapper DUT(.PCLK(clk),
// .PRESETn(resetn),
// .PSELx(if1.PSELx),
// .PENABLE(if1.PENABLE),
// .PWRITE(if1.PWRITE),
// .PWDATA(if1.PWDATA),
// .PSTRB(if1.PSTRB),
// .PADDR(if1.PADDR),
// .PRDATA(if1.PRDATA),
// .PREADY(if1.PREADY),
// .PSLVERR(if1.PSLVERR));
//  initial begin
//   uvm_config_db #(virtual apb_if)::set (null, "uvm_test_top", "interface", if1);
//    run_test("test");
//  end
// endmodule
//-------------------------------------------------------------------------
//				www.verificationguide.com   testbench.sv
//-------------------------------------------------------------------------
//---------------------------------------------------------------
//including interfcae and testcase files
//`include "apb_intr.sv"
//`include "apb_wrapper.sv"
`include "uvm_macros.svh"
import uvm_pkg::*;

module tbench_top;


  bit PCLK;
  bit PRESETn;
  

  always #5 PCLK = ~PCLK;
  
  //---------------------------------------
  //PRESETn Generation
  //---------------------------------------
  initial begin
    PRESETn = 0;
    #2 PRESETn =1;
    // #2 PRESETn =0;
    // #2 PRESETn =1;

  end
  
  //---------------------------------------
  //interface instance
  //---------------------------------------
  apb_intr if1(.PCLK(PCLK));
  
  //---------------------------------------
  //DUT instance
  //---------------------------------------
 apb_wrapper DUT(.PCLK(if1.PCLK),
            .PRESETn(PRESETn),
            .PSELx(if1.PSELx),
            .PENABLE(if1.PENABLE),
            .PWRITE(if1.PWRITE),
            .PWDATA(if1.PWDATA),
            .PSTRB(if1.PSTRB),
            .PADDR(if1.PADDR),
            .PRDATA(if1.PRDATA),
            .PREADY(if1.PREADY),
            .PSLVERR(if1.PSLVERR));

  initial begin 
    uvm_config_db#(virtual apb_intr)::set(uvm_root::get(),"*","vif",if1);
     `uvm_info("Testbench","Enter", UVM_LOW);
    // //enable wave dump
    // $dumpfile("dump.vcd"); 
    // $dumpvars;
    $vcdplusfile("waveform.vpd"); 
    $vcdpluson;
   //  #1000; $finish;
  end
  
  //---------------------------------------
  //calling test
  //---------------------------------------
initial begin

  uvm_root::get().set_timeout(
    50us,
    1
  );

  run_test();

end
 // initial begin 
 //   run_test();
  //end
  
endmodule 
