module hex2bcd(
    input   clock,
    input   rst_n,

    input   [7 : 0] hex,
    output  reg [3 : 0] bcd_0,
    output  reg [3 : 0] bcd_1,
    output  reg [3 : 0] bcd_2
    );

    reg [7 : 0] res_2;

    // get bcd_2
    always @ (posedge clock or negedge rst_n) begin
        if (~rst_n) begin
            bcd_2 <= 4'd0;
        end
        else begin
            if (hex > 8'd200) begin
                bcd_2 <= 4'd2;
                res_2 <= hex - 8'd200;
            end
            else if (hex > 8'd100) begin
                bcd_2 <= 4'd1;
                res_2 <= hex - 8'd100;
            end
            else begin
                bcd_2 <= 4'd0;
                res_2 <= hex;
            end
        end
    end

    // get bcd_1 and bcd_0
    always @ (posedge clock or negedge rst_n) begin
        if (~rst_n) begin
            bcd_1 <= 4'd0;
        end
        else begin
            if (res_2 > 8'd90) begin
                bcd_1 <= 4'd9;
                bcd_0 <= res_2 - 8'd90;
            end
            else if (res_2 > 8'd80) begin
                bcd_1 <= 4'd8;
                bcd_0 <= res_2 - 8'd80;
            end
            else if (res_2 > 8'd70) begin
                bcd_1 <= 4'd7;
                bcd_0 <= res_2 - 8'd70;
            end
            else if (res_2 > 8'd60) begin
                bcd_1 <= 4'd6;
                bcd_0 <= res_2 - 8'd60;
            end
            else if (res_2 > 8'd50) begin
                bcd_1 <= 4'd5;
                bcd_0 <= res_2 - 8'd50;
            end
            else if (res_2 > 8'd40) begin
                bcd_1 <= 4'd4;
                bcd_0 <= res_2 - 8'd40;
            end
            else if (res_2 > 8'd30) begin
                bcd_1 <= 4'd3;
                bcd_0 <= res_2 - 8'd30;
            end
            else if (res_2 > 8'd20) begin
                bcd_1 <= 4'd2;
                bcd_0 <= res_2 - 8'd20;
            end
            else if (res_2 > 8'd10) begin
                bcd_1 <= 4'd1;
                bcd_0 <= res_2 - 8'd10;
            end
            else begin
                bcd_1 <= 4'd0;
                bcd_0 <= res_2;
            end
        end
    end

endmodule
