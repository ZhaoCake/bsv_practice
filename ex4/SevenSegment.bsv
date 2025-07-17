package ex4;

interface SevenSegmentIfc;
    method Bit#(7) seg7_get( Bit#(4) value);  // 获取七段显示器的值
endinterface

(* synthesize *)
module mkSevenSegment (SevenSegmentIfc);

    Wire#(Bit#(7)) seg <- mkWire;  // 七段显示器的输出信号

    method Bit#(7) seg7_get(Bit#(4) value);

        case (value) 
            4'b0000: return 7'b0000001;  // 显示0
            4'b0001: return 7'b1001111;  // 显示1
            4'b0010: return 7'b0010010;  // 显示2
            4'b0011: return 7'b0000110;  // 显示3
            4'b0100: return 7'b1001100;  // 显示4
            4'b0101: return 7'b0100100;  // 显示5
            4'b0110: return 7'b0100000;  // 显示6
            4'b0111: return 7'b0001111;  // 显示7
            4'b1000: return 7'b0000000;  // 显示8
            4'b1001: return 7'b0000100;  // 显示9
            default: return 7'b1111111;   // 默认错误状态
        endcase
    endmethod

endmodule

interface DoubleSevenSegmentIfc;
    method Bit#(14) double_seg_get ( Bit#(8) double_value );
endinterface

(* synthesize *)
module mkDoubleSevenSegment (DoubleSevenSegmentIfc);
    SevenSegmentIfc seg1 <- mkSevenSegment();
    SevenSegmentIfc seg2 <- mkSevenSegment();

    method Bit#(14) double_seg_get(Bit#(8) double_value);
        Bit#(7) seg1_value = seg1.seg7_get(double_value[3:0]);  // 获取低4位的七段显示值
        Bit#(7) seg2_value = seg2.seg7_get(double_value[7:4]);  // 获取高4位的七段显示值
        return {seg2_value, seg1_value};  // 返回14位的组合
    endmethod
endmodule


// 测试模块
module mkTbDoubleSevenSegment();
    DoubleSevenSegmentIfc seg <- mkDoubleSevenSegment();
    Reg#(Bit#(8)) cnt <- mkReg(0);
    Reg#(Bit#(8)) cycle <- mkReg(0);

    rule test_display;
        let out = seg.double_seg_get(cnt);
        $display("Cycle: %0d, Input: %0d, Output: %014b", cycle, cnt, out);
        cnt <= cnt + 1;
        cycle <= cycle + 1;
        if (cycle == 20) begin
            $finish;
        end
    endrule

endmodule

endpackage