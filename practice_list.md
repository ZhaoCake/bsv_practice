## Practice List

### **1. 基础外设**
#### **1.1 计数器（Counter）**
- **功能**：实现一个简单的计数器，支持启动、停止、复位和计数功能。
- **练习目标**：
  - 熟悉 BSV 的模块定义和接口设计。
  - 理解状态寄存器和时钟驱动的行为。
- **扩展**：
  - 添加计数方向（递增/递减）。
  - 支持预置初始值。

#### **1.2 LED 控制器**
- **功能**：控制一组 LED 灯，支持点亮、熄灭、闪烁和亮度调节。
- **练习目标**：
  - 学习如何将硬件信号映射到外设。
  - 掌握状态机的设计。
- **扩展**：
  - 实现 PWM（脉宽调制）控制亮度。
  - 支持多种闪烁模式（如呼吸灯）。

#### **1.3 按钮去抖（Debouncer）**
- **功能**：实现一个按钮去抖模块，消除机械开关的抖动。
- **练习目标**：
  - 学习如何处理异步输入信号。
  - 掌握时序逻辑和状态机的结合。
- **扩展**：
  - 支持长按和短按检测。
  - 实现多按钮去抖。

---

### **2. 通信接口**
#### **2.1 UART 控制器**
- **功能**：实现一个简单的 UART 发送和接收模块。
- **练习目标**：
  - 学习串行通信协议。
  - 掌握 FIFO 缓冲区的设计。
- **扩展**：
  - 支持可配置波特率。
  - 添加错误检测（如奇偶校验）。

#### **2.2 SPI 控制器**
- **功能**：实现 SPI 主设备和从设备的通信。
- **练习目标**：
  - 理解 SPI 协议的时序。
  - 掌握多信号同步设计。
- **扩展**：
  - 支持多从设备选择。
  - 实现 DMA 传输。

#### **2.3 I2C 控制器**
- **功能**：实现 I2C 主设备和从设备的通信。
- **练习目标**：
  - 学习 I2C 协议的起始、停止和数据传输。
  - 掌握双向信号（SDA）的处理。
- **扩展**：
  - 支持多设备地址。
  - 实现时钟拉伸（Clock Stretching）。

---

### **3. 存储控制器**
#### **3.1 SRAM 控制器**
- **功能**：实现一个简单的 SRAM 读写控制器。
- **练习目标**：
  - 学习存储器的读写时序。
  - 掌握地址译码和数据缓冲。
- **扩展**：
  - 支持突发传输（Burst Transfer）。
  - 添加错误检测和纠正（ECC）。

#### **3.2 FIFO 缓冲区**
- **功能**：实现一个同步或异步 FIFO。
- **练习目标**：
  - 学习 FIFO 的设计原理。
  - 掌握满/空标志的处理。
- **扩展**：
  - 支持不同宽度和深度的配置。
  - 实现双时钟域 FIFO。

---

### **4. 高级外设**
#### **4.1 VGA 控制器**
- **功能**：实现一个简单的 VGA 显示控制器，支持文本或图形模式。
- **练习目标**：
  - 学习视频信号的时序生成。
  - 掌握帧缓冲区的设计。
- **扩展**：
  - 支持多种分辨率和颜色深度。
  - 实现硬件加速（如位块传输）。

#### **4.2 PWM 控制器**
- **功能**：实现一个 PWM 信号生成器，用于控制电机或 LED。
- **练习目标**：
  - 学习 PWM 的原理和实现。
  - 掌握占空比和频率的控制。
- **扩展**：
  - 支持多通道 PWM。
  - 实现死区时间控制（用于电机驱动）。

#### **4.3 定时器/计数器**
- **功能**：实现一个多功能定时器，支持单次、周期和捕获模式。
- **练习目标**：
  - 学习定时器的设计。
  - 掌握中断信号生成。
- **扩展**：
  - 支持多通道定时器。
  - 实现输入捕获和输出比较功能。

---

### **5. 系统集成**
#### **5.1 中断控制器**
- **功能**：实现一个简单的中断控制器，支持优先级和屏蔽。
- **练习目标**：
  - 学习中断处理机制。
  - 掌握多信号源的优先级仲裁。
- **扩展**：
  - 支持嵌套中断。
  - 实现向量化中断。

#### **5.2 DMA 控制器**
- **功能**：实现一个 DMA 控制器，支持内存到外设的数据传输。
- **练习目标**：
  - 学习 DMA 的工作原理。
  - 掌握总线仲裁和数据搬运。
- **扩展**：
  - 支持多通道 DMA。
  - 实现链式传输。

#### **5.3 SoC 集成**
- **功能**：将上述外设集成到一个简单的 SoC 中，通过总线互联。
- **练习目标**：
  - 学习总线协议（如 AXI、Wishbone）。
  - 掌握系统级设计和验证。
- **扩展**：
  - 添加 CPU 核（如 RISC-V）。
  - 实现外设的地址映射和寄存器访问。

---

### **6. 验证与调试**
#### **6.1 编写测试平台**
- **功能**：为每个外设编写 BSV 测试平台，验证其功能。
- **练习目标**：
  - 学习 BSV 的测试框架。
  - 掌握波形调试和断言检查。

#### **6.2 性能分析**
- **功能**：分析外设的时序和资源占用。
- **练习目标**：
  - 学习如何优化设计。
  - 掌握性能瓶颈的定位。

---

### **7. 参考资源**
- **BSV 官方文档**：[Bluespec Inc.](https://bluespec.com/)
- **开源项目**：参考 [RISC-V](https://github.com/riscv) 和 [OpenCores](https://opencores.org/) 上的 BSV 实现。
- **书籍**：《Bluespec SystemVerilog: A Guide to High-Level Design》
