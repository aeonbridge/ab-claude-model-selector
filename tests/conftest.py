"""
Pytest configuration and fixtures for Claude Model Selector tests
"""

import pytest
import tempfile
from pathlib import Path


@pytest.fixture
def temp_dir():
    """Create a temporary directory for tests"""
    with tempfile.TemporaryDirectory() as tmpdir:
        yield Path(tmpdir)


@pytest.fixture
def sample_tasks():
    """Sample tasks for testing"""
    return {
        "simple": [
            "List all files",
            "Count items",
            "Extract data",
        ],
        "standard": [
            "Analyze code for bugs",
            "Implement authentication",
            "Create test suite",
        ],
        "complex": [
            "Design scalable microservices architecture",
            "Plan comprehensive migration strategy",
            "Architect multi-region deployment",
        ]
    }


@pytest.fixture
def sample_task_file(temp_dir):
    """Create a sample task file for batch testing"""
    task_file = temp_dir / "tasks.txt"
    tasks = [
        "List all Python files",
        "Analyze code for security issues",
        "Design system architecture",
        "Quick bug fix",
        "Research database solutions",
    ]
    task_file.write_text("\n".join(tasks))
    return task_file


@pytest.fixture
def sample_config(temp_dir):
    """Create a sample configuration file"""
    import json

    config_file = temp_dir / "config.json"
    config = {
        "thresholds": {
            "haiku_max": 30,
            "sonnet_max": 70
        },
        "default_model": "sonnet",
        "cost_optimization": True
    }
    config_file.write_text(json.dumps(config, indent=2))
    return config_file


@pytest.fixture
def mock_analysis():
    """Create a mock TaskAnalysis object"""
    from claude_model_selector import TaskAnalysis

    return TaskAnalysis(
        complexity_score=50.0,
        recommended_model="sonnet",
        reasoning="Test reasoning for mock analysis",
        confidence=0.85,
        estimated_tokens=10000,
        estimated_cost=0.05
    )


@pytest.fixture(autouse=True)
def reset_selector_state():
    """Reset any global state before each test"""
    # This fixture runs before each test automatically
    # Add any cleanup/reset logic here if needed
    yield
    # Cleanup after test if needed


# Parametrized fixtures for testing multiple scenarios
@pytest.fixture(params=["haiku", "sonnet", "opus"])
def model_name(request):
    """Parametrized fixture for all model names"""
    return request.param


@pytest.fixture(params=[100, 1000, 10000, 100000])
def token_count(request):
    """Parametrized fixture for different token counts"""
    return request.param


# Helper functions available to all tests
def assert_valid_model(model_name):
    """Assert that a model name is valid"""
    assert model_name in ["haiku", "sonnet", "opus"], \
        f"Invalid model name: {model_name}"


def assert_valid_complexity(score):
    """Assert that a complexity score is valid"""
    assert 0 <= score <= 100, \
        f"Complexity score out of range: {score}"


def assert_valid_confidence(confidence):
    """Assert that a confidence value is valid"""
    assert 0 <= confidence <= 1, \
        f"Confidence out of range: {confidence}"
