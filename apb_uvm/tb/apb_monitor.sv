class apb_monitor extends uvm_monitor;

  `uvm_component_utils(apb_monitor)


  virtual apb_intr vif;


  // Monitor sends transactions through this port
  // Scoreboard and coverage can connect to this.
  uvm_analysis_port #(transaction) item_collected_port;



  function new(string name, uvm_component parent);

    super.new(name, parent);

    item_collected_port =
      new("item_collected_port", this);

  endfunction



  function void build_phase(uvm_phase phase);

    super.build_phase(phase);

    `uvm_info(
      "MONITOR",
      "Build phase executed",
      UVM_LOW
    )


    if (!uvm_config_db#(virtual apb_intr)::get(
          this,
          "",
          "vif",
          vif
        ))
    begin

      `uvm_fatal(
        "NOVIF",
        {
          "Virtual interface must be set for ",
          get_full_name(),
          ".vif"
        }
      )

    end

  endfunction



  virtual task run_phase(uvm_phase phase);

    transaction trans_collected;

    forever begin

        // Wait until an APB ACCESS phase starts
        do begin
            @(vif.mon_cb);
        end
        while (!(vif.mon_cb.PSELx &&
                 vif.mon_cb.PENABLE));



        // APB can have wait states.
        // Stay here until PREADY becomes 1.
        while (vif.mon_cb.PREADY !== 1'b1) begin
            @(vif.mon_cb);
        end



        // Create ONE transaction for this APB transfer
        trans_collected =
            transaction::type_id::create(
                "trans_collected",
                this
            );



        // Sample completed transfer
        trans_collected.addr =
            vif.mon_cb.PADDR;

        trans_collected.write =
            vif.mon_cb.PWRITE;

        trans_collected.strb =
            vif.mon_cb.PSTRB;

        trans_collected.pselx =
            vif.mon_cb.PSELx;

        trans_collected.penable =
            vif.mon_cb.PENABLE;

        trans_collected.pready =
            vif.mon_cb.PREADY;

        trans_collected.pslverr =
            vif.mon_cb.PSLVERR;

        trans_collected.rdata =
            vif.mon_cb.PRDATA;

        trans_collected.prdata =
            vif.mon_cb.PRDATA;



        if (trans_collected.write)

            trans_collected.data =
                vif.mon_cb.PWDATA;

        else

            trans_collected.data =
                '0;



        `uvm_info(
            "APB_MONITOR",
            $sformatf(
                "TRANSFER: ADDR=0x%08h WRITE=%0b WDATA=0x%016h RDATA=0x%016h STRB=0x%02h PSLVERR=%0b",
                trans_collected.addr,
                trans_collected.write,
                trans_collected.data,
                trans_collected.rdata,
                trans_collected.strb,
                trans_collected.pslverr
            ),
            UVM_MEDIUM
        )



        item_collected_port.write(
            trans_collected
        );



        // ------------------------------------------------
        // VERY IMPORTANT
        //
        // Do not sample the same ACCESS phase again.
        // Wait until PENABLE drops before detecting
        // another transaction.
        // ------------------------------------------------

        do begin
            @(vif.mon_cb);
        end
        while (vif.mon_cb.PENABLE === 1'b1);

    end

endtask

endclass