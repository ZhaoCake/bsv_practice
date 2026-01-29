# Only use basic variables, expected to be included
BSC = bsc
BUILD_DIR = build
VERILOG_DIR = verilog

# Flags
# -keep-fires: Keep fire signals of modules (useful sometimes for debug/waves)
# -aggressive-conditions: Enable more aggressive optimizations for implicit conditions
# -check-assert: Enable assertions in simulation
# -remove-dollar: Remove $display system tasks etc from Verilog output (HDLBits doesn't always like them or needed for synthesis)
BSC_COMMON_FLAGS = -aggressive-conditions -check-assert -keep-fires -cross-info
BSC_SIM_FLAGS = -sim -bdir $(BUILD_DIR) -simdir $(BUILD_DIR) -info-dir $(BUILD_DIR) $(BSC_COMMON_FLAGS)
BSC_V_FLAGS = -verilog -vdir $(VERILOG_DIR) -bdir $(BUILD_DIR) -info-dir $(BUILD_DIR) $(BSC_COMMON_FLAGS) -remove-dollar

.PHONY: clean help all

# Default target
help:
	@echo "BSV Practice - Single File Build System"
	@echo "Usage:"
	@echo "  make <ProblemName>      : Compile and Simulate (Bluesim)"
	@echo "  make <ProblemName>.v    : Generate Verilog for HDLBits submission"
	@echo ""
	@echo "Example:"
	@echo "  make Wire      (Simulate Wire.bsv)"
	@echo "  make Wire.v    (Generate Verilog for Wire.bsv)"

# Clean build artifacts
clean:
	rm -rf $(BUILD_DIR) $(VERILOG_DIR) *_sim *.so *.sched *.bo *.ba *.v

# Pattern rule to compile and run a BSV file (Simulation)
# Assumption: File X.bsv contains top-module mkX
%: %.bsv
	@mkdir -p $(BUILD_DIR)
	@echo "--- 🔨 Compiling $@.bsv (Bluesim) ---"
	$(BSC) $(BSC_SIM_FLAGS) -u -g mk$@ $@.bsv
	@echo "--- 🔗 Linking mk$@ ---"
	$(BSC) $(BSC_SIM_FLAGS) -e mk$@ -o $@_sim
	@echo "--- 🚀 Running Simulation ---"
	./$@_sim

# Pattern rule to generate Verilog
%.v: %.bsv
	@mkdir -p $(BUILD_DIR) $(VERILOG_DIR)
	@echo "--- 📝 Generating Verilog for $*.bsv ---"
	$(BSC) $(BSC_V_FLAGS) -u -g mk$* $*.bsv
	@echo "✅ Verilog generated at: $(VERILOG_DIR)/mk$*.v"
	@echo "   (You may need to rename modules for HDLBits)"
