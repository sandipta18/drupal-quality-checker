#!/bin/bash

# Check if pip is installed
if ! command -v pip &> /dev/null; then
    echo "pip is not installed. Installing pip..."

    # Install pip
    if command -v apt-get &> /dev/null; then
        # For Debian/Ubuntu-based systems
        sudo apt-get update
        sudo apt-get install -y python3-pip
    elif command -v yum &> /dev/null; then
        # For Red Hat/Fedora-based systems
        sudo yum install -y python3-pip
    else
        echo "Error: Unsupported package manager. Please install pip manually."
        exit 1
    fi
fi

# Check if trufflehog is already installed
if command -v trufflehog &> /dev/null; then
    echo "Trufflehog is already installed. Skipping installation."
    exit 0
fi

# Install trufflehog
pip install --user trufflehog

# Add Trufflehog directory to PATH
export PATH="$HOME/.local/bin:$PATH"

# Check if trufflehog is installed successfully
if ! command -v trufflehog &> /dev/null; then
    echo "Error: trufflehog installation failed. Please check your Python and pip installation."
    exit 1
fi

echo "Trufflehog installed successfully."
