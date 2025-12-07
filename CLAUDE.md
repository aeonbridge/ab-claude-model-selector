# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Claude Model Selector is a Python library for intelligently selecting the most cost-effective Claude AI model (Haiku, Sonnet, or Opus) based on task complexity analysis. It's a **zero-dependency** pure Python package designed for production use.

## Development Commands

### Installation & Setup

```bash
# Install in development mode with dev dependencies
pip install -e ".[dev]"

# Install only runtime (zero dependencies)
pip install -e .
```

### Testing

```bash
# Run all tests
pytest

# Run with coverage report
pytest --cov=claude_model_selector --cov-report=html

# Run specific test file
pytest tests/test_selector.py

# Run specific test class or function
pytest tests/test_selector.py::TestQuickSelect
pytest tests/test_selector.py::TestQuickSelect::test_simple_task_selects_haiku
```

### Code Quality

```bash
# Format code with Black
black src/ tests/

# Check formatting without changes
black src/ tests/ --check

# Lint with Flake8
flake8 src/ tests/

# Type checking with mypy
mypy src/
```

### CLI Testing

```bash
# Test CLI commands directly
python -m claude_model_selector.cli analyze "Design a scalable architecture"
python -m claude_model_selector.cli compare "Process data" --tokens 50000
python -m claude_model_selector.cli info
```

### Building & Distribution

```bash
# Build distribution packages
python -m build

# Upload to PyPI (requires credentials)
twine upload dist/*
```

## Architecture

### Core Components

1. **selector.py** (419 lines) - Main algorithm and logic
   - `ClaudeModelSelector` class: Main selector with complexity analysis
   - `quick_select()` function: Fast one-liner model selection
   - `TaskAnalysis` dataclass: Analysis results container
   - `ClaudeModel` enum: Model definitions with pricing

2. **cli.py** - Command-line interface
   - Commands: `analyze`, `compare`, `batch`, `info`
   - Supports JSON output, file I/O, and verbose mode

3. **__init__.py** - Package exports
   - Exports: `ClaudeModelSelector`, `quick_select`, `TaskAnalysis`, `ClaudeModel`

### Complexity Scoring Algorithm

The core algorithm (`_calculate_complexity()`) scores tasks 0-100:

**Base Score:** 50 (Sonnet territory)

**Keyword Analysis:**
- Haiku keywords (simple, quick, list, extract): weight -20
- Sonnet keywords (analyze, implement, create): weight 0 (neutral)
- Opus keywords (plan, design, architect, critical): weight +30

**Pattern Matching:**
- Planning patterns (plan, design, architect): +40
- Complex coding (multi-step, refactor, migrate): +35
- Research (investigate, comprehensive): +30
- Decision-making (trade-offs, evaluate): +25
- Simple tasks (list, count, extract): -30

**Length Factors:**
- Word count >100: +15
- Word count >50: +10
- Word count <10: -10
- Context provided: +min(context_words/20, 15)

**Multi-step Indicators:**
- Words like "and then", "also", "additionally": +10
- Question marks >2: +5 per mark
- Simplicity words "just", "simply", "only": -15

**Final Score → Model:**
- 0-30: Haiku
- 31-70: Sonnet
- 71-100: Opus

### Model Pricing (per million tokens)

| Model  | Input  | Output | Speed     |
|--------|--------|--------|-----------|
| Haiku  | $0.80  | $4.00  | Fastest   |
| Sonnet | $3.00  | $15.00 | Balanced  |
| Opus   | $15.00 | $75.00 | Slowest   |

### Cost Estimation

Token estimation: `(chars / 4) * 3` (assumes 1 token ≈ 4 chars, 2x output)
Cost calculation: 40% input tokens, 60% output tokens

### Confidence Scoring

Base confidence: 0.7
- Extreme scores (<20 or >80): 0.95
- Strong scores (<35 or >65): 0.85
- Short tasks (<5 words): -0.15
- Clear indicators present: +0.1
- Range: 0.5 to 1.0

## File Structure

```
src/claude_model_selector/
  ├── __init__.py          # Package exports
  ├── selector.py          # Core algorithm (419 lines)
  ├── cli.py               # CLI commands
  └── config.json          # Default configuration

tests/
  ├── conftest.py          # Shared fixtures
  ├── test_selector.py     # Selector tests (~350 lines)
  └── test_cli.py          # CLI tests (~200 lines)
```

## Configuration

Custom configuration via JSON file:

```python
from pathlib import Path
from claude_model_selector import ClaudeModelSelector

selector = ClaudeModelSelector(config_path=Path('config.json'))
```

**Config Options:**
- `haiku_threshold`: Complexity threshold for Haiku (default: 30)
- `sonnet_threshold`: Complexity threshold for Sonnet (default: 70)
- `default_model`: Fallback model (default: "sonnet")
- `cost_optimization`: Enable cost optimization (default: true)

## Testing Guidelines

**Test Coverage Target:** >90% for all modules

**Test Categories:**
- Unit tests: Algorithm correctness, edge cases, threshold validation
- Integration tests: CLI commands, file I/O, end-to-end workflows
- Test markers: `@pytest.mark.unit`, `@pytest.mark.integration`, `@pytest.mark.slow`

**Test Naming:**
```python
def test_<what>_<expected_behavior>():
    """Clear description of test"""
    # Arrange
    # Act
    # Assert
```

**Key Test Areas:**
1. Complexity scoring accuracy for different task types
2. Model selection threshold validation
3. Cost estimation precision
4. Confidence scoring edge cases
5. CLI output formatting and JSON serialization

## Code Style

- **Formatter:** Black (line length: 88)
- **Linter:** Flake8
- **Type Hints:** Required for all public APIs
- **Docstrings:** Google-style for all public methods
- **Comments:** For complex logic only

## Important Constraints

1. **Zero Dependencies:** The package has NO runtime dependencies. Do not add any.
2. **Pure Python:** No C extensions or compiled code.
3. **Python 3.8+ Support:** Maintain compatibility with Python 3.8+.
4. **API Stability:** Public API in `__init__.py` exports must remain stable.

## Common Patterns

### Adding New Complexity Keywords

Edit `complexity_keywords` dict in `ClaudeModelSelector.__init__()`:

```python
self.complexity_keywords = {
    'haiku': {'keywords': [...], 'weight': -20},
    'sonnet': {'keywords': [...], 'weight': 0},
    'opus': {'keywords': [...], 'weight': 30}
}
```

### Adding New Task Patterns

Edit `task_patterns` dict in `ClaudeModelSelector.__init__()`:

```python
self.task_patterns = {
    'pattern_name': {
        'patterns': [r'\bregex\b', ...],
        'weight': 40
    }
}
```

### Testing New Features

Always add tests in both `test_selector.py` and `test_cli.py` when adding features:

```python
def test_new_feature():
    """Test description"""
    selector = ClaudeModelSelector()
    result = selector.new_method(...)
    assert result == expected
```

## Release Process

1. Update version in `setup.py` and `__init__.py`
2. Update `CHANGELOG.md` with changes
3. Run full test suite: `pytest --cov=claude_model_selector`
4. Check code style: `black src/ tests/ --check && flake8 src/ tests/`
5. Build: `python -m build`
6. Create git tag: `git tag -a v1.0.0 -m "Version 1.0.0"`
7. Push tag: `git push origin v1.0.0`
8. Upload to PyPI: `twine upload dist/*`
9. Create GitHub release with notes

## Critical Design Decisions

1. **No External Dependencies:** To maximize portability and minimize supply chain risk
2. **Simple Regex-Based Analysis:** Fast, predictable, and debuggable (no ML models)
3. **Conservative Thresholds:** Better to over-spec than under-spec for critical tasks
4. **Token Estimation:** Rough but fast (4 chars/token) - accuracy is secondary to speed
5. **Cost Model:** Assumes 40% input / 60% output ratio for general tasks