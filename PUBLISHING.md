# Publishing Guide for Claude Model Selector

This document provides step-by-step instructions for publishing the `claude-model-selector` package to PyPI.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Pre-Publication Checklist](#pre-publication-checklist)
- [Version Management](#version-management)
- [Local Testing](#local-testing)
- [Publishing to Test PyPI](#publishing-to-test-pypi)
- [Publishing to Production PyPI](#publishing-to-production-pypi)
- [Post-Publication](#post-publication)
- [Troubleshooting](#troubleshooting)

---

## Prerequisites

### 1. PyPI Account Setup

- Create accounts on both [PyPI](https://pypi.org/account/register/) and [Test PyPI](https://test.pypi.org/account/register/)
- Set up Two-Factor Authentication (2FA) for security
- Generate API tokens for both PyPI and Test PyPI

### 2. GitHub Repository Setup

Configure GitHub repository secrets (Settings → Secrets and variables → Actions):

- `PYPI_API_TOKEN` - Your PyPI API token
- `TEST_PYPI_API_TOKEN` - Your Test PyPI API token (optional)

**Note:** The publish workflow now uses **Trusted Publishing** (OIDC), which is more secure than API tokens. To set this up:

1. Go to your PyPI account settings
2. Navigate to "Publishing" section
3. Add a new "pending publisher":
   - **PyPI Project Name**: `claude-model-selector`
   - **Owner**: `aeonbridge`
   - **Repository name**: `claude-model-selector`
   - **Workflow name**: `publish.yml`
   - **Environment name**: `pypi`

Repeat for Test PyPI with environment name `testpypi`.

### 3. Install Build Tools

```bash
pip install build twine
```

---

## Pre-Publication Checklist

Before publishing, ensure all these items are complete:

- [ ] **All tests pass**: `pytest`
- [ ] **Code is formatted**: `black src/ tests/ --check`
- [ ] **Linting passes**: `flake8 src/ tests/`
- [ ] **Type checking passes**: `mypy src/`
- [ ] **Version updated** in:
  - [ ] `src/claude_model_selector/__init__.py` (`__version__`)
  - [ ] `setup.py` (`version`)
  - [ ] `pyproject.toml` (`version`)
- [ ] **CHANGELOG.md updated** with new version and changes
- [ ] **README.md reviewed** for accuracy
- [ ] **All dependencies correct** (should be zero for runtime)
- [ ] **License file present** (MIT)
- [ ] **Documentation up to date**

---

## Version Management

This project uses [Semantic Versioning](https://semver.org/):

- **MAJOR** version (1.x.x): Incompatible API changes
- **MINOR** version (x.1.x): New functionality (backwards-compatible)
- **PATCH** version (x.x.1): Bug fixes (backwards-compatible)

### Update Version

Update version in **three** places:

1. `src/claude_model_selector/__init__.py`:
```python
__version__ = "1.0.1"
```

2. `setup.py`:
```python
version="1.0.1",
```

3. `pyproject.toml`:
```toml
version = "1.0.1"
```

---

## Local Testing

### 1. Clean Previous Builds

```bash
rm -rf build/ dist/ *.egg-info src/*.egg-info
```

### 2. Build the Package

```bash
python -m build
```

This creates:
- `dist/claude_model_selector-1.0.0.tar.gz` (source distribution)
- `dist/claude_model_selector-1.0.0-py3-none-any.whl` (wheel)

### 3. Check the Package

```bash
twine check dist/*
```

Expected output:
```
Checking dist/claude_model_selector-1.0.0.tar.gz: PASSED
Checking dist/claude_model_selector-1.0.0-py3-none-any.whl: PASSED
```

### 4. Test Installation Locally

```bash
# Create test environment
python -m venv test_env
source test_env/bin/activate  # On Windows: test_env\Scripts\activate

# Install from wheel
pip install dist/claude_model_selector-1.0.0-py3-none-any.whl

# Test the CLI
claude-model-selector --help
claude-model-selector analyze "Test task"

# Test the Python API
python -c "from claude_model_selector import quick_select; print(quick_select('Test'))"

# Cleanup
deactivate
rm -rf test_env
```

### 5. Inspect Package Contents

```bash
# Extract and inspect wheel
unzip -l dist/claude_model_selector-1.0.0-py3-none-any.whl

# Extract and inspect source distribution
tar -tzf dist/claude_model_selector-1.0.0.tar.gz
```

Verify that:
- All Python files are included
- `config.json` is included
- README.md, LICENSE, CHANGELOG.md are included
- No unnecessary files (tests, .git, __pycache__) are included

---

## Publishing to Test PyPI

**Always test on Test PyPI first!**

### Method 1: Manual Upload

```bash
twine upload --repository testpypi dist/*
```

You'll be prompted for credentials:
- Username: `__token__`
- Password: Your Test PyPI API token (starts with `pypi-`)

### Method 2: Using GitHub Actions

Trigger the workflow manually:

```bash
# From GitHub UI: Actions → Publish to PyPI → Run workflow
# Or use GitHub CLI
gh workflow run publish.yml
```

### Test the Installation from Test PyPI

```bash
# Create fresh environment
python -m venv test_pypi_env
source test_pypi_env/bin/activate

# Install from Test PyPI
pip install --index-url https://test.pypi.org/simple/ claude-model-selector

# Test it
claude-model-selector info
python -c "from claude_model_selector import quick_select; print(quick_select('Test'))"

# Cleanup
deactivate
rm -rf test_pypi_env
```

---

## Publishing to Production PyPI

### Method 1: Via GitHub Release (Recommended)

1. **Create and push a git tag**:
```bash
git tag -a v1.0.0 -m "Release version 1.0.0"
git push origin v1.0.0
```

2. **Create a GitHub Release**:
   - Go to: https://github.com/aeonbridge/claude-model-selector/releases/new
   - Choose tag: `v1.0.0`
   - Release title: `v1.0.0`
   - Description: Copy from CHANGELOG.md
   - Click "Publish release"

3. **GitHub Actions will automatically**:
   - Run all tests
   - Build the package
   - Publish to PyPI

4. **Monitor the workflow**:
   - Go to: https://github.com/aeonbridge/claude-model-selector/actions
   - Check "Publish to PyPI" workflow

### Method 2: Manual Upload

**⚠️ Only use if GitHub Actions fails**

```bash
# Build the package
python -m build

# Check the package
twine check dist/*

# Upload to PyPI
twine upload dist/*
```

---

## Post-Publication

### 1. Verify Publication

- Visit: https://pypi.org/project/claude-model-selector/
- Check version number, description, classifiers
- Verify README renders correctly

### 2. Test Installation

```bash
# Create fresh environment
python -m venv verify_env
source verify_env/bin/activate

# Install from PyPI
pip install claude-model-selector

# Test it
claude-model-selector info
claude-model-selector analyze "Design a scalable architecture"

# Cleanup
deactivate
rm -rf verify_env
```

### 3. Update Documentation

- [ ] Update README.md installation badge (if applicable)
- [ ] Announce on GitHub Discussions
- [ ] Update project status
- [ ] Mark roadmap item as complete

### 4. Create GitHub Release Notes

Add detailed release notes to the GitHub release:

```markdown
## What's New in v1.0.0

### Features
- Initial release
- Intelligent model selection based on task complexity
- CLI and Python API interfaces
- Zero dependencies

### Installation

```bash
pip install claude-model-selector
```

### Quick Start

```python
from claude_model_selector import quick_select

model = quick_select("Design a scalable architecture")
print(model)  # 'opus'
```

See the [README](https://github.com/aeonbridge/claude-model-selector#readme) for full documentation.
```

---

## Troubleshooting

### Package Build Fails

**Error**: `ModuleNotFoundError: No module named 'setuptools'`

**Solution**:
```bash
pip install --upgrade setuptools wheel build
```

### Upload Rejected: File Already Exists

**Error**: `File already exists`

**Solution**: You cannot re-upload the same version. Increment version number:
```bash
# Update version in all three places (see Version Management)
# Then rebuild and upload
```

### Import Errors After Installation

**Error**: `ImportError: cannot import name 'X'`

**Causes**:
1. Check `__init__.py` exports all necessary items
2. Verify package structure with `pip show -f claude-model-selector`
3. Check MANIFEST.in includes all necessary files

### README Not Rendering on PyPI

**Causes**:
1. Invalid Markdown syntax - validate locally
2. GitHub-specific markdown features - use standard markdown
3. Check `long_description_content_type` is set to `"text/markdown"`

### Missing Files in Distribution

**Solution**: Update `MANIFEST.in`:
```
include path/to/missing/file
recursive-include path/to/directory *.ext
```

Then rebuild the package.

### Trusted Publishing Not Working

**Solution**:
1. Verify pending publisher setup on PyPI
2. Check environment name matches exactly
3. Ensure repository and workflow names are correct
4. Verify permissions in workflow file:
```yaml
permissions:
  id-token: write
```

---

## Additional Resources

- [PyPI Publishing Guide](https://packaging.python.org/en/latest/tutorials/packaging-projects/)
- [Twine Documentation](https://twine.readthedocs.io/)
- [Setuptools Documentation](https://setuptools.pypa.io/)
- [Python Packaging User Guide](https://packaging.python.org/)
- [Trusted Publishing Guide](https://docs.pypi.org/trusted-publishers/)

---

## Support

For publishing issues:
- Open an issue: https://github.com/aeonbridge/claude-model-selector/issues
- Contact: support@aeonbridge.com

---

**Last Updated**: 2025-01-07
**Document Version**: 1.0.0