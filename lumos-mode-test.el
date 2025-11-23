;;; lumos-mode-test.el --- Tests for lumos-mode -*- lexical-binding: t -*-

;; Author: LUMOS Contributors
;; Version: 0.1.0

;;; Commentary:

;; Test suite for lumos-mode.
;; Run tests with: emacs -batch -l lumos-mode.el -l lumos-mode-test.el -f ert-run-tests-batch-and-exit

;;; Code:

(require 'ert)
(require 'lumos-mode)

;;; Basic Mode Tests

(ert-deftest lumos-mode-loads ()
  "Test that lumos-mode loads without error."
  (with-temp-buffer
    (lumos-mode)
    (should (eq major-mode 'lumos-mode))))

(ert-deftest lumos-mode-derived-from-prog-mode ()
  "Test that lumos-mode is derived from prog-mode."
  (with-temp-buffer
    (lumos-mode)
    (should (derived-mode-p 'prog-mode))))

(ert-deftest lumos-mode-file-association ()
  "Test that .lumos files use lumos-mode."
  (let ((test-file (make-temp-file "test" nil ".lumos")))
    (unwind-protect
        (let ((buffer (find-file-noselect test-file)))
          (with-current-buffer buffer
            (should (eq major-mode 'lumos-mode))
            (kill-buffer buffer)))
      (delete-file test-file))))

;;; Syntax Highlighting Tests

(ert-deftest lumos-mode-highlights-keywords ()
  "Test that keywords are highlighted correctly."
  (with-temp-buffer
    (lumos-mode)
    (insert "struct Player {}")
    (font-lock-ensure)
    (goto-char (point-min))
    (should (eq (get-text-property (point) 'face) 'font-lock-keyword-face))))

(ert-deftest lumos-mode-highlights-types ()
  "Test that built-in types are highlighted."
  (with-temp-buffer
    (lumos-mode)
    (insert "level: u64")
    (font-lock-ensure)
    (goto-char (point-min))
    (search-forward "u64")
    (backward-char 1)
    (should (eq (get-text-property (point) 'face) 'font-lock-type-face))))

(ert-deftest lumos-mode-highlights-attributes ()
  "Test that attributes are highlighted."
  (with-temp-buffer
    (lumos-mode)
    (insert "#[solana]")
    (font-lock-ensure)
    (goto-char (point-min))
    (should (eq (get-text-property (point) 'face) 'font-lock-preprocessor-face))))

(ert-deftest lumos-mode-highlights-comments ()
  "Test that comments are highlighted."
  (with-temp-buffer
    (lumos-mode)
    (insert "// This is a comment")
    (font-lock-ensure)
    (goto-char (point-min))
    (should (eq (get-text-property (point) 'face) 'font-lock-comment-face))))

(ert-deftest lumos-mode-highlights-block-comments ()
  "Test that block comments are highlighted."
  (with-temp-buffer
    (lumos-mode)
    (insert "/* Block comment */")
    (font-lock-ensure)
    (goto-char (point-min))
    (should (eq (get-text-property (point) 'face) 'font-lock-comment-face))))

(ert-deftest lumos-mode-highlights-field-names ()
  "Test that field names are highlighted."
  (with-temp-buffer
    (lumos-mode)
    (insert "wallet: PublicKey")
    (font-lock-ensure)
    (goto-char (point-min))
    (should (eq (get-text-property (point) 'face) 'font-lock-variable-name-face))))

;;; Indentation Tests

(ert-deftest lumos-mode-indent-struct ()
  "Test indentation for struct definitions."
  (with-temp-buffer
    (lumos-mode)
    (insert "struct Player {\n")
    (insert "wallet: PublicKey,\n")
    (insert "}")
    (goto-char (point-min))
    (forward-line 1)
    (lumos-indent-line)
    (should (= (current-indentation) 2))
    (forward-line 1)
    (lumos-indent-line)
    (should (= (current-indentation) 0))))

(ert-deftest lumos-mode-indent-enum ()
  "Test indentation for enum definitions."
  (with-temp-buffer
    (lumos-mode)
    (insert "enum State {\n")
    (insert "Active,\n")
    (insert "}")
    (goto-char (point-min))
    (forward-line 1)
    (lumos-indent-line)
    (should (= (current-indentation) 2))
    (forward-line 1)
    (lumos-indent-line)
    (should (= (current-indentation) 0))))

;;; Comment Tests

(ert-deftest lumos-mode-comment-settings ()
  "Test that comment settings are correct."
  (with-temp-buffer
    (lumos-mode)
    (should (string= comment-start "// "))
    (should (string= comment-end ""))))

(ert-deftest lumos-mode-comment-region ()
  "Test commenting a region."
  (with-temp-buffer
    (lumos-mode)
    (insert "struct Player {}")
    (mark-whole-buffer)
    (comment-region (point-min) (point-max))
    (goto-char (point-min))
    (should (looking-at "// "))))

;;; Custom Variable Tests

(ert-deftest lumos-mode-custom-indent-offset ()
  "Test that custom indent offset is respected."
  (let ((lumos-indent-offset 4))
    (with-temp-buffer
      (lumos-mode)
      (insert "struct Player {\n")
      (insert "wallet: PublicKey,\n")
      (goto-char (point-min))
      (forward-line 1)
      (lumos-indent-line)
      (should (= (current-indentation) 4)))))

(ert-deftest lumos-mode-lsp-command-customizable ()
  "Test that LSP command is customizable."
  (should (listp lumos-lsp-server-command))
  (should (string= (car lumos-lsp-server-command) "lumos-lsp")))

;;; Provide

(provide 'lumos-mode-test)

;;; lumos-mode-test.el ends here
