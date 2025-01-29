package counter_tb;

// 导入必要的包
import StmtFSM::*;
import counter::*;

// 定义测试模块
(* synthesize *)
module mkCounter_tb(Empty);
    // 实例化被测试的计数器
    Counter_ifc dut <- mkCounter;
    
    // 用于测试的状态寄存器
    Reg#(Bit#(32)) cycle <- mkReg(0);
    
    // 测试序列
    Stmt test_seq = seq
        // 测试1：基本计数功能（递增）
        $display("测试1：基本递增计数功能");
        dut.start();
        delay(5);
        action
            let val = dut.value();
            $display("计数值为: %d (应该是5)", val);
            if (val != 5) $display("错误：计数值不正确！");
        endaction
        dut.stop();
        
        // 测试2：复位功能
        $display("测试2：复位功能");
        dut.reset();
        action
            let val = dut.value();
            $display("复位后的值: %d (应该是0)", val);
            if (val != 0) $display("错误：复位功能不正确！");
        endaction
        
        // 测试3：预置值功能
        $display("测试3：预置值功能");
        dut.preset(100);
        action
            let val = dut.value();
            $display("预置后的值: %d (应该是100)", val);
            if (val != 100) $display("错误：预置值功能不正确！");
        endaction
        
        // 测试4：递减计数功能
        $display("测试4：递减计数功能");
        dut.setDirection(False);
        dut.start();
        delay(5);
        action
            let val = dut.value();
            $display("递减后的值: %d (应该是95)", val);
            if (val != 95) $display("错误：递减计数不正确！");
        endaction
        dut.stop();
        
        // 测试完成
        $display("所有测试完成");
        $finish(0);
    endseq;
    
    // 创建并启动测试FSM
    mkAutoFSM(test_seq);
    
    // 计数周期数
    rule count_cycles;
        cycle <= cycle + 1;
    endrule
    
    // 显示仿真时间
    rule show_cycles;
        $display("周期: %d", cycle);
    endrule

endmodule

endpackage
