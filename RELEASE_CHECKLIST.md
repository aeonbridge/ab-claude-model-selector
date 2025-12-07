# Release Checklist for Claude Model Selector

Use this checklist when preparing a new release for PyPI.

## Pre-Release

- [ ] **All tests pass**
  ```bash
  pytest
  ```

- [ ] **Code quality checks pass**
  ```bash
  black src/ tests/ --check
  flake8 src/ tests/
  mypy src/
  ```

- [ ] **Version updated in 3 places**
  - [ ] `src/claude_model_selector/__init__.py`
  - [ ] `setup.py`
  - [ ] `pyproject.toml`

- [ ] **CHANGELOG.md updated**
  - [ ] New version section added
  - [ ] All changes documented
  - [ ] Release date added

- [ ] **Documentation reviewed**
  - [ ] README.md accurate
  - [ ] Examples work
  - [ ] API docs current

## Build & Test

- [ ] **Clean build environment**
  ```bash
  rm -rf build/ dist/ src/*.egg-info
  ```

- [ ] **Build package**
  ```bash
  python -m build
  ```

- [ ] **Check package**
  ```bash
  twine check dist/*
  ```

- [ ] **Test locally**
  ```bash
  python -m venv test_env
  source test_env/bin/activate
  pip install dist/claude_model_selector-*.whl
  claude-model-selector --help
  python -c "from claude_model_selector import quick_select; print(quick_select('test'))"
  deactivate
  rm -rf test_env
  ```

## Test PyPI (Optional but Recommended)

- [ ] **Upload to Test PyPI**
  ```bash
  twine upload --repository testpypi dist/*
  ```

- [ ] **Test installation from Test PyPI**
  ```bash
  python -m venv test_pypi_env
  source test_pypi_env/bin/activate
  pip install --index-url https://test.pypi.org/simple/ claude-model-selector
  claude-model-selector info
  deactivate
  rm -rf test_pypi_env
  ```

## Release

- [ ] **Commit all changes**
  ```bash
  git add .
  git commit -m "Prepare release vX.Y.Z"
  git push origin main
  ```

- [ ] **Create git tag**
  ```bash
  git tag -a vX.Y.Z -m "Release version X.Y.Z"
  git push origin vX.Y.Z
  ```

- [ ] **Create GitHub Release**
  - Go to: https://github.com/aeonbridge/claude-model-selector/releases/new
  - Select tag: `vX.Y.Z`
  - Title: `vX.Y.Z`
  - Description: Copy from CHANGELOG.md
  - Click "Publish release"

- [ ] **Wait for GitHub Actions**
  - Monitor: https://github.com/aeonbridge/claude-model-selector/actions
  - Ensure all jobs pass (test, build, publish)

## Post-Release

- [ ] **Verify on PyPI**
  - Visit: https://pypi.org/project/claude-model-selector/
  - Check version, description, classifiers
  - Verify README renders correctly

- [ ] **Test installation from PyPI**
  ```bash
  python -m venv verify_env
  source verify_env/bin/activate
  pip install claude-model-selector
  claude-model-selector info
  python -c "from claude_model_selector import __version__; print(__version__)"
  deactivate
  rm -rf verify_env
  ```

- [ ] **Update documentation**
  - [ ] Update README badges (if applicable)
  - [ ] Post announcement on GitHub Discussions
  - [ ] Update project website (if exists)

- [ ] **Mark roadmap complete**
  - [ ] Update README.md roadmap
  - [ ] Close related GitHub issues

## Version Numbering Guide

Follow [Semantic Versioning](https://semver.org/):

- **MAJOR** (X.0.0): Breaking changes
  - Incompatible API changes
  - Removed features
  - Changed behavior

- **MINOR** (0.X.0): New features
  - New functionality added
  - New CLI commands
  - Backwards compatible

- **PATCH** (0.0.X): Bug fixes
  - Bug fixes only
  - Performance improvements
  - Documentation updates
  - Backwards compatible

## Common Issues

### Build fails
```bash
pip install --upgrade build setuptools wheel
```

### Version already exists on PyPI
- Cannot reupload same version
- Increment version and rebuild

### Tests fail in CI but pass locally
- Check Python version compatibility
- Verify all dependencies in pyproject.toml
- Check GitHub Actions logs

### README not rendering on PyPI
- Use standard Markdown (not GitHub-specific)
- Validate locally: `python -m readme_renderer README.md`

## Emergency Rollback

If a release has critical issues:

1. **Yank the release on PyPI**
   - Go to: https://pypi.org/manage/project/claude-model-selector/release/X.Y.Z/
   - Click "Options" → "Yank release"
   - Provide reason

2. **Delete GitHub release** (optional)
   - Not recommended unless truly broken

3. **Fix issues and release new patch version**

## Notes

- PyPI does not allow deleting or overwriting releases
- Always test on Test PyPI first for new releases
- Keep CHANGELOG.md up to date with every change
- Tag format: `vX.Y.Z` (with 'v' prefix)
- GitHub release title: `vX.Y.Z` (matches tag)

---

**Template for CHANGELOG.md entry:**

```markdown
## [X.Y.Z] - YYYY-MM-DD

### Added
- New feature descriptions

### Changed
- Changes to existing features

### Fixed
- Bug fixes

### Deprecated
- Features marked for removal

### Removed
- Removed features

### Security
- Security improvements
```

---

Last Updated: 2025-01-07