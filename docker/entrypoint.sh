#!/bin/bash
# Entrypoint script for Masters Thesis Docker container

set -e

# Function to print colored output
print_info() {
    echo -e "\033[1;34m[INFO]\033[0m $1"
}

print_success() {
    echo -e "\033[1;32m[SUCCESS]\033[0m $1"
}

print_warning() {
    echo -e "\033[1;33m[WARNING]\033[0m $1"
}

print_error() {
    echo -e "\033[1;31m[ERROR]\033[0m $1"
}

# Check if we're running as root
if [ "$(id -u)" = "0" ]; then
    print_warning "Running as root. Consider using a non-root user for production."
fi

# Display environment info
print_info "Environment Info:"
print_info "  Python: $(python --version)"
print_info "  Jupyter: $(jupyter --version 2>/dev/null || echo 'not found')"
print_info "  Working Directory: $(pwd)"

# List available notebooks
print_info "Available Notebooks in CODES/:"
find /app/CODES -name "*.ipynb" -type f | head -20 | while read -r nb; do
    echo "  - $nb"
done

# Change to app directory
cd /app

# Execute the command
exec "$@"