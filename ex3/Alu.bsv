package Alu;

// ALU结果结构体，包含结果值和状态标志
typedef struct {
    Bit#(4) result;     // 4位结果
    Bool zero;          // 零标志
    Bool overflow;      // 溢出标志  
    Bool carry;         // 进位标志
} AluResult deriving (Bits, Eq);

// ALU接口定义
interface Alu;
    // 单一方法接口 - 根据操作码执行相应运算
    method AluResult alu_op (Bit#(3) op_code, Bit#(4) a, Bit#(4) b);
    
    // 多方法接口 - 每个功能单独一个方法
    method Bit#(4) add_op (Bit#(4) a, Bit#(4) b);
    method Bit#(4) sub_op (Bit#(4) a, Bit#(4) b);
    method Bit#(4) not_op (Bit#(4) a);
    method Bit#(4) and_op (Bit#(4) a, Bit#(4) b);
    method Bit#(4) or_op (Bit#(4) a, Bit#(4) b);
    method Bit#(4) xor_op (Bit#(4) a, Bit#(4) b);
    method Bit#(1) less_than (Bit#(4) a, Bit#(4) b);
    method Bit#(1) equal (Bit#(4) a, Bit#(4) b);
    
    // 状态查询方法
    method Bool check_overflow (Bit#(4) a, Bit#(4) b, Bit#(4) result, Bool is_sub);
    method Bool check_zero (Bit#(4) result);
endinterface

(* synthesize *)
module mkAlu (Alu);
    
    // 主要的ALU操作方法
    method AluResult alu_op (Bit#(3) op_code, Bit#(4) a, Bit#(4) b);
        Bit#(5) temp_result = 0;  // 5位临时结果用于检测进位，初始化
        Bit#(4) result = 0;
        Bool zero_flag = False;
        Bool overflow_flag = False;
        Bool carry_flag = False;
        
        // 辅助函数：检查溢出
        function Bool check_overflow_func (Bit#(4) op_a, Bit#(4) op_b, Bit#(4) op_result, Bool is_sub);
            Bit#(1) sign_a = op_a[3];
            Bit#(1) sign_b = is_sub ? ~op_b[3] : op_b[3];  // 减法时B取反
            Bit#(1) sign_result = op_result[3];
            
            // 溢出条件：两个同号数相加结果异号
            Bool overflow_condition = (sign_a == sign_b) && (sign_a != sign_result);
            return overflow_condition;
        endfunction
        
        // 辅助函数：检查零标志
        function Bool check_zero_func (Bit#(4) op_result);
            return (op_result == 4'b0000);
        endfunction
        
        case (op_code)
            3'b000: begin  // 加法 A + B
                temp_result = extend(a) + extend(b);
                result = temp_result[3:0];
                carry_flag = unpack(temp_result[4]);
                overflow_flag = check_overflow_func(a, b, result, False);
                zero_flag = check_zero_func(result);
            end
            
            3'b001: begin  // 减法 A - B
                temp_result = extend(a) - extend(b);
                result = temp_result[3:0];
                carry_flag = unpack(temp_result[4]);
                overflow_flag = check_overflow_func(a, b, result, True);
                zero_flag = check_zero_func(result);
            end
            
            3'b010: begin  // 取反 ~A
                result = ~a;
                zero_flag = check_zero_func(result);
                temp_result = 0;  // 逻辑操作不需要进位
            end
            
            3'b011: begin  // 与 A & B
                result = a & b;
                zero_flag = check_zero_func(result);
                temp_result = 0;  // 逻辑操作不需要进位
            end
            
            3'b100: begin  // 或 A | B
                result = a | b;
                zero_flag = check_zero_func(result);
                temp_result = 0;  // 逻辑操作不需要进位
            end
            
            3'b101: begin  // 异或 A ^ B
                result = a ^ b;
                zero_flag = check_zero_func(result);
                temp_result = 0;  // 逻辑操作不需要进位
            end
            
            3'b110: begin  // 比较 A < B (带符号)
                Int#(4) signed_a = unpack(a);
                Int#(4) signed_b = unpack(b);
                result = (signed_a < signed_b) ? 4'b0001 : 4'b0000;
                zero_flag = check_zero_func(result);
                temp_result = 0;  // 比较操作不需要进位
            end
            
            3'b111: begin  // 相等 A == B
                result = (a == b) ? 4'b0001 : 4'b0000;
                zero_flag = check_zero_func(result);
                temp_result = 0;  // 比较操作不需要进位
            end
            
            default: begin
                result = 4'b0000;
                zero_flag = True;
                temp_result = 0;
            end
        endcase
        
        return AluResult {
            result: result,
            zero: zero_flag,
            overflow: overflow_flag,
            carry: carry_flag
        };
    endmethod
    
    // 各个独立操作方法
    method Bit#(4) add_op (Bit#(4) a, Bit#(4) b);
        Bit#(5) temp = extend(a) + extend(b);
        return temp[3:0];
    endmethod
    
    method Bit#(4) sub_op (Bit#(4) a, Bit#(4) b);
        Bit#(5) temp = extend(a) - extend(b);
        return temp[3:0];
    endmethod
    
    method Bit#(4) not_op (Bit#(4) a);
        return ~a;
    endmethod
    
    method Bit#(4) and_op (Bit#(4) a, Bit#(4) b);
        return a & b;
    endmethod
    
    method Bit#(4) or_op (Bit#(4) a, Bit#(4) b);
        return a | b;
    endmethod
    
    method Bit#(4) xor_op (Bit#(4) a, Bit#(4) b);
        return a ^ b;
    endmethod
    
    method Bit#(1) less_than (Bit#(4) a, Bit#(4) b);
        Int#(4) signed_a = unpack(a);
        Int#(4) signed_b = unpack(b);
        return (signed_a < signed_b) ? 1'b1 : 1'b0;
    endmethod
    
    method Bit#(1) equal (Bit#(4) a, Bit#(4) b);
        return (a == b) ? 1'b1 : 1'b0;
    endmethod
    
    // 辅助方法：检查溢出
    method Bool check_overflow (Bit#(4) a, Bit#(4) b, Bit#(4) result, Bool is_sub);
        Bit#(1) sign_a = a[3];
        Bit#(1) sign_b = is_sub ? ~b[3] : b[3];  // 减法时B取反
        Bit#(1) sign_result = result[3];
        
        // 溢出条件：两个同号数相加结果异号，或两个异号数相减结果与被减数异号
        Bool overflow_condition = (sign_a == sign_b) && (sign_a != sign_result);
        return overflow_condition;
    endmethod
    
    // 辅助方法：检查零标志
    method Bool check_zero (Bit#(4) result);
        return (result == 4'b0000);
    endmethod
    
endmodule

// 测试模块
(* synthesize *)
module mkTb ();
    
    Alu alu <- mkAlu();
    Reg#(Bit#(4)) test_counter <- mkReg(0);
    
    rule test_add (test_counter == 0);
        AluResult result = alu.alu_op(3'b000, 4'b0011, 4'b0010);  // 3 + 2 = 5
        $display("Test %d: ADD 3+2 = %d, zero=%b, overflow=%b, carry=%b", 
                 test_counter, result.result, result.zero, result.overflow, result.carry);
        test_counter <= test_counter + 1;
    endrule
    
    rule test_sub (test_counter == 1);
        AluResult result = alu.alu_op(3'b001, 4'b0101, 4'b0011);  // 5 - 3 = 2
        $display("Test %d: SUB 5-3 = %d, zero=%b, overflow=%b, carry=%b", 
                 test_counter, result.result, result.zero, result.overflow, result.carry);
        test_counter <= test_counter + 1;
    endrule
    
    rule test_not (test_counter == 2);
        AluResult result = alu.alu_op(3'b010, 4'b1010, 4'b0000);  // ~1010 = 0101
        $display("Test %d: NOT 1010 = %b", test_counter, result.result);
        test_counter <= test_counter + 1;
    endrule
    
    rule test_and (test_counter == 3);
        AluResult result = alu.alu_op(3'b011, 4'b1100, 4'b1010);  // 1100 & 1010 = 1000
        $display("Test %d: AND 1100&1010 = %b", test_counter, result.result);
        test_counter <= test_counter + 1;
    endrule
    
    rule test_or (test_counter == 4);
        AluResult result = alu.alu_op(3'b100, 4'b1100, 4'b1010);  // 1100 | 1010 = 1110
        $display("Test %d: OR 1100|1010 = %b", test_counter, result.result);
        test_counter <= test_counter + 1;
    endrule
    
    rule test_xor (test_counter == 5);
        AluResult result = alu.alu_op(3'b101, 4'b1100, 4'b1010);  // 1100 ^ 1010 = 0110
        $display("Test %d: XOR 1100^1010 = %b", test_counter, result.result);
        test_counter <= test_counter + 1;
    endrule
    
    rule test_less (test_counter == 6);
        AluResult result = alu.alu_op(3'b110, 4'b1110, 4'b0010);  // -2 < 2 = 1
        $display("Test %d: LESS -2<2 = %b", test_counter, result.result);
        test_counter <= test_counter + 1;
    endrule
    
    rule test_equal (test_counter == 7);
        AluResult result = alu.alu_op(3'b111, 4'b0101, 4'b0101);  // 5 == 5 = 1
        $display("Test %d: EQUAL 5==5 = %b", test_counter, result.result);
        test_counter <= test_counter + 1;
    endrule
    
    rule test_overflow (test_counter == 8);
        AluResult result = alu.alu_op(3'b000, 4'b0111, 4'b0001);  // 7 + 1 = 8 (溢出)
        $display("Test %d: OVERFLOW 7+1 = %d, overflow=%b", 
                 test_counter, result.result, result.overflow);
        test_counter <= test_counter + 1;
    endrule
    
    rule finish_test (test_counter == 9);
        $display("All ALU tests completed!");
        $finish;
    endrule
    
endmodule

endpackage

