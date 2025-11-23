.PHONY: test clean compile

EMACS ?= emacs
BATCH = $(EMACS) -batch -Q -L .

test:
	@echo "Running tests..."
	$(BATCH) -l lumos-mode.el -l lumos-mode-test.el -f ert-run-tests-batch-and-exit

compile:
	@echo "Byte-compiling..."
	$(BATCH) -f batch-byte-compile lumos-mode.el

clean:
	@echo "Cleaning..."
	rm -f *.elc
