module filter(
    input   clock,
    input   rst_n,

    // filter configuration port
    input   w_n,            // posedge triggers write
    input   w_en_n,         // cpu write enable
    input   [7 : 0] p,
    input   [15: 0] addr,

    // signal input
    input   x_valid,
    input   [7 : 0] x,

    // signal output
    output  reg [15: 0] y
    );

    reg [8*8-1 : 0] param;  // filter parameter
                            // first 7 byte as b
                            // the last byte is mask
    reg [7*8-1 : 0] x_arr;  // input signal

    // filter configuration
    always @ (posedge w_n or negedge rst_n) begin
        if (~rst_n) begin
            param <= 64'd0;
        end
        else if (~cs_n) begin
            case(addr[2 : 0])
            3'b000: param[7 : 0] <= p;
            3'b001: param[15: 8] <= p;
            3'b010: param[23:16] <= p;
            3'b011: param[31:24] <= p;
            3'b100: param[39:32] <= p;
            3'b101: param[47:40] <= p;
            3'b110: param[55:48] <= p;
            3'b111: param[63:56] <= p;
            endcase
        end
    end

    // input signal as time series
    always @ (posedge clock or negedge rst_n) begin
        if (~rst_n) begin
            x_arr <= 56'd0;
        end
        else if (x_valid) begin
            x_arr <= {x_arr[47: 0], (x & param[63:56])};
        end
    end

    // calculation
    always @ (posedge clock or negedge rst_n) begin
        if (~rst_n) begin
            y <= 16'd0;
        end
        else begin
            y <= x_arr[7 : 0] * param[7 : 0] +
                 x_arr[15: 8] * param[15: 8] +
                 x_arr[23:16] * param[23:16] +
                 x_arr[31:24] * param[31:24] +
                 x_arr[39:32] * param[39:32] +
                 x_arr[47:40] * param[47:40] +
                 x_arr[55:48] * param[55:48];
        end
    end

endmodule
