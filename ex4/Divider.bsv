package ex4;

// 输入50MHz时钟，输出1Hz的时钟
// 也就是计数上升沿，25000000-1个上升沿的时候翻转信号

interface DividerIfc;

    method Bit#(1) clk_out;  // 输出时钟信号

endinterface


(* synthesize *)
module mkDivider (DividerIfc);

    // 计数器，需要计数到25,000,000-1
    Reg#(Bit#(25)) counter <- mkReg(0);
    
    // 输出时钟信号
    Reg#(Bit#(1)) clk_out_reg <- mkReg(0);
    
    // 分频逻辑
    rule count_and_toggle;
        if (counter == 24999999) begin  // 25,000,000 - 1
            counter <= 0;
            clk_out_reg <= ~clk_out_reg;  // 翻转输出信号
        end
        else begin
            counter <= counter + 1;
        end
    endrule
    
    // 接口方法实现
    method Bit#(1) clk_out;
        return clk_out_reg;
    endmethod

endmodule


(* synthesize *)
module mkTbDivider ();

    DividerIfc divider <- mkDivider();
    Reg#(Bit#(4)) test_counter <- mkReg(0);  // 4位计数器，可以计数到15
    Reg#(Bit#(1)) prev_clk <- mkReg(0);     // 保存上一个时钟状态，用于检测上升沿
    
    // 检测分频器输出的上升沿并计数
    rule count_on_rising_edge;
        Bit#(1) current_clk = divider.clk_out();
        
        // 检测上升沿：前一个周期是0，当前周期是1
        if (prev_clk == 0 && current_clk == 1) begin
            if (test_counter < 10) begin
                test_counter <= test_counter + 1;
                $display("Time: %0t, Rising edge detected, counter = %0d", $time, test_counter + 1);
            end
            else begin
                $display("Time: %0t, Test completed! Counter reached 10", $time);
                $finish();
            end
        end
        
        prev_clk <= current_clk;
    endrule

endmodule

endpackage