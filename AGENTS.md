<!-- Satellite context file — extends the global hub (~/.claude/CLAUDE.md | ~/.pi/agent/AGENTS.md). Host-neutral; project-specific only. Do not duplicate hub standards here. -->

# lumos-mode

> Emacs major mode for the LUMOS schema language with syntax highlighting, smart indentation, and LSP integration via `lumos-lsp`.

**Ecosystem context:** See [getlumos/lumos/AGENTS.md](https://github.com/getlumos/lumos/blob/main/AGENTS.md) for the LUMOS ecosystem overview, cross-repo standards, and shared guidelines.

**Status:** v0.1.0 development | ✅ Submitted to MELPA (PR #9704)
**Target:** Emacs 26.1+
**Dependencies:** lsp-mode (optional), lumos-lsp server
**MELPA PR:** https://github.com/melpa/melpa/pull/9704

## Key Files

| File | Purpose |
|------|---------|
| `lumos-mode.el` | Main mode implementation (syntax, indent, LSP) |
| `lumos-mode-test.el` | Test suite (14 tests) |
| `README.md` | Installation and usage guide |
| `.github/workflows/ci.yml` | CI testing across Emacs 27.2, 28.2, 29.1, snapshot |
| `Makefile` | Test and compile commands |
| `lumos-mode-recipe.el` | MELPA recipe file |

## Features

- ✅ Syntax highlighting (keywords, types, attributes, comments)
- ✅ Smart indentation (context-aware, configurable offset)
- ✅ LSP integration (auto-completion, diagnostics, hover, etc.)
- ✅ Comment support (line and block)
- ✅ File type auto-detection (`.lumos` → lumos-mode)
- ✅ Customizable variables (indent-offset, lsp-server-command)
- ✅ Test suite (14 tests covering mode, syntax, indent, comments)

## Installation

### MELPA (when published)

```elisp
(use-package lumos-mode
  :ensure t
  :hook (lumos-mode . lsp-deferred))
```

### Manual

```elisp
(add-to-list 'load-path "~/.emacs.d/lisp/lumos-mode")
(require 'lumos-mode)
(add-hook 'lumos-mode-hook #'lsp-deferred)
```

## Common Commands

```bash
make test       # Run all tests
make compile    # Byte compile
make clean      # Clean compiled files
```

**Test Coverage:** 14 tests — mode loading, file association, syntax highlighting, indentation, comments, custom variables.

## Development Workflow

1. Edit `lumos-mode.el`
2. Run tests: `make test`
3. Check compilation: `make compile`
4. Test in Emacs:
   ```elisp
   M-x load-file RET lumos-mode.el RET
   M-x lumos-mode
   ```

CI runs on every push/PR: tests across Emacs 27.2, 28.2, 29.1, snapshot; package-lint validation; byte compilation check.

## Publishing to MELPA

1. Ensure all tests pass
2. Update version in `lumos-mode.el` header
3. Create PR to [melpa/melpa](https://github.com/melpa/melpa) with recipe:

```elisp
(lumos-mode
 :repo "getlumos/lumos-mode"
 :fetcher github
 :files ("*.el"))
```

**Submission Status:** ✅ SUBMITTED (PR #9704, 2025-11-23) — awaiting maintainer review.

## LSP Integration

The mode integrates with `lumos-lsp` (from core repo) for IDE features: auto-completion, diagnostics, hover, go-to-definition, find references, rename.

```elisp
(setq lumos-lsp-server-command '("lumos-lsp" "--log-level" "debug"))
```

Server must be installed separately: `cargo install lumos-lsp`

## Customization

```elisp
;; Indentation width (default: 2)
(setq lumos-indent-offset 4)

;; LSP server command (default: '("lumos-lsp"))
(setq lumos-lsp-server-command '("lumos-lsp" "--log-level" "info"))
```

### Keybindings

```elisp
(define-key lumos-mode-map (kbd "C-c C-c") 'lsp-execute-code-action)
(define-key lumos-mode-map (kbd "C-c C-r") 'lsp-rename)
(define-key lumos-mode-map (kbd "C-c C-f") 'lsp-format-buffer)
```