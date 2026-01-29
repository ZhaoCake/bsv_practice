package Zero;

import StmtFSM::*;

// HDLBits: Zero
// Build a module that outputs a constant 0.
// We simulate this by checking the output in a rule.

(* synthesize *)
module mkZero(Empty);

    // In a real synthesis flow for Verilog output, the signature would match the problem.
    // For local Bluesim simulation, we usually wrap the DUT or test logic in a mkModule(Empty).
    
    // Logic equivalent to assign zero = 1'b0;
    Reg#(Bit#(1)) zero <- mkReg(0);

    rule run_test;
        $display("Zero is: %b", zero);
        if (zero == 0) $display("PASS");
        else $display("FAIL");
        $finish(0);
    endrule

endmodule

endpackage
