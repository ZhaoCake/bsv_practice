# Root Makefile
# Recursively clean or help

.PHONY: all clean help

help:
	@echo "BSV HDLBits Workspace"
	@echo "See subdirectories in hdlbits/ for problems."
	@echo "Run 'make <ProblemName>' inside a subdirectory."

clean:
	@find . -name "build" -type d -exec rm -rf {} +
	@find . -name "*_sim" -type f -delete
	@find . -name "*.bo" -type f -delete
	@find . -name "*.ba" -type f -delete
	@find . -name "*.so" -type f -delete
	@find . -name "*.sched" -type f -delete
