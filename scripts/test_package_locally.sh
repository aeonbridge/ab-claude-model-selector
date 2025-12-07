#!/bin/bash
# Test Package Locally Script
# Tests the built package in a clean environment

set -e  # Exit on error

echo "🧪 Testing claude-model-selector package locally"
echo "================================================"
echo ""

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if dist/ exists
if [ ! -d "dist" ]; then
    echo -e "${RED}❌ Error: dist/ directory not found${NC}"
    echo "Run: python -m build"
    exit 1
fi

# Find the wheel file
WHEEL_FILE=$(ls dist/*.whl 2>/dev/null | head -n 1)
if [ -z "$WHEEL_FILE" ]; then
    echo -e "${RED}❌ Error: No wheel file found in dist/${NC}"
    echo "Run: python -m build"
    exit 1
fi

echo -e "${GREEN}✓ Found wheel: $WHEEL_FILE${NC}"
echo ""

# Create test environment
TEST_ENV="test_package_env"
echo "📦 Creating virtual environment: $TEST_ENV"
python3 -m venv $TEST_ENV

# Activate virtual environment
source $TEST_ENV/bin/activate

echo -e "${GREEN}✓ Virtual environment activated${NC}"
echo ""

# Install the package
echo "📥 Installing package from wheel..."
pip install --quiet "$WHEEL_FILE"

echo -e "${GREEN}✓ Package installed${NC}"
echo ""

# Test 1: Import test
echo "🧪 Test 1: Importing package..."
python3 << EOF
try:
    from claude_model_selector import ClaudeModelSelector, quick_select, __version__
    print(f"✓ Import successful")
    print(f"  Version: {__version__}")
except Exception as e:
    print(f"❌ Import failed: {e}")
    exit(1)
EOF

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Test 1 passed${NC}"
else
    echo -e "${RED}❌ Test 1 failed${NC}"
    deactivate
    rm -rf $TEST_ENV
    exit 1
fi
echo ""

# Test 2: Quick select test
echo "🧪 Test 2: Testing quick_select()..."
python3 << EOF
from claude_model_selector import quick_select

try:
    model = quick_select("List all Python files")
    expected = "haiku"
    if model == expected:
        print(f"✓ quick_select() works correctly")
        print(f"  Input: 'List all Python files'")
        print(f"  Output: '{model}'")
    else:
        print(f"❌ Unexpected result: got '{model}', expected '{expected}'")
        exit(1)
except Exception as e:
    print(f"❌ Error: {e}")
    exit(1)
EOF

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Test 2 passed${NC}"
else
    echo -e "${RED}❌ Test 2 failed${NC}"
    deactivate
    rm -rf $TEST_ENV
    exit 1
fi
echo ""

# Test 3: Detailed analysis test
echo "🧪 Test 3: Testing analyze_task()..."
python3 << 'EOF'
from claude_model_selector import ClaudeModelSelector

try:
    selector = ClaudeModelSelector()
    analysis = selector.analyze_task("Design a scalable microservices architecture")

    print(f"✓ analyze_task() works correctly")
    print(f"  Model: {analysis.recommended_model}")
    print(f"  Complexity: {analysis.complexity_score:.1f}/100")
    print(f"  Confidence: {analysis.confidence:.0%}")
    print(f"  Cost: \${analysis.estimated_cost:.6f}")

    if analysis.recommended_model not in ["haiku", "sonnet", "opus"]:
        print(f"❌ Invalid model: {analysis.recommended_model}")
        exit(1)
except Exception as e:
    print(f"❌ Error: {e}")
    exit(1)
EOF

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Test 3 passed${NC}"
else
    echo -e "${RED}❌ Test 3 failed${NC}"
    deactivate
    rm -rf $TEST_ENV
    exit 1
fi
echo ""

# Test 4: CLI test
echo "🧪 Test 4: Testing CLI command..."
if command -v claude-model-selector &> /dev/null; then
    echo -e "${GREEN}✓ CLI command 'claude-model-selector' is available${NC}"

    # Test CLI info command
    claude-model-selector info > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ CLI 'info' command works${NC}"
    else
        echo -e "${RED}❌ CLI 'info' command failed${NC}"
        deactivate
        rm -rf $TEST_ENV
        exit 1
    fi

    # Test CLI analyze command
    OUTPUT=$(claude-model-selector analyze "Simple task" 2>&1)
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ CLI 'analyze' command works${NC}"
    else
        echo -e "${RED}❌ CLI 'analyze' command failed${NC}"
        echo "$OUTPUT"
        deactivate
        rm -rf $TEST_ENV
        exit 1
    fi
else
    echo -e "${RED}❌ CLI command not found${NC}"
    deactivate
    rm -rf $TEST_ENV
    exit 1
fi
echo ""

# Test 5: config.json included
echo "🧪 Test 5: Checking if config.json is included..."
python3 << EOF
import pkg_resources
import os

try:
    # Try to get the package path
    package_path = pkg_resources.resource_filename('claude_model_selector', 'config.json')

    if os.path.exists(package_path):
        print(f"✓ config.json found at: {package_path}")
    else:
        print(f"❌ config.json not found")
        exit(1)
except Exception as e:
    print(f"❌ Error accessing config.json: {e}")
    exit(1)
EOF

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Test 5 passed${NC}"
else
    echo -e "${RED}❌ Test 5 failed${NC}"
    deactivate
    rm -rf $TEST_ENV
    exit 1
fi
echo ""

# Cleanup
echo "🧹 Cleaning up..."
deactivate
rm -rf $TEST_ENV

echo ""
echo "================================================"
echo -e "${GREEN}✅ All tests passed!${NC}"
echo ""
echo "The package is ready for publication to PyPI."
echo ""
echo "Next steps:"
echo "  1. Review PUBLISHING.md for publication instructions"
echo "  2. Test on Test PyPI: twine upload --repository testpypi dist/*"
echo "  3. Create GitHub release to publish to PyPI"
echo ""