module hex2bcd2digi(
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

    reg [7 : 0] res_2, res_1;

    // get bcd_2
    always @ (posedge clock or negedge rst_n) begin
        if (~rst_n) begin
            bcd_2 <= DIGI_X;
            res_2 <= 8'd0;
        end
        else begin
            if (hex > 8'd200) begin
                bcd_2 <= DIGI_2;
                res_2 <= hex - 8'd200;
            end
            else if (hex > 8'd100) begin
                bcd_2 <= DIGI_1;
                res_2 <= hex - 8'd100;
            end
            else begin
                bcd_2 <= DIGI_0;
                res_2 <= hex;
            end
        end
    end

    // get bcd_1
    always @ (posedge clock or negedge rst_n) begin
        if (~rst_n) begin
            bcd_1 <= DIGI_X;
            res_1 <= 8'd0;
        end
        else begin
            if (res_2 > 8'd90) begin
                bcd_1 <= DIGI_9;
                bcd_0 <= res_2 - 8'd90;
            end
            else if (res_2 > 8'd80) begin
                bcd_1 <= DIGI_8;
                bcd_0 <= res_2 - 8'd80;
            end
            else if (res_2 > 8'd70) begin
                bcd_1 <= DIGI_7;
                bcd_0 <= res_2 - 8'd70;
            end
            else if (res_2 > 8'd60) begin
                bcd_1 <= DIGI_6;
                bcd_0 <= res_2 - 8'd60;
            end
            else if (res_2 > 8'd50) begin
                bcd_1 <= DIGI_5;
                bcd_0 <= res_2 - 8'd50;
            end
            else if (res_2 > 8'd40) begin
                bcd_1 <= DIGI_4;
                bcd_0 <= res_2 - 8'd40;
            end
            else if (res_2 > 8'd30) begin
                bcd_1 <= DIGI_3;
                bcd_0 <= res_2 - 8'd30;
            end
            else if (res_2 > 8'd20) begin
                bcd_1 <= DIGI_2;
                bcd_0 <= res_2 - 8'd20;
            end
            else if (res_2 > 8'd10) begin
                bcd_1 <= DIGI_1;
                bcd_0 <= res_2 - 8'd10;
            end
            else begin
                bcd_1 <= DIGI_0;
                bcd_0 <= res_2;
            end
        end
    end

endmodule
