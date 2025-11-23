# CLAUDE.md - lumos-mode

**Repository**: https://github.com/getlumos/lumos-mode
**Purpose**: Emacs major mode for LUMOS schema language

---

## Quick Reference

For complete ecosystem context, see: **[lumos/CLAUDE.md](https://github.com/getlumos/lumos/blob/main/CLAUDE.md)**

---

## What is lumos-mode?

Emacs major mode for editing `.lumos` files with syntax highlighting, smart indentation, and LSP integration via `lumos-lsp`.

**Status**: v0.1.0 development
**Target**: Emacs 26.1+
**Dependencies**: lsp-mode (optional), lumos-lsp server

---

## Key Files

| File | Purpose |
|------|---------|
| `lumos-mode.el` | Main mode implementation (syntax, indent, LSP) |
| `lumos-mode-test.el` | Test suite (14 tests) |
| `README.md` | Installation and usage guide |
| `.github/workflows/ci.yml` | CI testing across Emacs 27.2, 28.2, 29.1, snapshot |
| `Makefile` | Test and compile commands |
| `lumos-mode-recipe.el` | MELPA recipe file |

---

## Features Implemented

- ✅ Syntax highlighting (keywords, types, attributes, comments)
- ✅ Smart indentation (context-aware, configurable offset)
- ✅ LSP integration (auto-completion, diagnostics, hover, etc.)
- ✅ Comment support (line and block)
- ✅ File type auto-detection (`.lumos` → lumos-mode)
- ✅ Customizable variables (indent-offset, lsp-server-command)
- ✅ Test suite (14 tests covering mode, syntax, indent, comments)

---

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

---

## Testing

```bash
# Run all tests
make test

# Byte compile
make compile

# Clean compiled files
make clean
```

**Test Coverage**: 14 tests
- Mode loading and derivation
- File association
- Syntax highlighting (keywords, types, attributes, comments)
- Indentation (structs, enums)
- Comment functionality
- Custom variables

---

## Development Workflow

### Making Changes

1. Edit `lumos-mode.el`
2. Run tests: `make test`
3. Check compilation: `make compile`
4. Test in Emacs:
   ```elisp
   M-x load-file RET lumos-mode.el RET
   M-x lumos-mode
   ```

### Adding Features

1. Implement feature in `lumos-mode.el`
2. Add tests to `lumos-mode-test.el`
3. Update README.md with usage instructions
4. Run full test suite
5. Update CLAUDE.md if architecture changes

### CI Pipeline

GitHub Actions runs on every push/PR:
- Tests across Emacs 27.2, 28.2, 29.1, snapshot
- package-lint validation
- Byte compilation check

---

## Publishing to MELPA

### Submission Process

1. Ensure all tests pass
2. Update version in `lumos-mode.el` header
3. Create PR to [melpa/melpa](https://github.com/melpa/melpa) with recipe:

```elisp
(lumos-mode
 :repo "getlumos/lumos-mode"
 :fetcher github
 :files ("*.el"))
```

4. MELPA maintainers review and merge
5. Package available within 24 hours

### Pre-submission Checklist

- [ ] All tests passing locally
- [ ] CI passing on GitHub
- [ ] README.md complete
- [ ] Version bumped in header
- [ ] package-lint clean
- [ ] Byte compilation clean

---

## LSP Integration

### lumos-lsp Server

The mode integrates with `lumos-lsp` (from core repo) for IDE features:

- **Auto-completion**: Type suggestions
- **Diagnostics**: Inline error checking
- **Hover**: Documentation on hover
- **Go to definition**: Jump to type definitions
- **Find references**: Find all usages
- **Rename**: Rename symbols across files

### Configuration

```elisp
(setq lumos-lsp-server-command '("lumos-lsp" "--log-level" "debug"))
```

Server must be installed separately:

```bash
cargo install lumos-lsp
```

---

## Customization

### Variables

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

---

## Related Repositories

- **lumos** (core): Compiler, CLI, LSP server
- **vscode-lumos**: VS Code extension
- **intellij-lumos**: IntelliJ IDEA / Rust Rover plugin
- **nvim-lumos**: Neovim plugin with Tree-sitter
- **tree-sitter-lumos**: Tree-sitter grammar
- **awesome-lumos**: Examples and templates
- **docs-lumos**: Official documentation site

---

## AI Assistant Guidelines

### ✅ DO

- Run `make test` after any code changes
- Update tests when adding new features
- Keep README.md synchronized with code
- Reference file:line when discussing code
- Check CI passes before committing

### ❌ DON'T

- Skip running tests to save time
- Add features without tests
- Change indentation logic without extensive testing
- Break backward compatibility with Emacs 26.1
- Include AI attribution in commits or code

---

**Last Updated**: 2025-11-24
**Version**: 0.1.0
**Status**: Development
