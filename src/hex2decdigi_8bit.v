module hex2decdigi_8bit(
    input   clock,
    input   rst_n,

    input   [7 : 0] hex,
    output  reg [6 : 0] digi_0,
    output  reg [6 : 0] digi_1,
    output  reg [6 : 0] digi_2
    );

    localparam DIGI_0 = 7'b0111111;
    localparam DIGI_1 = 7'b0011000;
    localparam DIGI_2 = 7'b1110110;
    localparam DIGI_3 = 7'b1111100;
    localparam DIGI_4 = 7'b1011001;
    localparam DIGI_5 = 7'b1101101;
    localparam DIGI_6 = 7'b1101111;
    localparam DIGI_7 = 7'b0111000;
    localparam DIGI_8 = 7'b1111111;
    localparam DIGI_9 = 7'b1111101;
    localparam DIGI_X = 7'b0000000;

    reg [6 : 0] res_2;
    reg [3 : 0] res_1;

    // delay to synchronize the result
    reg [6 : 0] digi_2_d1, digi_2_d2, digi_1_d1;

    // get digi_2
    always @ (posedge clock or negedge rst_n) begin
        if (~rst_n) begin
            digi_2_d1 <= DIGI_X;
            res_2  <= 7'd0;
        end
        else begin
            if (hex >= 8'd200) begin
                digi_2_d1 <= DIGI_2;
                res_2  <= hex - 8'd200;
            end
            else if (hex >= 8'd100) begin
                digi_2_d1 <= DIGI_1;
                res_2  <= hex - 8'd100;
            end
            else begin
                digi_2_d1 <= DIGI_0;
                res_2  <= hex;
            end
        end
    end

    // get digi_1
    always @ (posedge clock or negedge rst_n) begin
        if (~rst_n) begin
            digi_1_d1 <= DIGI_X;
            res_1  <= 4'd0;
        end
        else begin
            if (res_2 >= 7'd90) begin
                digi_1_d1 <= DIGI_9;
                res_1  <= res_2 - 7'd90;
            end
            else if (res_2 >= 7'd80) begin
                digi_1_d1 <= DIGI_8;
                res_1  <= res_2 - 7'd80;
            end
            else if (res_2 >= 7'd70) begin
                digi_1_d1 <= DIGI_7;
                res_1  <= res_2 - 7'd70;
            end
            else if (res_2 >= 7'd60) begin
                digi_1_d1 <= DIGI_6;
                res_1  <= res_2 - 7'd60;
            end
            else if (res_2 >= 7'd50) begin
                digi_1_d1 <= DIGI_5;
                res_1  <= res_2 - 7'd50;
            end
            else if (res_2 >= 7'd40) begin
                digi_1_d1 <= DIGI_4;
                res_1  <= res_2 - 7'd40;
            end
            else if (res_2 >= 7'd30) begin
                digi_1_d1 <= DIGI_3;
                res_1  <= res_2 - 7'd30;
            end
            else if (res_2 >= 7'd20) begin
                digi_1_d1 <= DIGI_2;
                res_1  <= res_2 - 7'd20;
            end
            else if (res_2 >= 7'd10) begin
                digi_1_d1 <= DIGI_1;
                res_1  <= res_2 - 7'd10;
            end
            else begin
                digi_1_d1 <= DIGI_0;
                res_1  <= res_2[3 : 0];
            end
        end
    end

    // get digi_0
    always @ (posedge clock or negedge rst_n) begin
        if (~rst_n) begin
            digi_0 <= DIGI_X;
        end
        else begin
            case (res_1)
            4'd0: digi_0 <= DIGI_0;
            4'd1: digi_0 <= DIGI_1;
            4'd2: digi_0 <= DIGI_2;
            4'd3: digi_0 <= DIGI_3;
            4'd4: digi_0 <= DIGI_4;
            4'd5: digi_0 <= DIGI_5;
            4'd6: digi_0 <= DIGI_6;
            4'd7: digi_0 <= DIGI_7;
            4'd8: digi_0 <= DIGI_8;
            4'd9: digi_0 <= DIGI_9;
            default:
                digi_0 <= DIGI_X;
            endcase
        end
    end

    // delay
    always @ (posedge clock) begin
        digi_2_d2 <= digi_2_d1;
        digi_2    <= digi_2_d2;
        digi_1    <= digi_1_d1;
    end

endmodule
