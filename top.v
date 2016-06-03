module TH99CHLS (
    input   clock,
    input   rst_n,
    
    input   cs_n,           // instruction valid
    input   [7 : 0] abus,   // address bus
    input   ale,            // negedge triggers address latch
    input   r_n,            // posedge triggers cpu read
    input   w_n,            // posedge triggers logic read
    inout   [7 : 0] dbus,   // data bus
    
    output  [65: 0] display
    );
    
    reg     [15: 0] addr;
    
    
    
    
endmodule