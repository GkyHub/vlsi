module timer(
    input   clock,
    input   rst_n,

    // time configuration port
    input   w_n,            // posedge triggers write
    input   w_en_n,         // cpu write enable
    input   [7 : 0] t,
    input   [15: 0] addr,

    // time output
    output  reg [7 : 0] hour,
    output  reg [7 : 0] minute
    );

    localparam CLK_FREQ = 10000000; // 10MHz clock

    reg w_prev;
    reg [31: 0] counter;

    // sample w_n by clock to capture the posedge of w_n
    always @ (posedge clock) begin
        w_prev <= w_n;
    end

    // local counter
    // cycle is 1 minute
    always @ (posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            counter <= 32'd0;
        end
        else if (counter == CLK_FREQ * 60 - 1) begin
            counter <= 32'd0;
        end
        else begin
            counter <= counter + 32'd1;
        end
    end

    // hour and minute counter
    always @ (posedge clock or negedge rst_n) begin
        if (~rst_n) begin
            hour    <= 8'd0;
            minute  <= 8'd0;
        end
        else if (~w_prev && w_n) begin  // cpu configuration
            if (addr[0]) begin
                hour    <= t;
                minute  <= minute;
            end
            else begin
                hour    <= hour;
                minute  <= t;
            end
        end
        else if (counter == CLK_FREQ * 60 - 1) begin    // minute trigger
            if (minute == 8'd59) begin
                hour    <= hour + 8'd1;
                minute  <= 8'd0;
            end
            else begin
                hour    <= hour;
                minute  <= minute + 8'd1;
            end
        end
    end

endmodule
