package Prior8to3encoder;

interface Prior8to3encoder;
    method Bit#(3) prior_encode (Bit#(8) input_data);
endinterface

(* synthesize *)
module mkPrior8to3encoder (Prior8to3encoder);
    method Bit#(3) prior_encode (Bit#(8) input_data);
        // 使用优先编码逻辑，使用unpack将Bit#(1)转换为Bool
        if (unpack(input_data[7])) return 3'b111;
        else if (unpack(input_data[6])) return 3'b110;
        else if (unpack(input_data[5])) return 3'b101;
        else if (unpack(input_data[4])) return 3'b100;
        else if (unpack(input_data[3])) return 3'b011;
        else if (unpack(input_data[2])) return 3'b010;
        else if (unpack(input_data[1])) return 3'b001;
        else if (unpack(input_data[0])) return 3'b000;
        else return 3'b000; // 默认值
    endmethod
endmodule

module mkTb ();

    Prior8to3encoder encoder <- mkPrior8to3encoder();
    Reg#(Bit#(3)) test_counter <- mkReg(0);

    rule test_encode_00000001 (test_counter == 0);
        Bit#(3) result = encoder.prior_encode(8'b00000001);
        $display("Test %d: input=00000001, output=%b (expected: 000)", test_counter, result);
        test_counter <= test_counter + 1;
    endrule

    rule test_encode_00000010 (test_counter == 1);
        Bit#(3) result = encoder.prior_encode(8'b00000010);
        $display("Test %d: input=00000010, output=%b (expected: 001)", test_counter, result);
        test_counter <= test_counter + 1;
    endrule

    rule test_encode_00000100 (test_counter == 2);
        Bit#(3) result = encoder.prior_encode(8'b00000100);
        $display("Test %d: input=00000100, output=%b (expected: 010)", test_counter, result);
        test_counter <= test_counter + 1;
    endrule

    rule test_encode_10000000 (test_counter == 3);
        Bit#(3) result = encoder.prior_encode(8'b10000000);
        $display("Test %d: input=10000000, output=%b (expected: 111)", test_counter, result);
        test_counter <= test_counter + 1;
    endrule

    rule test_encode_11111111 (test_counter == 4);
        Bit#(3) result = encoder.prior_encode(8'b11111111);
        $display("Test %d: input=11111111, output=%b (expected: 111)", test_counter, result);
        test_counter <= test_counter + 1;
    endrule

    rule finish_test (test_counter == 5);
        $display("All tests completed!");
        $finish;
    endrule

endmodule

endpackage