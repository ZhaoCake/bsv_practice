package debouncer_tb;

import StmtFSM::*;
import debouncer::*;

// 时序相关参数
`define DEBOUNCE_PERIOD  32'd1000000   // 去抖周期（20ms @ 50MHz）
`define LONG_PRESS_TIME  32'd25000000  // 长按时间（500ms @ 50MHz）
`define SHORT_PRESS_MIN  32'd500000    // 最短有效按压时间（10ms @ 50MHz）
`define MAX_TEST_DURATION 32'd50000000 // 测试最大持续时间（1s @ 50MHz）

// 定义测试模块
(* synthesize *)
module mkDebouncer_tb(Empty);
    // 实例化被测试的去抖器
    Debouncer_ifc dut <- mkDebouncer;
    
    // 用于测试的状态寄存器
    Reg#(Bit#(32)) cycleCounter <- mkReg(0);
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
        // 测试1：基本去抖功能
        displayTest(1, "基本去抖功能");
        dut.btnIn(1);
        delay(100);
        dut.btnIn(0);
        delay(100);
        dut.btnIn(1);
        delay(`DEBOUNCE_PERIOD + 100);
        action
            let out = dut.btnOut();
            $display("去抖后输出: %d (应该是1)", out);
            if (out != 1) $display("错误：去抖功能不正确！");
        endaction
        
        // 测试2：短按检测
        displayTest(2, "短按检测");
        delay(`SHORT_PRESS_MIN + 100);
        dut.btnIn(0);
        delay(100);
        action
            let btnEvent = dut.getEvent();
            $display("按钮事件: %d (应该是SHORT_PRESS)", btnEvent);
            if (btnEvent != SHORT_PRESS) $display("错误：短按检测不正确！");
        endaction
        
        // 测试3：长按检测
        displayTest(3, "长按检测");
        dut.btnIn(1);
        delay(`DEBOUNCE_PERIOD + 100);
        delay(`LONG_PRESS_TIME + 100);
        action
            let btnEvent = dut.getEvent();
            let isLong = dut.isLongPress();
            $display("按钮事件: %d (应该是LONG_PRESS)", btnEvent);
            $display("长按状态: %d (应该是1)", isLong);
            if (btnEvent != LONG_PRESS || !isLong) $display("错误：长按检测不正确！");
        endaction
        
        // 测试4：释放检测
        displayTest(4, "释放检测");
        dut.btnIn(0);
        delay(100);
        action
            let btnEvent = dut.getEvent();
            $display("按钮事件: %d (应该是RELEASE)", btnEvent);
            if (btnEvent != RELEASE) $display("错误：释放检测不正确！");
        endaction
        
        // 测试5：按压时间测量
        displayTest(5, "按压时间测量");
        dut.btnIn(1);
        delay(`DEBOUNCE_PERIOD + 1000);
        action
            let pressTime = dut.getPressTime();
            $display("按压时间: %d (应该大约是1000)", pressTime);
            if (pressTime < 900 || pressTime > 1100) 
                $display("错误：按压时间测量不准确！");
        endaction
        dut.btnIn(0);
        
        // 测试完成
        delay(100);
        $display("所有测试完成");
        $finish(0);
    endseq;
    
    // 创建并启动测试 FSM
    mkAutoFSM(test_seq);
    
    // 添加持续时间限制
    rule check_duration;
        cycleCounter <= cycleCounter + 1;
        if (cycleCounter > `MAX_TEST_DURATION) begin
            $display("测试超时，自动停止。");
            $finish(0);
        end
    endrule
    
    // 监控状态变化
    rule monitor_state;
        if (cycleCounter[7:0] == 0) begin
            let out = dut.btnOut();
            let btnEvent = dut.getEvent();
            let isLong = dut.isLongPress();
            let pressTime = dut.getPressTime();
            $display("周期: %d, 测试 %d, 输出: %d, 事件: %d, 长按: %d, 时间: %d",
                    cycleCounter, testNum, out, btnEvent, isLong, pressTime);
        end
    endrule

endmodule

endpackage 