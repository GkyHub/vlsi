`timescale 1ns/1ps
module test;
    reg clock, rst_n;
    reg cs_n, ale, r_n, w_n;
    reg [7 : 0] abus, dbus;

    reg pe_n;
    reg [7 : 0] sig_in;

    wire [6 : 0] sig_digi2;
    wire [6 : 0] sig_digi1;
    wire [6 : 0] sig_digi0;

    wire [6 : 0] hour_digi1;
    wire [6 : 0] hour_digi0;
    wire [6 : 0] minute_digi1;
    wire [6 : 0] minute_digi0;
    wire [15: 0] ap;


    // generate clock and reset signal
    always #5 clock <= ~clock;
    initial begin
        clock <= 1'b1;
        rst_n <= 1'b0;
        #100
        rst_n <= 1'b1;
    end

    TH99CHLS th99chls_inst(
        .clk    (clock  ),
        .rst_n  (rst_n  ),

        // 8051 control port
        .cs_n   (cs_n   ),  // chip selection
        .abus   (abus   ),  // address bus
        .ale    (ale    ),  // negedge triggers address latch
        .r_n    (r_n    ),  // posedge triggers cpu read
        .w_n    (w_n    ),  // posedge triggers logic read
        .dbus   (dbus   ),  // data bus

        // data input port
        .pe_n   (pe_n   ),  // input valid
        .sig_in (sig_in ),  // input signal

        // data output port
        .sig_digi2  (sig_digi2 ),
        .sig_digi1  (sig_digi1 ),
        .sig_digi0  (sig_digi0 ),
        .hour_digi1 (hour_digi1),
        .hour_digi0 (hour_digi0),
        .minute_digi1(minute_digi1),
        .minute_digi0(minute_digi0),
        .ap(ap)
    );

    initial begin
        // reset signals
        cs_n <= 1'b1;
        ale  <= 1'b0;
        r_n  <= 1'b1;
        w_n  <= 1'b1;
        pe_n <= 1'b1;

        #200
        // configure time: 10:30
        CPU_WRITE(8'd10, 16'd8);    // hour
        CPU_WRITE(8'd30, 16'd9);    // minute

        // configure filter parameter
        CPU_WRITE(8'd1,  16'd0);
        CPU_WRITE(8'd2,  16'd1);
        CPU_WRITE(8'd3,  16'd2);
        CPU_WRITE(8'd0,  16'd3);
        CPU_WRITE(8'd1,  16'd4);
        CPU_WRITE(8'd2,  16'd5);
        CPU_WRITE(8'd3,  16'd6);

        // configure filter mask
        CPU_WRITE(8'b00001111, 16'd7);

        // input signal
        @(posedge clock) sig_in  <= 8'd65; pe_n <= 1'b0;
        @(posedge clock) pe_n    <= 1'b1; #100;
        @(posedge clock) sig_in  <= 8'd66; pe_n <= 1'b0;
        @(posedge clock) pe_n    <= 1'b1; #100;
        @(posedge clock) sig_in  <= 8'd67; pe_n <= 1'b0;
        @(posedge clock) pe_n    <= 1'b1; #100;
        @(posedge clock) sig_in  <= 8'd68; pe_n <= 1'b0;
        @(posedge clock) pe_n    <= 1'b1; #100;
        @(posedge clock) sig_in  <= 8'd69; pe_n <= 1'b0;
        @(posedge clock) pe_n    <= 1'b1; #100;
        @(posedge clock) sig_in  <= 8'd70; pe_n <= 1'b0;
        @(posedge clock) pe_n    <= 1'b1; #100;
        @(posedge clock) sig_in  <= 8'd71; pe_n <= 1'b0;
        @(posedge clock) pe_n    <= 1'b1; #100;
        @(posedge clock) sig_in  <= 8'd72; pe_n <= 1'b0;
        @(posedge clock) pe_n    <= 1'b1; #100;
        @(posedge clock) sig_in  <= 8'd73; pe_n <= 1'b0;
        @(posedge clock) pe_n    <= 1'b1; #100;
        @(posedge clock) sig_in  <= 8'd74; pe_n <= 1'b0;
        @(posedge clock) pe_n    <= 1'b1; #100;
        @(posedge clock) sig_in  <= 8'd75; pe_n <= 1'b0;
        @(posedge clock) pe_n    <= 1'b1; #100;
        @(posedge clock) sig_in  <= 8'd76; pe_n <= 1'b0;
        @(posedge clock) pe_n    <= 1'b1; #100;
        @(posedge clock) sig_in  <= 8'd77; pe_n <= 1'b0;
        @(posedge clock) pe_n    <= 1'b1; #100;
        @(posedge clock) sig_in  <= 8'd78; pe_n <= 1'b0;
        @(posedge clock) pe_n    <= 1'b1; #100;
        @(posedge clock) sig_in  <= 8'd79; pe_n <= 1'b0;
        @(posedge clock) pe_n    <= 1'b1; #100;
    end

    task CPU_WRITE;
        input [7 : 0] data;
        input [15: 0] addr;
        begin
            // send the address
            @(posedge clock)
            cs_n    <= 1'b0;
            ale     <= 1'b1;
            abus    <= addr[15: 8];
            dbus    <= addr[7 : 0];
            @(posedge clock);
            ale     <= 1'b0;
            // send the data
            @(posedge clock);
            w_n     <= 1'b0;
            dbus    <= data;
            @(posedge clock);
            w_n     <= 1'b1;
            // reset chip selection
            @(posedge clock);
            cs_n    <= 1'b1;
        end
    endtask

endmodule
