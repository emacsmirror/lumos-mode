# MELPA Submission Guide for lumos-mode

## Repository Information

- **MELPA Repository:** https://github.com/melpa/melpa
- **Stars:** 2,892 ⭐
- **Forks:** 2,625 🍴
- **Total Packages:** 7,000+
- **Our Package:** lumos-mode

## Prerequisites

Before submitting, ensure:

- [x] All tests pass in GitHub Actions CI
- [x] Byte compilation clean (no warnings)
- [x] package-lint validation passes
- [x] README.md complete
- [x] Source code in public GitHub repository
- [ ] **Wait for CI to be green** ← Check this first!

**CI Status:** https://github.com/getlumos/lumos-mode/actions

## Step-by-Step Submission Process

### Step 1: Verify CI is Green

```bash
# Check latest CI run
gh run list --repo getlumos/lumos-mode --limit 1

# Should show: "completed  success"
```

**✅ Required:** All tests must pass before submission!

### Step 2: Fork MELPA Repository

```bash
# Fork the repository
gh repo fork melpa/melpa --clone

# Navigate to the fork
cd melpa
```

### Step 3: Create Recipe File

Create the recipe file at `recipes/lumos-mode`:

```bash
cat > recipes/lumos-mode << 'EOF'
(lumos-mode
 :repo "getlumos/lumos-mode"
 :fetcher github
 :files ("*.el"))
EOF
```

**Recipe Breakdown:**

| Field | Value | Meaning |
|-------|-------|---------|
| Package name | `lumos-mode` | Name users will install |
| `:repo` | `"getlumos/lumos-mode"` | GitHub repository |
| `:fetcher` | `github` | Fetch from GitHub |
| `:files` | `("*.el")` | Include all .el files |

### Step 4: Test Recipe Locally (Optional)

```bash
# Build package locally to verify recipe works
make recipes/lumos-mode

# Expected output: Package built successfully
```

### Step 5: Create Branch and Commit

```bash
# Create feature branch
git checkout -b add-lumos-mode

# Add recipe file
git add recipes/lumos-mode

# Commit with descriptive message
git commit -m "Add lumos-mode recipe

lumos-mode is an Emacs major mode for the LUMOS schema language.

LUMOS is a type-safe schema language for Solana development that
bridges TypeScript ↔ Rust with guaranteed Borsh serialization.

Features:
- Syntax highlighting for LUMOS keywords, types, and attributes
- Smart indentation with configurable offset
- LSP integration via lsp-mode and lumos-lsp server
- Auto-completion, diagnostics, hover, go-to-definition
- File type auto-detection for .lumos files
- Comprehensive test suite (14 unit tests)
- CI testing across Emacs 27.2, 28.2, 29.1, snapshot

Repository: https://github.com/getlumos/lumos-mode
Documentation: https://github.com/getlumos/lumos-mode#readme"
```

### Step 6: Push to Your Fork

```bash
# Push branch to your fork
git push origin add-lumos-mode
```

### Step 7: Create Pull Request

```bash
# Create PR to melpa/melpa
gh pr create --repo melpa/melpa \
  --title "Add lumos-mode" \
  --body "New package: lumos-mode

## Description

Emacs major mode for the LUMOS schema language - a type-safe schema language for Solana development.

## Package Information

- **Repository:** https://github.com/getlumos/lumos-mode
- **License:** Dual-licensed (MIT + Apache 2.0)
- **Dependencies:** Emacs 26.1+, lsp-mode (optional)
- **Tests:** 14 unit tests, CI across 4 Emacs versions
- **Documentation:** Comprehensive README with installation and usage guide

## Features

- Syntax highlighting for keywords, types, attributes, comments
- Smart indentation with configurable offset
- LSP integration for auto-completion and diagnostics
- File type auto-detection for \`.lumos\` files
- Customizable variables (\`lumos-indent-offset\`, \`lumos-lsp-server-command\`)

## Testing

- ✅ All 14 unit tests passing
- ✅ Byte compilation clean (no warnings)
- ✅ package-lint validation passes
- ✅ GitHub Actions CI green (Emacs 27.2, 28.2, 29.1, snapshot)

CI Status: https://github.com/getlumos/lumos-mode/actions

## Checklist

- [x] Recipe file created at \`recipes/lumos-mode\`
- [x] Source code in public GitHub repository
- [x] README.md with installation instructions
- [x] LICENSE files (MIT + Apache 2.0)
- [x] All tests passing
- [x] No byte-compilation warnings
- [x] package-lint clean

Ready for review!"
```

### Step 8: Wait for Review

MELPA maintainers will review your submission:

**Review Process:**
1. **Automated Checks** - Recipe syntax, package builds
2. **Manual Review** - Code quality, naming conventions, dependencies
3. **Feedback** - Maintainers may request changes
4. **Approval** - PR merged when everything looks good

**Timeline:** Usually 1-7 days (can be faster for simple packages)

### Step 9: Address Feedback (if needed)

If maintainers request changes:

```bash
# Make requested changes to recipe
vim recipes/lumos-mode

# Commit and push
git add recipes/lumos-mode
git commit -m "Address review feedback: <description>"
git push origin add-lumos-mode
```

### Step 10: Merge and Celebrate! 🎉

Once merged:
- ✅ Package available on MELPA within 24 hours
- ✅ Users can install via `M-x package-install RET lumos-mode`
- ✅ Auto-updates from your GitHub repo daily

## Common Review Feedback

Be prepared to address:

1. **Naming Conventions**
   - Package name should match file name: `lumos-mode.el` ✓
   - Functions should be prefixed: `lumos-` ✓

2. **Dependencies**
   - Declare all required packages in `Package-Requires` ✓
   - We only require: `emacs "26.1"`, `lsp-mode "8.0"` ✓

3. **Documentation**
   - README.md must exist ✓
   - Installation instructions required ✓

4. **Code Quality**
   - No byte-compilation warnings ✓
   - package-lint clean ✓

**We're already compliant with all requirements!** ✅

## After MELPA Acceptance

Users install with:

```elisp
;; Add to ~/.emacs.d/init.el
(use-package lumos-mode
  :ensure t
  :hook (lumos-mode . lsp-deferred))
```

Then:
```elisp
M-x package-refresh-contents
M-x package-install RET lumos-mode
```

## Alternative: Test on MELPA Locally First

Before submitting, you can test locally:

```bash
# Clone MELPA
git clone https://github.com/melpa/melpa.git
cd melpa

# Add your recipe
cat > recipes/lumos-mode << 'EOF'
(lumos-mode
 :repo "getlumos/lumos-mode"
 :fetcher github
 :files ("*.el"))
EOF

# Build package locally
make recipes/lumos-mode

# If successful, you're ready to submit!
```

## Quick Commands Reference

```bash
# Fork MELPA
gh repo fork melpa/melpa --clone
cd melpa

# Create recipe
cat > recipes/lumos-mode << 'EOF'
(lumos-mode :repo "getlumos/lumos-mode" :fetcher github :files ("*.el"))
EOF

# Commit and PR
git checkout -b add-lumos-mode
git add recipes/lumos-mode
git commit -m "Add lumos-mode recipe"
git push origin add-lumos-mode
gh pr create --repo melpa/melpa --title "Add lumos-mode"
```

## Questions?

- **When to submit?** After CI is green (all tests pass)
- **What if rejected?** Address feedback and resubmit
- **How long does review take?** 1-7 days typically
- **Can I update after accepted?** Yes! MELPA auto-pulls from your GitHub repo daily

## Current Status

- ✅ Package code complete
- ✅ Tests complete (unit, integration, E2E)
- ✅ Documentation complete
- ✅ Recipe ready
- [ ] **CI validation in progress** ← Check Actions tab
- [ ] Submit PR to melpa/melpa

**Next:** Wait for CI to be green, then submit!

---

**Repository:** https://github.com/getlumos/lumos-mode
**CI Status:** https://github.com/getlumos/lumos-mode/actions
**MELPA:** https://github.com/melpa/melpa
