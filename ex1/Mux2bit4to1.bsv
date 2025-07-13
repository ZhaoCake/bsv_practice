package Mux2bit4to1;


interface Mux2bit4to1;
    method Bit#(2) mux_select (Bit#(2) sel, Bit#(2) a, Bit#(2) b, Bit#(2) c, Bit#(2) d);
endinterface

(* synthesize *)
module mkMux2bit4to1 (Mux2bit4to1);
    
    method Bit#(2) mux_select (Bit#(2) sel, Bit#(2) a, Bit#(2) b, Bit#(2) c, Bit#(2) d);
        case (sel)
            2'b00: return a;
            2'b01: return b;
            2'b10: return c;
            2'b11: return d;
            default: return 2'b00; // 默认值
        endcase
    endmethod
    
endmodule

module mkTb ();

    Mux2bit4to1 mux <- mkMux2bit4to1();
    Reg#(Bit#(3)) test_counter <- mkReg(0);

    rule test_sel_00 (test_counter == 0);
        Bit#(2) result = mux.mux_select(2'b00, 2'b01, 2'b10, 2'b11, 2'b00);
        $display("Test %d: sel=00, output=%b (expected: 01)", test_counter, result);
        test_counter <= test_counter + 1;
    endrule

    rule test_sel_01 (test_counter == 1);
        Bit#(2) result = mux.mux_select(2'b01, 2'b01, 2'b10, 2'b11, 2'b00);
        $display("Test %d: sel=01, output=%b (expected: 10)", test_counter, result);
        test_counter <= test_counter + 1;
    endrule

    rule test_sel_10 (test_counter == 2);
        Bit#(2) result = mux.mux_select(2'b10, 2'b01, 2'b10, 2'b11, 2'b00);
        $display("Test %d: sel=10, output=%b (expected: 11)", test_counter, result);
        test_counter <= test_counter + 1;
    endrule

    rule test_sel_11 (test_counter == 3);
        Bit#(2) result = mux.mux_select(2'b11, 2'b01, 2'b10, 2'b11, 2'b00);
        $display("Test %d: sel=11, output=%b (expected: 00)", test_counter, result);
        test_counter <= test_counter + 1;
    endrule

    rule finish_test (test_counter == 4);
        $display("All tests completed!");
        $finish;
    endrule

endmodule

endpackage 

