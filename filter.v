module filter(
    input   clock,
    input   rst_n,
    
    // filter configuration port
    input   b_valid,
    input   [7 : 0] b,
    input   [2 : 0] addr,
    
    // signal input
    input   x_valid,
    input   [7 : 0] x,
    
    // signal output
    output  y_valid,
    output  [15: 0] y
    );
    
    // filter parameter
    reg [7 : 0] b0;
    reg [7 : 0] b1;
    reg [7 : 0] b2;
    reg [7 : 0] b3;
    reg [7 : 0] b4;
    reg [7 : 0] b5;
    reg [7 : 0] b6;
    
    // filter configuration
    always @ (posedge clock or negedge rst_n) begin
        if (~rst_n) begin
            b0 <= 8'h00;
            b1 <= 8'h00;
            b2 <= 8'h00;
            b3 <= 8'h00;
            b4 <= 8'h00;
            b5 <= 8'h00;
            b6 <= 8'h00;
        end
        else if (b_valid) begin
            case(addr)
            3'b000: b0 <= b;
            3'b001: b1 <= b;
            3'b010: b2 <= b;
            3'b011: b3 <= b;
            3'b100: b4 <= b;
            3'b101: b5 <= b;
            3'b110: b6 <= b;
            endcase
        end   
    end
    
    // filter
    
endmodule