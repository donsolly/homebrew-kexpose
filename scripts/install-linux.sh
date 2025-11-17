#!/bin/bash
set -e

# Universal Linux install script for kexpose
# Works on all major Linux distributions

REPO="donsolly/homebrew-kexpose"
BINARY_NAME="kexpose"
INSTALL_DIR="/usr/local/bin"

# Detect OS and architecture
detect_os_arch() {
    OS=$(uname -s | tr '[:upper:]' '[:lower:]')
    ARCH=$(uname -m)

    case "${ARCH}" in
        x86_64|amd64)
            ARCH="amd64"
            ;;
        aarch64|arm64)
            ARCH="arm64"
            ;;
        *)
            echo "Error: Unsupported architecture: ${ARCH}"
            exit 1
            ;;
    esac

    if [ "${OS}" != "linux" ]; then
        echo "Error: This script is for Linux only. Detected OS: ${OS}"
        exit 1
    fi

    echo "Detected: ${OS}-${ARCH}"
}

# Get latest version from GitHub
get_latest_version() {
    echo "Fetching latest version..."
    LATEST_VERSION=$(curl -s "https://api.github.com/repos/${REPO}/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')

    if [ -z "${LATEST_VERSION}" ]; then
        echo "Error: Could not determine latest version"
        exit 1
    fi

    echo "Latest version: ${LATEST_VERSION}"
}

# Download and install binary
install_binary() {
    DOWNLOAD_URL="https://github.com/${REPO}/releases/download/${LATEST_VERSION}/${BINARY_NAME}-${LATEST_VERSION}-linux-${ARCH}.tar.gz"

    echo "Downloading from: ${DOWNLOAD_URL}"

    # Create temp directory
    TMP_DIR=$(mktemp -d)
    trap "rm -rf ${TMP_DIR}" EXIT

    # Download
    if command -v curl >/dev/null 2>&1; then
        curl -L "${DOWNLOAD_URL}" -o "${TMP_DIR}/${BINARY_NAME}.tar.gz"
    elif command -v wget >/dev/null 2>&1; then
        wget "${DOWNLOAD_URL}" -O "${TMP_DIR}/${BINARY_NAME}.tar.gz"
    else
        echo "Error: curl or wget is required"
        exit 1
    fi

    # Extract
    echo "Extracting..."
    tar xzf "${TMP_DIR}/${BINARY_NAME}.tar.gz" -C "${TMP_DIR}"

    # Install
    echo "Installing to ${INSTALL_DIR}..."
    if [ -w "${INSTALL_DIR}" ]; then
        mv "${TMP_DIR}/${BINARY_NAME}" "${INSTALL_DIR}/${BINARY_NAME}"
    else
        sudo mv "${TMP_DIR}/${BINARY_NAME}" "${INSTALL_DIR}/${BINARY_NAME}"
    fi

    # Make executable
    if [ -w "${INSTALL_DIR}/${BINARY_NAME}" ]; then
        chmod +x "${INSTALL_DIR}/${BINARY_NAME}"
    else
        sudo chmod +x "${INSTALL_DIR}/${BINARY_NAME}"
    fi

    echo "✓ ${BINARY_NAME} installed successfully!"
}

# Check dependencies
check_dependencies() {
    echo ""
    echo "Checking dependencies..."

    if ! command -v lsof >/dev/null 2>&1; then
        echo "⚠ Warning: lsof is not installed"
        echo "  kexpose requires lsof for port scanning"
        echo ""
        echo "  Install it with:"

        # Detect package manager
        if command -v apt >/dev/null 2>&1; then
            echo "    sudo apt install lsof"
        elif command -v yum >/dev/null 2>&1; then
            echo "    sudo yum install lsof"
        elif command -v dnf >/dev/null 2>&1; then
            echo "    sudo dnf install lsof"
        elif command -v pacman >/dev/null 2>&1; then
            echo "    sudo pacman -S lsof"
        elif command -v apk >/dev/null 2>&1; then
            echo "    sudo apk add lsof"
        elif command -v zypper >/dev/null 2>&1; then
            echo "    sudo zypper install lsof"
        else
            echo "    (using your distribution's package manager)"
        fi
    else
        echo "✓ lsof is installed"
    fi

    if ! command -v kubectl >/dev/null 2>&1; then
        echo "⚠ Note: kubectl is not installed"
        echo "  kexpose requires kubectl config for Kubernetes access"
    else
        echo "✓ kubectl is installed"
    fi
}

# Main installation
main() {
    echo "kexpose installer"
    echo "================="
    echo ""

    detect_os_arch
    get_latest_version
    install_binary
    check_dependencies

    echo ""
    echo "Installation complete! Run 'kexpose' to get started."
    echo ""
    echo "For help: kexpose --help"
    echo "To check system requirements: kexpose doctor"
}

main
