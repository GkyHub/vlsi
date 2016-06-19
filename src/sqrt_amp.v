module sqrt_amp (
    input   clock,
    input   rst_n,

    input   [7 : 0] data,
    output  reg [15: 0] ap
    );

    localparam [8*16-1 : 0] thresh = {
        8'd1, 8'd3, 8'd7, 8'd13, 8'd21, 8'd31, 8'd43, 8'd57,
        8'd75, 8'd91, 8'd111, 8'd133, 8'd157, 8'd183, 8'd201, 8'd241
    };

    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin
            always @ (posedge clock or negedge rst_n) begin
                if (~rst_n) begin
                    ap[15-i] <= 1'b0;
                end
                else begin
                    ap[15-i] <= data > thresh[(i+1)*8-1 -: 8];
                end
            end
        end
    endgenerate

endmodule
