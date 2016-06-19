module filter(
    input   clock,
    input   rst_n,

    // filter configuration port
    input   w_en_n,         // cpu write enable
    input   [7 : 0] p,
    input   [15: 0] addr,

    // signal input
    input   x_valid_n,
    input   [7 : 0] x,

    // signal output
    output  reg [7 : 0] y
    );

    reg [8*8-1 : 0] param;  // filter parameter
                            // first 7 byte as b
                            // the last byte is mask
    reg [7*8-1 : 0] x_arr;  // input signal

    // filter configuration
    always @ (posedge clock or negedge rst_n) begin
        if (~rst_n) begin
            param <= 64'd0;
        end
        else if (~w_en_n) begin
            case(addr[3 : 0])
            4'b0000: param[7 : 0] <= p;
            4'b0001: param[15: 8] <= p;
            4'b0010: param[23:16] <= p;
            4'b0011: param[31:24] <= p;
            4'b0100: param[39:32] <= p;
            4'b0101: param[47:40] <= p;
            4'b0110: param[55:48] <= p;
            4'b0111: param[63:56] <= p;
            endcase
        end
    end

    // input signal as time series
    always @ (posedge clock or negedge rst_n) begin
        if (~rst_n) begin
            x_arr <= 56'd0;
        end
        else if (~x_valid_n) begin
            x_arr <= {x_arr[47: 0], (x & param[63:56])};
        end
    end

    // calculation using state FSM
    localparam [5 : 0] STATE_0  = 6'b000001;
    localparam [5 : 0] STATE_1  = 6'b000110;
    localparam [5 : 0] STATE_2  = 6'b001011;
    localparam [5 : 0] STATE_3  = 6'b001111;
    localparam [5 : 0] STATE_4  = 6'b010011;
    localparam [5 : 0] STATE_5  = 6'b010111;
    localparam [5 : 0] STATE_6  = 6'b011011;
    localparam [5 : 0] STATE_7  = 6'b111011;

    reg [5 : 0] state;
    reg [7 : 0] r1, r2;

    wire [7 : 0] add_res, mult_res;
    reg  [7 : 0] mux1, mux2, mux3;

    // state transfer
    always @ (posedge clock or negedge rst_n) begin
        if (~rst_n) begin
            state <= STATE_0;
        end
        else if (~x_valid_n) begin
            state <= STATE_0;
        end
        else begin
            case (state)
            STATE_0: state <= STATE_1;
            STATE_1: state <= STATE_2;
            STATE_2: state <= STATE_3;
            STATE_3: state <= STATE_4;
            STATE_4: state <= STATE_5;
            STATE_5: state <= STATE_6;
            STATE_6: state <= STATE_7;
            STATE_7: state <= state;
            endcase
        end
    end

    // data mux
    always @ (*) begin
        case (state[4:2])
        3'b000: mux1 = x_arr[7 : 0];
        3'b001: mux1 = x_arr[15: 8];
        3'b010: mux1 = x_arr[23:16];
        3'b011: mux1 = x_arr[31:24];
        3'b100: mux1 = x_arr[39:32];
        3'b101: mux1 = x_arr[47:40];
        3'b110: mux1 = x_arr[55:48];
        endcase
    end

    always @ (*) begin
        case (state[4:2])
        3'b000: mux2 = param[7 : 0];
        3'b001: mux2 = param[15: 8];
        3'b010: mux2 = param[23:16];
        3'b011: mux2 = param[31:24];
        3'b100: mux2 = param[39:32];
        3'b101: mux2 = param[47:40];
        3'b110: mux2 = param[55:48];
        endcase
    end

    always @ (*) begin
        mux3 = state[1] ? add_res : mult_res;
    end

    // calculation logic
    assign add_res  = r1 + r2;
    assign mult_res = mux1 * mux2;

    // register write
    always @ (posedge clock or negedge rst_n) begin
        if (~rst_n) begin
            r1 <= 8'd0;
        end
        else if (state[0]) begin
            r1 <= mux3;
        end
    end

    always @ (posedge clock or negedge rst_n) begin
        if (~rst_n) begin
            r2 <= 8'd0;
        end
        else if (state[1]) begin
            r2 <= mult_res;
        end
    end

    // output
    reg res_valid;

    always @ (posedge clock or negedge rst_n) begin
        if (~rst_n) begin
            res_valid <= 1'b0;
        end
        else if (state == STATE_6) begin
            res_valid <= 1'b1;
        end
        else begin
            res_valid <= 1'b0;
        end
    end

    // result should be assigned only the first cycle the state
    // machine enters STATE_7
    always @ (posedge clock or negedge rst_n) begin
        if (~rst_n) begin
            y <= 8'd0;
        end
        else if (state == STATE_7 && res_valid) begin
            y <= r1;
        end
    end

endmodule
