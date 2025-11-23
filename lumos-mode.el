;;; lumos-mode.el --- Major mode for LUMOS schema language -*- lexical-binding: t -*-

;; Author: LUMOS Contributors
;; Version: 0.1.0
;; Package-Requires: ((emacs "26.1") (lsp-mode "8.0"))
;; Keywords: languages solana blockchain
;; URL: https://github.com/getlumos/lumos-mode

;;; Commentary:

;; Major mode for editing LUMOS schema files (.lumos).
;;
;; LUMOS is a type-safe schema language for Solana development that
;; bridges TypeScript ↔ Rust with guaranteed Borsh serialization
;; compatibility.
;;
;; Features:
;; - Syntax highlighting for LUMOS keywords, types, and attributes
;; - Smart indentation
;; - LSP integration via lsp-mode
;; - Auto-completion and diagnostics
;; - Comment support (line and block)
;;
;; Installation:
;;
;; Using straight.el:
;;   (use-package lumos-mode
;;     :straight (lumos-mode :type git :host github :repo "getlumos/lumos-mode")
;;     :hook (lumos-mode . lsp-deferred))
;;
;; Using package.el (MELPA):
;;   (use-package lumos-mode
;;     :ensure t
;;     :hook (lumos-mode . lsp-deferred))
;;
;; Manual installation:
;;   (add-to-list 'load-path "~/.emacs.d/lisp/lumos-mode")
;;   (require 'lumos-mode)
;;   (add-hook 'lumos-mode-hook #'lsp-deferred)

;;; Code:

(require 'lsp-mode nil t)

;;; Customization

(defgroup lumos nil
  "Major mode for editing LUMOS schema files."
  :group 'languages
  :prefix "lumos-")

(defcustom lumos-lsp-server-command '("lumos-lsp")
  "Command to start LUMOS LSP server.
The LSP server provides auto-completion, diagnostics, hover
documentation, and other IDE features."
  :type '(repeat string)
  :group 'lumos)

(defcustom lumos-indent-offset 2
  "Number of spaces for each indentation level in LUMOS mode."
  :type 'integer
  :group 'lumos
  :safe 'integerp)

;;; Syntax Highlighting

(defvar lumos-mode-font-lock-keywords
  (let ((keywords '("struct" "enum"))
        (types '("u8" "u16" "u32" "u64" "u128"
                 "i8" "i16" "i32" "i64" "i128"
                 "bool" "String"
                 "PublicKey" "Signature"
                 "Vec" "Option"))
        (attributes '("solana" "account" "version" "deprecated")))
    `(
      ;; Keywords
      (,(regexp-opt keywords 'words) . font-lock-keyword-face)

      ;; Built-in types
      (,(regexp-opt types 'words) . font-lock-type-face)

      ;; Attributes (#[...])
      ("#\\[\\([^]]+\\)\\]" (0 font-lock-preprocessor-face))

      ;; Attribute names inside brackets
      (,(concat "#\\[\\(" (regexp-opt attributes) "\\)")
       (1 font-lock-constant-face))

      ;; Field names (identifier before colon)
      ("\\<\\([a-zA-Z_][a-zA-Z0-9_]*\\)\\s-*:" (1 font-lock-variable-name-face))

      ;; Type names (after struct/enum keywords)
      ("\\<\\(?:struct\\|enum\\)\\s-+\\([A-Z][a-zA-Z0-9_]*\\)"
       (1 font-lock-type-face))

      ;; Enum variant names
      ("^\\s-*\\([A-Z][a-zA-Z0-9_]*\\)\\s-*[,{(]" (1 font-lock-constant-face))

      ;; Line comments
      ("//.*$" . font-lock-comment-face)

      ;; Block comments
      ("/\\*\\(?:[^*]\\|\\*[^/]\\)*\\*/" . font-lock-comment-face)

      ;; String literals
      ("\"\\(?:[^\"\\]\\|\\\\.\\)*\"" . font-lock-string-face)))
  "Keyword highlighting specification for `lumos-mode'.")

;;; Indentation

(defun lumos-indent-line ()
  "Indent current line as LUMOS code."
  (interactive)
  (let ((indent-col 0)
        (offset lumos-indent-offset))
    (save-excursion
      (beginning-of-line)
      (cond
       ;; Don't indent the first line
       ((bobp)
        (setq indent-col 0))

       ;; Closing brace: decrease indent
       ((looking-at "^[ \t]*[})]")
        (save-excursion
          (forward-line -1)
          (setq indent-col (max 0 (- (current-indentation) offset)))))

       ;; Otherwise, calculate based on previous line
       (t
        (let ((prev-indent 0)
              (found nil))
          (save-excursion
            (while (and (not found) (not (bobp)))
              (forward-line -1)
              (unless (looking-at "^[ \t]*$")  ; Skip empty lines
                (setq prev-indent (current-indentation))
                (setq found t)
                ;; If previous line opens a block, increase indent
                (when (looking-at ".*[{(][ \t]*$")
                  (setq prev-indent (+ prev-indent offset))))))
          (setq indent-col prev-indent)))))

    ;; Apply the calculated indentation
    (save-excursion
      (beginning-of-line)
      (delete-horizontal-space)
      (indent-to indent-col))

    ;; Move point to indentation if before it
    (when (< (current-column) indent-col)
      (move-to-column indent-col))))

;;; LSP Integration

(when (featurep 'lsp-mode)
  ;; Register LUMOS language ID
  (add-to-list 'lsp-language-id-configuration '(lumos-mode . "lumos"))

  ;; Register LUMOS LSP client
  (lsp-register-client
   (make-lsp-client
    :new-connection (lsp-stdio-connection
                     (lambda () lumos-lsp-server-command))
    :major-modes '(lumos-mode)
    :server-id 'lumos-lsp
    :priority -1)))

;;; Mode Definition

;;;###autoload
(define-derived-mode lumos-mode prog-mode "LUMOS"
  "Major mode for editing LUMOS schema files.

LUMOS is a type-safe schema language for Solana development.

\\{lumos-mode-map}"
  :group 'lumos

  ;; Syntax highlighting
  (setq-local font-lock-defaults '(lumos-mode-font-lock-keywords nil nil))

  ;; Comments
  (setq-local comment-start "// ")
  (setq-local comment-end "")
  (setq-local comment-start-skip "//+\\s-*")
  (setq-local comment-use-syntax t)

  ;; Indentation
  (setq-local indent-line-function #'lumos-indent-line)
  (setq-local electric-indent-chars '(?\n ?\} ?\)))

  ;; Enable LSP if available
  (when (and (featurep 'lsp-mode)
             (fboundp 'lsp-deferred))
    (lsp-deferred)))

;;; File Association

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.lumos\\'" . lumos-mode))

;;; Provide

(provide 'lumos-mode)

;;; lumos-mode.el ends here
