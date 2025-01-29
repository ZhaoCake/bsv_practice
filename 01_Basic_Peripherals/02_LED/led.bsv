package led;

// 时序相关参数（时钟周期数）
`define BLINK_PERIOD   32'd25000000   // 闪烁周期
`define BREATH_STEP    8'd1          // 呼吸渐变步进
`define MAX_BRIGHTNESS 8'd255        // 最大亮度值

// LED 控制接口
interface LED_ifc;
    // 基本功能
    method Action turnOn();           // 打开 LED
    method Action turnOff();          // 关闭 LED
    method Action setBlink(Bool en);  // 设置闪烁模式
    method Action setBrightness(Bit#(8) level); // 设置亮度级别 (0-255)
    
    // 扩展功能
    method Action setBreathMode(Bool en);    // 设置呼吸灯模式
    method Bit#(1) getLEDState();            // 获取 LED 当前状态
endinterface

// LED 模块实现
(* synthesize *)
module mkLED(LED_ifc);
    // 状态寄存器
    Reg#(Bool) ledOn <- mkReg(False);        // LED 开关状态
    Reg#(Bool) blinkEnable <- mkReg(False);  // 闪烁使能
    Reg#(Bool) breathEnable <- mkReg(False); // 呼吸灯使能
    Reg#(Bit#(8)) brightness <- mkReg(`MAX_BRIGHTNESS);  // 亮度值
    Reg#(Bit#(8)) pwmCounter <- mkReg(0);    // PWM 计数器
    Reg#(Bit#(8)) breathCounter <- mkReg(0); // 呼吸灯计数器
    Reg#(Bool) breathDir <- mkReg(True);     // 呼吸方向：True 递增，False 递减
    
    // 闪烁计数器
    Reg#(Bit#(32)) blinkCounter <- mkReg(0);
    
    // PWM 规则
    rule pwm_control;
        pwmCounter <= pwmCounter + 1;
    endrule
    
    // 闪烁控制规则
    rule blink_control (blinkEnable);
        if (blinkCounter == `BLINK_PERIOD) begin
            ledOn <= !ledOn;
            blinkCounter <= 0;
        end
        else
            blinkCounter <= blinkCounter + 1;
    endrule
    
    // 呼吸灯控制规则
    rule breath_control (breathEnable);
        if (breathDir) begin
            if (breathCounter < `MAX_BRIGHTNESS)
                breathCounter <= breathCounter + `BREATH_STEP;
            else
                breathDir <= False;
        end
        else begin
            if (breathCounter > 0)
                breathCounter <= breathCounter - `BREATH_STEP;
            else
                breathDir <= True;
        end
        brightness <= breathCounter;
    endrule
    
    // 方法实现
    method Action turnOn();
        ledOn <= True;
        blinkEnable <= False;
        breathEnable <= False;
    endmethod
    
    method Action turnOff();
        ledOn <= False;
        blinkEnable <= False;
        breathEnable <= False;
    endmethod
    
    method Action setBlink(Bool en);
        blinkEnable <= en;
        breathEnable <= False;
        if (en) begin
            blinkCounter <= 0;
        end
    endmethod
    
    method Action setBrightness(Bit#(8) level);
        brightness <= level;
        breathEnable <= False;
    endmethod
    
    method Action setBreathMode(Bool en);
        breathEnable <= en;
        blinkEnable <= False;
        if (en) begin
            breathCounter <= 0;
            breathDir <= True;
        end
    endmethod
    
    method Bit#(1) getLEDState();
        // PWM 输出逻辑
        if (ledOn && !blinkEnable && !breathEnable)
            return (pwmCounter < brightness) ? 1 : 0;
        else if (blinkEnable)
            return (ledOn ? 1 : 0);
        else if (breathEnable)
            return (pwmCounter < breathCounter) ? 1 : 0;
        else
            return 0;
    endmethod
endmodule

endpackage
