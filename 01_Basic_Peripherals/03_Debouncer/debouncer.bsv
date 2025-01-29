package debouncer;

// 时序相关参数
`define DEBOUNCE_PERIOD  32'd1000000   // 去抖周期（20ms @ 50MHz）
`define LONG_PRESS_TIME  32'd25000000  // 长按时间（500ms @ 50MHz）
`define SHORT_PRESS_MIN  32'd500000    // 最短有效按压时间（10ms @ 50MHz）

// 按钮状态定义
typedef enum {
    IDLE,       // 空闲状态
    DEBOUNCE,   // 去抖状态
    PRESSED,    // 按下状态
    LONG_PRESS  // 长按状态
} BtnState deriving(Bits, Eq);

// 按钮事件类型
typedef enum {
    NO_EVENT,     // 无事件
    SHORT_PRESS,  // 短按事件
    LONG_PRESS,   // 长按事件
    RELEASE       // 释放事件
} BtnEvent deriving(Bits, Eq);

// 去抖器接口
interface Debouncer_ifc;
    // 基本功能
    method Action btnIn(Bit#(1) val);    // 输入按钮信号
    method Bit#(1) btnOut();             // 输出去抖后的信号
    method BtnEvent getEvent();          // 获取按钮事件
    
    // 扩展功能
    method Bool isLongPress();           // 是否处于长按状态
    method Bit#(32) getPressTime();      // 获取按压持续时间
endinterface

(* synthesize *)
module mkDebouncer(Debouncer_ifc);
    // 状态寄存器
    Reg#(BtnState) state <- mkReg(IDLE);
    Reg#(Bit#(1)) rawInput <- mkReg(0);      // 原始输入
    Reg#(Bit#(1)) stableOut <- mkReg(0);     // 稳定输出
    Reg#(Bit#(32)) counter <- mkReg(0);      // 计数器
    Reg#(BtnEvent) currentEvent <- mkReg(NO_EVENT);  // 当前事件
    
    // 去抖和状态转换规则
    rule stateTransition;
        case (state)
            IDLE: begin
                if (rawInput == 1) begin
                    state <= DEBOUNCE;
                    counter <= 0;
                end
                currentEvent <= NO_EVENT;
            end
            
            DEBOUNCE: begin
                if (rawInput == 0) begin
                    state <= IDLE;
                end
                else if (counter >= `DEBOUNCE_PERIOD) begin
                    state <= PRESSED;
                    stableOut <= 1;
                    counter <= 0;
                end
                else begin
                    counter <= counter + 1;
                end
            end
            
            PRESSED: begin
                if (rawInput == 0) begin
                    if (counter >= `SHORT_PRESS_MIN) begin
                        currentEvent <= SHORT_PRESS;
                    end
                    state <= IDLE;
                    stableOut <= 0;
                    counter <= 0;
                end
                else if (counter >= `LONG_PRESS_TIME) begin
                    state <= LONG_PRESS;
                    currentEvent <= LONG_PRESS;
                end
                else begin
                    counter <= counter + 1;
                end
            end
            LONG_PRESS: begin
                if (rawInput == 0) begin
                    state <= IDLE;
                    stableOut <= 0;
                    counter <= 0;
                    currentEvent <= RELEASE;
                end
                else begin
                    counter <= counter + 1;
                end
            end
        endcase
    endrule
    
    // 接口方法实现
    method Action btnIn(Bit#(1) val);
        rawInput <= val;
    endmethod
    
    method Bit#(1) btnOut();
        return stableOut;
    endmethod
    
    method BtnEvent getEvent();
        return currentEvent;
    endmethod
    
    method Bool isLongPress();
        return state == LONG_PRESS;
    endmethod
    
    method Bit#(32) getPressTime();
        return counter;
    endmethod
endmodule

endpackage 