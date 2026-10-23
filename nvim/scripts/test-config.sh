#!/bin/bash

# Simplified Neovim Configuration Validation Script

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Errors are fatal (exit 1); warnings are advisory.
# Increment with `X=$((X + 1))`; `((X++))` returns 1 when X is 0 and trips `set -e`.
FAILURES=0
WARNINGS=0

print_header() {
    echo -e "\n${BLUE}=== $1 ===${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
    FAILURES=$((FAILURES + 1))
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
    WARNINGS=$((WARNINGS + 1))
}

# Headless Neovim exits 0 even when the config errors, so also check what it printed:
# a healthy config starts silently.
has_errors() {
    grep -qiE 'E[0-9]+:|error|failed' <<< "$1"
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

print_header "Neovim Configuration Test"

# Test 1: Dependency preflight
# `timeout` is GNU coreutils and is not shipped with macOS; Homebrew's coreutils installs
# it as `gtimeout`, which works too.
REQUIRED_COMMANDS="nvim timeout"

# Prints the path of the command to run for $1.
resolve_command() {
    case "$1" in
        timeout) command -v timeout || command -v gtimeout ;;
        *)       command -v "$1" ;;
    esac
}

dependency_purpose() {
    case "$1" in
        nvim)    echo "the editor under test" ;;
        timeout) echo "bounding each headless run so a hang cannot wedge the suite" ;;
        *)       echo "required by this script" ;;
    esac
}

dependency_hint() {
    case "$1" in
        nvim)
            if [ "$(uname -s)" = "Darwin" ]; then
                echo "brew install neovim"
            else
                echo "install Neovim with your package manager"
            fi
            ;;
        timeout)
            if [ "$(uname -s)" = "Darwin" ]; then
                echo "not shipped with macOS - it comes from GNU coreutils:"
                echo "  brew install coreutils"
                echo "That installs it as 'gtimeout', which this script also accepts."
            else
                echo "install GNU coreutils with your package manager"
            fi
            ;;
        *)
            echo "install it with your package manager"
            ;;
    esac
}

print_header "Dependency Check"

MISSING=""
for cmd in $REQUIRED_COMMANDS; do
    if cmd_path="$(resolve_command "$cmd")"; then
        print_success "$cmd -> $cmd_path"
    else
        print_error "$cmd not found"
        MISSING="$MISSING $cmd"
    fi
done

if [ -n "$MISSING" ]; then
    echo
    print_error "Cannot run the test suite - missing required command(s):$MISSING"
    for cmd in $MISSING; do
        echo
        echo -e "  ${YELLOW}${cmd}${NC} - needed for $(dependency_purpose "$cmd")"
        dependency_hint "$cmd" | while IFS= read -r line; do
            echo "      $line"
        done
    done
    echo
    exit 1
fi
TIMEOUT="$(resolve_command timeout)"

# Test this checkout's config even when it isn't the one at ~/.config/nvim (e.g. from a
# worktree): XDG_CONFIG_HOME points at a temp dir whose nvim/ links here. Plugins still
# come from the usual data directory.
TEST_CONFIG_HOME="$(mktemp -d)"
STARTUP_FILE="$(mktemp)"
trap 'rm -rf "$TEST_CONFIG_HOME" "$STARTUP_FILE"' EXIT
ln -s "$SCRIPT_DIR" "$TEST_CONFIG_HOME/nvim"
export XDG_CONFIG_HOME="$TEST_CONFIG_HOME"

echo "  Config under test: $SCRIPT_DIR"
echo "  Neovim version: $(nvim --version | head -n1)"

# Test 2: Config loads
print_header "Configuration Loading"
# Quit with -c 'qa': startup errors are only printed when Neovim exits that way, not when
# a Lua chunk quits it.
LOAD_OUTPUT=$("$TIMEOUT" 5 nvim --headless -c 'qa' 2>&1) && LOAD_EXIT_CODE=0 || LOAD_EXIT_CODE=$?
if [ $LOAD_EXIT_CODE -eq 0 ] && ! has_errors "$LOAD_OUTPUT"; then
    print_success "Configuration loads"
else
    echo "$LOAD_OUTPUT" | sed 's/^/    /'
    print_error "Configuration fails to load"
fi

# Test 3: Startup time
if "$TIMEOUT" 5 nvim --headless --startuptime "$STARTUP_FILE" +q &>/dev/null; then
    if [ -s "$STARTUP_FILE" ]; then
        # Look for the NVIM STARTED line and extract the time
        STARTUP_TIME=$(grep "NVIM STARTED" "$STARTUP_FILE" | tail -1 | awk '{print $1}')
        if [[ -n "$STARTUP_TIME" ]]; then
            # Convert to integer milliseconds
            STARTUP_INT=$(echo "$STARTUP_TIME" | cut -d'.' -f1)
            echo "  Startup time: ${STARTUP_TIME}ms"
            if [ "$STARTUP_INT" -gt 100 ]; then
                print_warning "Slow startup (>100ms)"
            else
                print_success "Startup test"
            fi
        else
            print_warning "Could not parse startup time"
        fi
    else
        print_warning "Could not read startup time"
    fi
else
    print_error "Startup test failed"
fi

# Test 4: Plugin loading (using inline lua)
PLUGIN_TEST_RESULT=$("$TIMEOUT" 10 nvim --headless -c 'lua
local ok, lazy = pcall(require, "lazy")
if ok then
    local plugins = lazy.plugins()
    if plugins and #plugins > 0 then
        print("OK: lazy.nvim loaded with " .. #plugins .. " plugins")
        vim.cmd("qa")
    else
        print("ERROR: No plugins loaded")
        vim.cmd("cq")
    end
else
    print("ERROR: lazy.nvim not loaded")
    vim.cmd("cq")
end
' 2>&1) && PLUGIN_EXIT_CODE=0 || PLUGIN_EXIT_CODE=$?

if [ $PLUGIN_EXIT_CODE -eq 0 ]; then
    echo "  $PLUGIN_TEST_RESULT"
    print_success "Plugin system"
else
    echo "  Error: $PLUGIN_TEST_RESULT"
    print_error "Plugin system"
fi

# Test 5: Basic functionality
print_header "Basic Functionality"

BASIC_TEST_RESULT=$("$TIMEOUT" 5 nvim --headless -c 'lua
-- Test leader key
if vim.g.mapleader ~= " " then
    print("ERROR: Leader key not set")
    vim.cmd("cq")
else
    print("OK: Leader key configured")
    vim.cmd("qa")
end
' 2>&1) && BASIC_EXIT_CODE=0 || BASIC_EXIT_CODE=$?

if [ $BASIC_EXIT_CODE -eq 0 ]; then
    echo "  $BASIC_TEST_RESULT"
    print_success "Basic functionality"
else
    echo "  Error: $BASIC_TEST_RESULT"
    print_error "Basic functionality"
fi

print_header "Summary"
echo "Automated configuration validation complete."
echo "Run with: ./scripts/test-config.sh"
echo

if [ "$FAILURES" -gt 0 ]; then
    print_error "$FAILURES check(s) failed, $WARNINGS warning(s)"
    exit 1
elif [ "$WARNINGS" -gt 0 ]; then
    print_warning "All checks passed with $WARNINGS warning(s)"
    exit 0
else
    print_success "All checks passed"
    exit 0
fi
