interface apb_intr(input bit PCLK);
       bit                 PRESETn;
      logic                  PSELx;
      logic                  PENABLE;
       logic                  PWRITE;
       logic  [63:0]           PWDATA;
       logic  [7:0]           PSTRB;
       logic  [31:0]            PADDR;
       logic  [63:0]           PRDATA;
      logic                  PREADY;
      logic                  PSLVERR;

clocking drv_cb @(posedge PCLK);
        default input #1step output #1;
        output PSELx, PENABLE, PWRITE, PADDR, PWDATA, PSTRB;
        input  PRDATA, PREADY, PSLVERR;
    endclocking

    clocking mon_cb @(posedge PCLK);
        default input #1step;
        input PSELx, PENABLE, PWRITE, PADDR, PWDATA, PSTRB;
        input PRDATA, PREADY, PSLVERR;
    endclocking

  modport DRIVER  (clocking drv_cb,input PCLK);
  
  modport MONITOR (clocking mon_cb,input PCLK);

endinterface