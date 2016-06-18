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

    // output signals
    wire    [6 : 0] sig_digi2, sig_digi1, sig_digi0;
    wire    [15: 0] ap;
    wire    [6 : 0] hour_digi0, hour_digi_1;
    wire    [6 : 0] minute_digi0, minute_digi_1;
    
    // local variables
    reg     [15: 0] addr;
    reg     conf_filter;
    reg     conf_timer;
    
    wire    [7 : 0] hour_hex, minute_hex;
    wire    [3 : 0] hour_bcd0, hour_bcd1;
    wire    [3 : 0] minute_bcd0, minute_bcd1;

    // address latch
    always @ (abus or dbus or ale) begin
        if (ale && ~cs_n) begin
            addr <= {abus, dbus};
        end
    end

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
    
    // filter amplify conversion
    sqrt_amp sqrt_amp_inst (
        .clock  (clock  ),
        .rst_n  (rst_n  ),
        .data   (sig_out),
        .ap     (ap     )
    );

    // timer
    timer timer_inst (
        .clock  (clock  ),
        .rst_n  (rst_n  ),
        .w_n    (w_n    ),
        .w_en_n (cs_n   ),
        .t      (dbus   ),
        .addr   (addr   ),
        .hour   (hour_hex   ),
        .minute (minute_hex )
    );
    
    // bcd encoders
    hex2bcd hex2bcd_hour_inst (
        .clock  (clock  ),
        .rst_n  (rst_n  ),
        .hex    (hour   ),
        .bcd_0  (hour_bcd0  ),
        .bcd_1  (hour_bcd1  ),
        .bcd_2  (/*no use*/ )
    );
    
    hex2bcd hex2bcd_minute_inst (
        .clock  (clock  ),
        .rst_n  (rst_n  ),
        .hex    (hour   ),
        .bcd_0  (minute_bcd0),
        .bcd_1  (minute_bcd1),
        .bcd_2  (/*no use*/ )
    );
    
    
    
    

endmodule
