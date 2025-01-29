package counter;

// 导入基础包
import StmtFSM::*;

// 定义计数器接口
interface Counter_ifc;
    // 基本功能
    method Action start();        // 启动计数器
    method Action stop();         // 停止计数器
    method Action reset();        // 复位计数器
    method Bit#(32) value();     // 获取当前计数值
    
    // 扩展功能
    method Action setDirection(Bool up);    // 设置计数方向：true为递增，false为递减
    method Action preset(Bit#(32) val);     // 设置预置值
endinterface

// 计数器模块实现
(* synthesize *)
module mkCounter(Counter_ifc);
    // 状态寄存器
    Reg#(Bit#(32)) count <- mkReg(0);          // 计数值
    Reg#(Bool) running <- mkReg(False);         // 运行状态
    Reg#(Bool) countUp <- mkReg(True);         // 计数方向
    
    // 规则：计数器运行逻辑
    rule counter_run(running);
        if (countUp)
            count <= count + 1;
        else
            count <= count - 1;
    endrule
    
    // 方法实现
    method Action start();
        running <= True;
    endmethod
    
    method Action stop();
        running <= False;
    endmethod
    
    method Action reset();
        count <= 0;
        running <= False;
    endmethod
    
    method Bit#(32) value();
        return count;
    endmethod
    
    method Action setDirection(Bool up);
        countUp <= up;
    endmethod
    
    method Action preset(Bit#(32) val);
        count <= val;
    endmethod
endmodule

endpackage
