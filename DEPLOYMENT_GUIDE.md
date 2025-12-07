# Deployment Guide

Complete guide for extracting Claude Model Selector to a standalone repository and publishing it.

## 📦 Repository Structure

The standalone package is ready for extraction in:
```
claude-model-selector-standalone/
```

Complete with:
- ✅ Source code
- ✅ Documentation
- ✅ Tests structure
- ✅ CI/CD workflows
- ✅ License (MIT)
- ✅ Setup files

---

## 🚀 Step 1: Create New GitHub Repository

### 1.1 Create Repository

1. Go to https://github.com/aeonbridge
2. Click "New repository"
3. Settings:
   - **Name**: `claude-model-selector`
   - **Description**: "Intelligent model selection for optimal cost-effectiveness with Anthropic's Claude AI"
   - **Visibility**: Public
   - **Initialize**: ❌ Do NOT initialize (we have files ready)
4. Click "Create repository"

### 1.2 Repository Settings

After creation, configure:

**General**:
- ✅ Enable Issues
- ✅ Enable Discussions
- ✅ Enable Wiki (optional)

**Features**:
- ✅ Wikis
- ✅ Discussions
- ✅ Projects (optional)

**Topics** (add these):
```
claude, anthropic, ai, model-selection, cost-optimization, llm, machine-learning, python
```

---

## 🔧 Step 2: Initialize Local Repository

```bash
# Navigate to the standalone directory
cd claude-model-selector-standalone/

# Initialize git
git init

# Add all files
git add .

# Initial commit
git commit -m "Initial release v1.0.0

Claude Model Selector - Intelligent model selection for Anthropic Claude AI

Features:
- Automatic complexity analysis (0-100 scoring)
- Model selection (Haiku, Sonnet, Opus)
- Cost estimation and optimization (70-95% savings)
- CLI and Python API
- Zero dependencies
- Comprehensive documentation

Sponsored by AeonBridge Co.
Licensed under MIT License
"

# Add remote (replace with your actual URL)
git remote add origin https://github.com/aeonbridge/claude-model-selector.git

# Push to main
git branch -M main
git push -u origin main
```

---

## 🏷️ Step 3: Create First Release

### 3.1 Create Git Tag

```bash
# Create annotated tag
git tag -a v1.0.0 -m "Version 1.0.0 - Initial Release

Features:
- Intelligent complexity analysis
- Automatic model selection
- Cost optimization
- CLI interface (analyze, compare, batch, info)
- Python API (quick_select, ClaudeModelSelector)
- Zero dependencies
- Comprehensive documentation

Cost Savings: 70-95% compared to using Opus for all tasks
"

# Push tag
git push origin v1.0.0
```

### 3.2 Create GitHub Release

1. Go to repository → Releases → "Create a new release"
2. Choose tag: `v1.0.0`
3. Release title: `v1.0.0 - Initial Release`
4. Description:

```markdown
# Claude Model Selector v1.0.0

**Intelligent model selection for optimal cost-effectiveness with Anthropic's Claude AI**

## 🎉 First Stable Release

Save 70-95% on AI costs by automatically selecting the most cost-effective Claude model for each task.

## ✨ Features

- **Automatic Complexity Analysis** - Smart scoring (0-100)
- **Model Selection** - Haiku, Sonnet, or Opus based on complexity
- **Cost Optimization** - Significant savings while maintaining quality
- **CLI Interface** - Easy command-line usage
- **Python API** - Programmatic integration
- **Zero Dependencies** - Pure Python implementation
- **Customizable** - Configure for your needs

## 📦 Installation

```bash
pip install claude-model-selector
```

## 🚀 Quick Start

```python
from claude_model_selector import quick_select

model = quick_select("Design scalable architecture")
# Returns: 'opus'
```

```bash
claude-model-selector analyze "Your task here"
```

## 📚 Documentation

- [User Guide](docs/GUIDE.md)
- [Examples](examples/)
- [Contributing](CONTRIBUTING.md)

## 💰 Cost Comparison

| Usage | Optimized | All Opus | Savings |
|-------|-----------|----------|---------|
| 10 mixed tasks | $0.032 | $0.144 | 77.8% |

## 🙏 Credits

Created with ❤️ by **AeonBridge Co.**

## 📝 License

MIT License - See [LICENSE](LICENSE) for details

---

**Full Changelog**: https://github.com/aeonbridge/claude-model-selector/blob/main/CHANGELOG.md
```

5. Click "Publish release"

---

## 📦 Step 4: Publish to PyPI

### 4.1 Get PyPI API Token

1. Go to https://pypi.org/manage/account/
2. Scroll to "API tokens"
3. Click "Add API token"
4. Name: "claude-model-selector-upload"
5. Scope: "Entire account" or project-specific
6. Copy token (starts with `pypi-`)

### 4.2 Add Token to GitHub Secrets

1. Repository → Settings → Secrets and variables → Actions
2. Click "New repository secret"
3. Name: `PYPI_API_TOKEN`
4. Value: Paste your PyPI token
5. Click "Add secret"

### 4.3 Build and Upload (Manual)

```bash
# Install build tools
pip install build twine

# Build package
python -m build

# Check package
twine check dist/*

# Upload to TestPyPI (optional, for testing)
twine upload --repository testpypi dist/*

# Upload to PyPI
twine upload dist/*
```

### 4.4 Automatic Publishing

The GitHub workflow will automatically publish to PyPI when you create a release!

Just create a release on GitHub, and it will:
1. Run tests
2. Build package
3. Upload to PyPI

---

## ⚙️ Step 5: Configure Repository

### 5.1 Branch Protection

Settings → Branches → Add rule:

**Branch name pattern**: `main`

Protection rules:
- ✅ Require pull request reviews before merging
- ✅ Require status checks to pass before merging
  - Select: `test`, `lint`
- ✅ Require branches to be up to date before merging
- ✅ Include administrators (optional)

### 5.2 Code Owners (Optional)

Create `.github/CODEOWNERS`:
```
# Global owners
* @aeonbridge/core-team

# Documentation
*.md @aeonbridge/docs-team

# Source code
src/ @aeonbridge/developers
```

### 5.3 Issue Templates

Already included in `.github/` if created.

### 5.4 Pull Request Template

Create `.github/pull_request_template.md`:
```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation

## Checklist
- [ ] Tests pass
- [ ] Documentation updated
- [ ] CHANGELOG.md updated
```

---

## 📊 Step 6: Setup Integrations

### 6.1 Codecov (Code Coverage)

1. Go to https://codecov.io/
2. Sign in with GitHub
3. Enable for `claude-model-selector`
4. Badge markdown (add to README):
```markdown
[![codecov](https://codecov.io/gh/aeonbridge/claude-model-selector/branch/main/graph/badge.svg)](https://codecov.io/gh/aeonbridge/claude-model-selector)
```

### 6.2 Read the Docs (Documentation)

1. Go to https://readthedocs.org/
2. Import project
3. Connect to GitHub repository
4. Configure build

### 6.3 PyPI Badge

Add to README.md:
```markdown
[![PyPI version](https://badge.fury.io/py/claude-model-selector.svg)](https://badge.fury.io/py/claude-model-selector)
[![Downloads](https://pepy.tech/badge/claude-model-selector)](https://pepy.tech/project/claude-model-selector)
```

---

## 📣 Step 7: Announcement

### 7.1 Create Announcement

Post in:
- GitHub Discussions
- Twitter/X
- LinkedIn
- Reddit (r/Python, r/MachineLearning)
- Dev.to
- Hacker News

Example tweet:
```
🚀 Just released Claude Model Selector v1.0.0!

Automatically choose the most cost-effective Claude AI model for each task.

Save 70-95% on AI costs while maintaining quality! 💰

✨ Zero dependencies
✨ CLI & Python API
✨ Open source (MIT)

https://github.com/aeonbridge/claude-model-selector

#AI #Python #CloudComputing #CostOptimization
```

### 7.2 Update Project README

Add badges:
```markdown
[![PyPI](https://img.shields.io/pypi/v/claude-model-selector)](https://pypi.org/project/claude-model-selector/)
[![Python](https://img.shields.io/pypi/pyversions/claude-model-selector)](https://pypi.org/project/claude-model-selector/)
[![License](https://img.shields.io/github/license/aeonbridge/claude-model-selector)](https://github.com/aeonbridge/claude-model-selector/blob/main/LICENSE)
[![CI](https://github.com/aeonbridge/claude-model-selector/workflows/CI/badge.svg)](https://github.com/aeonbridge/claude-model-selector/actions)
[![codecov](https://codecov.io/gh/aeonbridge/claude-model-selector/branch/main/graph/badge.svg)](https://codecov.io/gh/aeonbridge/claude-model-selector)
```

---

## 🔄 Step 8: Maintenance

### Regular Tasks

**Weekly**:
- Review issues
- Respond to discussions
- Merge approved PRs

**Monthly**:
- Update dependencies
- Review and update documentation
- Check for security updates

**Per Release**:
1. Update version in `setup.py`
2. Update `CHANGELOG.md`
3. Create git tag
4. Create GitHub release
5. Verify PyPI upload
6. Announce release

### Version Numbering

Follow [Semantic Versioning](https://semver.org/):
- `MAJOR.MINOR.PATCH`
- Bump MAJOR for breaking changes
- Bump MINOR for new features
- Bump PATCH for bug fixes

---

## 📝 Checklist

### Pre-Launch
- [ ] Code complete and tested
- [ ] Documentation complete
- [ ] LICENSE file present (MIT)
- [ ] README.md comprehensive
- [ ] CONTRIBUTING.md clear
- [ ] CHANGELOG.md up to date
- [ ] Examples work correctly
- [ ] CI/CD configured

### Launch
- [ ] GitHub repository created
- [ ] Code pushed to GitHub
- [ ] v1.0.0 tag created
- [ ] GitHub release published
- [ ] PyPI package published
- [ ] PyPI token secured
- [ ] Branch protection enabled

### Post-Launch
- [ ] Badges added to README
- [ ] Integrations configured
- [ ] Announcement posted
- [ ] Documentation published
- [ ] Community guidelines set
- [ ] Issue templates created

---

## 🆘 Troubleshooting

### PyPI Upload Fails

**Error**: "Package already exists"
- Increment version number
- Cannot re-upload same version

**Error**: "Authentication failed"
- Check `PYPI_API_TOKEN` secret
- Verify token is valid
- Token must start with `pypi-`

### CI Workflow Fails

**Check**:
- Python versions compatible
- Dependencies installable
- Tests passing locally

**Fix**:
- Update workflow file
- Fix failing tests
- Check Python version matrix

### Import Errors After Install

**Issue**: `ModuleNotFoundError`
- Verify package structure
- Check `__init__.py` exists
- Ensure `setup.py` correct

**Fix**:
```bash
pip uninstall claude-model-selector
pip install --no-cache-dir claude-model-selector
```

---

## 📧 Support

For deployment issues:
- Email: support@aeonbridge.com
- GitHub Issues: [Create issue](https://github.com/aeonbridge/claude-model-selector/issues/new)

---

## 🎉 Success!

Once deployed, your package will be:
- ✅ Available on PyPI
- ✅ Installable via `pip install claude-model-selector`
- ✅ Discoverable on GitHub
- ✅ CI/CD automated
- ✅ Ready for contributions

**Congratulations on your open-source release!** 🚀

---

**Maintained by AeonBridge Co.** | Licensed under MIT
