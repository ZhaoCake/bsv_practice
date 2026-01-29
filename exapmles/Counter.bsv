package Counter;

// Example: Simple up-counter

interface CounterIfc;
    method Action inc();
    method Bit#(4) out();
endinterface

(* synthesize *)
module mkCounter(CounterIfc);

    Reg#(Bit#(4)) r <- mkReg(0);

    method Action inc();
        r <= r + 1;
    endmethod

    method Bit#(4) out();
        return r;
    endmethod

endmodule

endpackage