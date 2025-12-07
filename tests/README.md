# Tests for Claude Model Selector

Comprehensive test suite for the Claude Model Selector package.

## Running Tests

### Install Test Dependencies

```bash
# Install package with dev dependencies
pip install -e ".[dev]"
```

### Run All Tests

```bash
# Run all tests
pytest

# Run with verbose output
pytest -v

# Run with coverage report
pytest --cov=claude_model_selector --cov-report=html

# Run specific test file
pytest tests/test_selector.py

# Run specific test class
pytest tests/test_selector.py::TestQuickSelect

# Run specific test
pytest tests/test_selector.py::TestQuickSelect::test_simple_task_selects_haiku
```

### Run Tests by Marker

```bash
# Run only unit tests
pytest -m unit

# Run only integration tests
pytest -m integration

# Skip slow tests
pytest -m "not slow"
```

## Test Structure

```
tests/
├── __init__.py              # Package initialization
├── conftest.py              # Shared fixtures and configuration
├── test_selector.py         # Tests for selector module (~350 lines)
├── test_cli.py              # Tests for CLI interface (~200 lines)
└── README.md                # This file
```

## Test Coverage

Current test coverage:

- **Selector Module**: ~95% coverage
  - Quick selection function
  - ClaudeModelSelector class
  - Complexity scoring algorithm
  - Model selection logic
  - Cost estimation
  - Edge cases

- **CLI Module**: ~90% coverage
  - analyze command
  - compare command
  - batch command
  - info command
  - Output formatting
  - Error handling

## Test Categories

### Unit Tests (`test_selector.py`)

1. **TestQuickSelect**
   - Simple task selection
   - Standard task selection
   - Complex task selection
   - Edge cases

2. **TestClaudeModelSelector**
   - Initialization
   - Task analysis
   - Model info retrieval
   - Model comparison

3. **TestComplexityScoring**
   - Keyword analysis
   - Pattern matching
   - Length factors
   - Context weighting

4. **TestModelThresholds**
   - Haiku threshold
   - Sonnet threshold
   - Opus threshold

5. **TestCostEstimation**
   - Cost calculation
   - Cost scaling
   - Model cost comparison

6. **TestEdgeCases**
   - Empty strings
   - Very long tasks
   - Special characters
   - Unicode support

7. **TestRealWorldScenarios**
   - File operations
   - Code analysis
   - Architecture tasks

8. **TestConfidence**
   - High confidence cases
   - Low confidence cases
   - Context effects

9. **TestCustomConfiguration**
   - Custom thresholds
   - Default config fallback

### Integration Tests (`test_cli.py`)

1. **TestCLIAnalyze**
   - Basic analysis
   - JSON output
   - Context handling
   - Verbose output

2. **TestCLICompare**
   - Model comparison
   - Token scaling
   - Output formatting

3. **TestCLIBatch**
   - File processing
   - Summary generation
   - Verbose mode

4. **TestCLIInfo**
   - All models info
   - Specific model info
   - Pricing display

5. **TestCLIHelpers**
   - Print functions
   - Formatting utilities

6. **TestCLIIntegration**
   - Full workflows
   - End-to-end tests

7. **TestCLIErrorHandling**
   - Invalid files
   - Missing context
   - Error messages

8. **TestCLIOutputFiles**
   - Save to file
   - JSON output
   - Batch results

## Fixtures

### Common Fixtures (in `conftest.py`)

- `temp_dir` - Temporary directory for file operations
- `sample_tasks` - Sample tasks by complexity level
- `sample_task_file` - Pre-created task file for batch tests
- `sample_config` - Sample configuration file
- `mock_analysis` - Mock TaskAnalysis object
- `model_name` - Parametrized fixture for all models
- `token_count` - Parametrized fixture for token counts

### Helper Functions

- `assert_valid_model()` - Validate model names
- `assert_valid_complexity()` - Validate complexity scores
- `assert_valid_confidence()` - Validate confidence values

## Writing New Tests

### Test Naming Convention

```python
def test_<what_is_being_tested>_<expected_behavior>():
    """Clear docstring explaining the test"""
    # Arrange
    # Act
    # Assert
```

### Example Test

```python
def test_quick_select_simple_task_returns_haiku():
    """Test that simple tasks select Haiku model"""
    # Arrange
    task = "List all files"

    # Act
    result = quick_select(task)

    # Assert
    assert result == "haiku"
```

### Using Fixtures

```python
def test_with_fixture(sample_tasks):
    """Test using a fixture"""
    for task in sample_tasks["simple"]:
        result = quick_select(task)
        assert result in ["haiku", "sonnet"]
```

### Parametrized Tests

```python
@pytest.mark.parametrize("task,expected", [
    ("List files", "haiku"),
    ("Analyze code", "sonnet"),
    ("Design architecture", "opus"),
])
def test_model_selection(task, expected):
    result = quick_select(task)
    assert result == expected
```

## Coverage Reports

### Generate HTML Coverage Report

```bash
pytest --cov=claude_model_selector --cov-report=html
```

View report:
```bash
open htmlcov/index.html
```

### Generate XML Coverage Report (for CI)

```bash
pytest --cov=claude_model_selector --cov-report=xml
```

## Continuous Integration

Tests are automatically run on:
- Push to main/develop
- Pull requests
- GitHub Actions workflows

See `.github/workflows/ci.yml` for CI configuration.

## Test Performance

Approximate test execution times:
- Full suite: ~5-10 seconds
- Selector tests: ~3-5 seconds
- CLI tests: ~2-4 seconds

## Troubleshooting

### Import Errors

```bash
# Make sure package is installed
pip install -e .

# Or add to PYTHONPATH
export PYTHONPATH="${PYTHONPATH}:${PWD}/src"
```

### Missing Dependencies

```bash
# Install dev dependencies
pip install -e ".[dev]"
```

### Coverage Not Working

```bash
# Install pytest-cov
pip install pytest-cov
```

## Contributing

When adding new features:
1. Write tests first (TDD)
2. Ensure >90% code coverage
3. Run full test suite before submitting PR
4. Update this README if adding new test categories

## Resources

- [pytest documentation](https://docs.pytest.org/)
- [pytest-cov documentation](https://pytest-cov.readthedocs.io/)
- [Coverage.py documentation](https://coverage.readthedocs.io/)

## License

MIT License - See LICENSE file in root directory
