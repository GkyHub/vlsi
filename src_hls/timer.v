module timer(
    input   clock,
    input   rst_n,

    // time configuration port
    input   w_en_n,         // cpu write enable
    input   [7 : 0] t,
    input   [15: 0] addr,

    // time output
    output  reg [5 : 0] hour,
    output  reg [5 : 0] minute
    );

    // localparam CLK_FREQ = 10000000; // 10MHz clock
    localparam CLK_FREQ = 1; // 1Hz clock for simulation

    reg [31: 0] counter;

    // local counter
    // cycle is 1 minute
    always @ (posedge clock or negedge rst_n) begin
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
            hour    <= 6'd0;
            minute  <= 6'd0;
        end
        else if (~w_en_n) begin  // cpu configuration
            if (addr[3 : 0] == 4'b1000) begin
                hour    <= t;
                minute  <= minute;
            end
            else if (addr[3 : 0] == 4'b1001) begin
                hour    <= hour;
                minute  <= t;
            end
            else begin
                hour    <= hour;
                minute  <= minute;
            end
        end
        else if (counter == CLK_FREQ * 60 - 1) begin    // minute trigger
            if (minute == 6'd59) begin
                if (hour == 6'd23) begin
                    hour <= 6'd0;
                end
                else begin
                    hour    <= hour + 6'd1;
                end
                minute  <= 6'd0;
            end
            else begin
                hour    <= hour;
                minute  <= minute + 8'd1;
            end
        end
    end

endmodule
