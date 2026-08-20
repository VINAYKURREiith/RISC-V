module pc_mux (

    input  wire [63:0] pc_plus4,
    input  wire [63:0] branch_target,
    input  wire        BranchTaken,

    output wire [63:0] pc_next

);

assign pc_next = (BranchTaken) ? branch_target : pc_plus4;

endmodule