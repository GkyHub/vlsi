module disp_encoder(
    input   clock,
    input   rst_n,

    input   [3 : 0] bcd,
    output  reg [6 : 0] digi
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

    always @ (posedge clock or negedge rst_n) begin
        if (~rst_n) begin
            digi <= DIGI_X;
        end
        else begin
            case(bcd)
            4'd0: digi <= DIGI_0;
            4'd1: digi <= DIGI_1;
            4'd2: digi <= DIGI_2;
            4'd3: digi <= DIGI_3;
            4'd4: digi <= DIGI_4;
            4'd5: digi <= DIGI_5;
            4'd6: digi <= DIGI_6;
            4'd7: digi <= DIGI_7;
            4'd8: digi <= DIGI_8;
            4'd9: digi <= DIGI_9;
            default: digi <= DIGI_X
            end
        end
    end

endmodule
