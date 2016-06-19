module TH99CHLS (
    input   clk,
    input   rst_n,

    // 8051 control port
    input   cs_n,           // chip selection
    input   [7 : 0] abus,   // address bus
    input   ale,            // negedge triggers address latch
    input   r_n,            // posedge triggers cpu read
    input   w_n,            // posedge triggers logic read
    input   [7 : 0] dbus,   // data bus

    // data input port
    input   pe_n,           // input valid
    input   [7 : 0] sig_in, // input signal

    // data output port
    output  [6 : 0] sig_digi2,
    output  [6 : 0] sig_digi1,
    output  [6 : 0] sig_digi0,

    output  [6 : 0] hour_digi1,
    output  [6 : 0] hour_digi0,

    output  [6 : 0] minute_digi1,
    output  [6 : 0] minute_digi0,

    output  [15: 0] ap
    );

    // local variables
    reg     [15: 0] addr;
    reg     w_n_prev, cpu_wr_en_n;

    wire    [7 : 0] sig_out;
    wire    [5 : 0] hour_hex, minute_hex;

    // address latch
    always @ (abus or dbus or ale or cs_n) begin
        if (ale && ~cs_n) begin
            addr <= {abus, dbus};
        end
    end

    // generate write enable by sample w_n
    always @ (posedge clk) begin
        w_n_prev <= w_n;
    end

    always @ (posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            cpu_wr_en_n <= 1'b1;
        end
        else begin
            cpu_wr_en_n <= !(w_n && !w_n_prev && !cs_n);
        end
    end

    // filter
    filter filter_inst (
        .clock  (clk      ),
        .rst_n  (rst_n      ),
        .w_en_n (cpu_wr_en_n),
        .p      (dbus       ),
        .addr   (addr       ),
        .x_valid_n(pe_n       ),
        .x      (sig_in     ),
        .y      (sig_out    )
    );

    // filter amplify conversion
    sqrt_amp sqrt_amp_inst (
        .clock  (clk  ),
        .rst_n  (rst_n  ),
        .data   (sig_out),
        .ap     (ap     )
    );

    // timer
    timer timer_inst (
        .clock  (clk      ),
        .rst_n  (rst_n      ),
        .w_en_n (cpu_wr_en_n),
        .t      (dbus       ),
        .addr   (addr       ),
        .hour   (hour_hex   ),
        .minute (minute_hex )
    );

    // encode hex to bcd and then to digital tube signals
    hex2decdigi_8bit sig_out_encoder (
        .clock  (clk  ),
        .rst_n  (rst_n  ),
        .hex    (sig_out),
        .digi_0 (sig_digi0),
        .digi_1 (sig_digi1),
        .digi_2 (sig_digi2)
    );

    hex2decdigi_6bit hour_encoder (
        .clock  (clk  ),
        .rst_n  (rst_n  ),
        .hex    (hour_hex  ),
        .digi_0 (hour_digi0),
        .digi_1 (hour_digi1)
    );

    hex2decdigi_6bit minute_encoder (
        .clock  (clk  ),
        .rst_n  (rst_n  ),
        .hex    (minute_hex  ),
        .digi_0 (minute_digi0),
        .digi_1 (minute_digi1)
    );

endmodule
