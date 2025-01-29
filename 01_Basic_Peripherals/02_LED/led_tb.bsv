package led_tb;

import StmtFSM::*;
import led::*;

// 定义测试模块
(* synthesize *)
module mkLED_tb(Empty);
    // 实例化被测试的 LED 控制器
    LED_ifc dut <- mkLED;
    
    // 用于测试的状态寄存器
    Reg#(Bit#(32)) cycle <- mkReg(0);
    Reg#(Bit#(32)) testNum <- mkReg(0);
    
    // 用于验证的函数
    function Action displayTest(Bit#(32) num, String name);
        return (action
            testNum <= num;
            $display("=== 测试 %d: %s ===", num, name);
        endaction);
    endfunction
    
    // 测试序列
    Stmt test_seq = seq
        // 测试1：基本开关功能
        displayTest(1, "基本开关功能");
        dut.turnOn();
        delay(10);
        action
            let state = dut.getLEDState();
            $display("LED 开启状态: %d (应该是1)", state);
        endaction
        
        dut.turnOff();
        delay(10);
        action
            let state = dut.getLEDState();
            $display("LED 关闭状态: %d (应该是0)", state);
        endaction
        
        // 测试2：亮度调节
        displayTest(2, "亮度调节功能");
        dut.turnOn();
        dut.setBrightness(128);  // 50% 亮度
        delay(512);
        
        // 测试3：闪烁功能
        displayTest(3, "闪烁功能");
        dut.setBlink(True);
        delay(3000);  // 等待几个闪烁周期
        dut.setBlink(False);
        
        // 测试4：呼吸灯功能
        displayTest(4, "呼吸灯功能");
        dut.setBreathMode(True);
        delay(5000);  // 等待一个完整的呼吸周期
        
        // 测试5：模式切换
        displayTest(5, "模式切换测试");
        dut.turnOn();
        delay(100);
        dut.setBlink(True);
        delay(100);
        dut.turnOff();
        
        // 测试完成
        delay(100);
        $display("所有测试完成");
        $finish(0);
    endseq;
    
    mkAutoFSM(test_seq);
    
    // 计数周期数
    rule count_cycles;
        cycle <= cycle + 1;
    endrule
    
    // 监控 LED 状态变化
    rule monitor_led;
        let state = dut.getLEDState();
        if (cycle[7:0] == 0) begin
            $display("周期: %d, 测试 %d, LED状态: %d", 
                    cycle, testNum, state);
        end
    endrule

endmodule

endpackage 