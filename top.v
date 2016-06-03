module TH99CHLS (
    input   clock,
    input   rst_n,

    // 8051 control port
    input   cs_n,           // chip selection
    input   [7 : 0] abus,   // address bus
    input   ale,            // negedge triggers address latch
    input   r_n,            // posedge triggers cpu read
    input   w_n,            // posedge triggers logic read
    inout   [7 : 0] dbus,   // data bus

    // data input port
    input   pe_n,           // input valid
    input   [7 : 0] sig_in, // input signal

    // data output port

    // display port
    output  [65: 0] display
    );

    reg     [15: 0] addr;
    reg     conf_filter;
    reg     conf_timer;

    // address latch
    always @ (abus or dbus or ale) begin
        if (ale && ~cs_n) begin
            addr <= {abus, dbus};
        end
    end

    // module selection

    // filter
    filter filter_inst (
        .clock  (clock      ),
        .rst_n  (rst_n      ),
        .w_n    (conf_filter),
        .w_en_n (cs_n       ),
        .p      (dbus       ),
        .addr   (addr       ),
        .x_valid(pe_n       ),
        .x      (sig_in     ),
        .y      (sig_out    )
    );

    // timer

    // display encoder


endmodule
