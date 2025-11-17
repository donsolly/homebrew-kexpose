#!/bin/bash
set -e

# Build DEB package for kexpose
# Usage: ./build-deb.sh <version> <arch>
# Example: ./build-deb.sh 1.0.0 amd64

VERSION=${1:-$(git describe --tags --always --dirty)}
ARCH=${2:-amd64}
PACKAGE_NAME="kexpose"
MAINTAINER="donsolly <donsolly@users.noreply.github.com>"
DESCRIPTION="A terminal UI for discovering Kubernetes Services/Pods and exposing them locally via port-forwards"

echo "Building DEB package for ${PACKAGE_NAME} ${VERSION} (${ARCH})..."

# Create temporary directory structure
BUILD_DIR="build/deb/${PACKAGE_NAME}_${VERSION}_${ARCH}"
rm -rf "${BUILD_DIR}"
mkdir -p "${BUILD_DIR}/DEBIAN"
mkdir -p "${BUILD_DIR}/usr/bin"
mkdir -p "${BUILD_DIR}/usr/share/doc/${PACKAGE_NAME}"
mkdir -p "${BUILD_DIR}/usr/share/man/man1"

# Copy binary
if [ ! -f "build/${PACKAGE_NAME}-linux-${ARCH}" ]; then
    echo "Error: Binary not found at build/${PACKAGE_NAME}-linux-${ARCH}"
    echo "Run 'make build-all' first"
    exit 1
fi
cp "build/${PACKAGE_NAME}-linux-${ARCH}" "${BUILD_DIR}/usr/bin/${PACKAGE_NAME}"
chmod 755 "${BUILD_DIR}/usr/bin/${PACKAGE_NAME}"

# Create control file
cat > "${BUILD_DIR}/DEBIAN/control" <<EOF
Package: ${PACKAGE_NAME}
Version: ${VERSION#v}
Section: utils
Priority: optional
Architecture: ${ARCH}
Depends: lsof
Maintainer: ${MAINTAINER}
Description: ${DESCRIPTION}
 kexpose is a macOS-focused terminal UI (TUI) application for discovering
 Kubernetes Services/Pods and exposing them locally via reliable, ergonomic
 port-forwards—with conflict detection, context/namespace management, and
 auto-reconnection.
 .
 Features:
  - Beautiful terminal UI built with Charmbracelet Bubbletea
  - Smart port management with conflict detection
  - Auto-reconnection with exponential backoff
  - Context & namespace switching
  - Service/Pod discovery with fuzzy search
  - Process scanning for port management
  - Rules & favorites for quick access
  - Zero configuration setup
Homepage: https://github.com/donsolly/homebrew-kexpose
EOF

# Create postinst script
cat > "${BUILD_DIR}/DEBIAN/postinst" <<'EOF'
#!/bin/sh
set -e

# Check if lsof is available
if ! command -v lsof >/dev/null 2>&1; then
    echo "Warning: lsof is not installed. kexpose requires lsof for port scanning."
    echo "Install it with: sudo apt install lsof"
fi

exit 0
EOF
chmod 755 "${BUILD_DIR}/DEBIAN/postinst"

# Create copyright file
cat > "${BUILD_DIR}/usr/share/doc/${PACKAGE_NAME}/copyright" <<EOF
Format: https://www.debian.org/doc/packaging-manuals/copyright-format/1.0/
Upstream-Name: kexpose
Upstream-Contact: donsolly <donsolly@users.noreply.github.com>
Source: https://github.com/donsolly/homebrew-kexpose

Files: *
Copyright: 2025 donsolly
License: MIT
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 .
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 .
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
EOF

# Build the package
dpkg-deb --build --root-owner-group "${BUILD_DIR}"

# Move to build directory
mv "${BUILD_DIR}.deb" "build/${PACKAGE_NAME}_${VERSION}_${ARCH}.deb"

echo "DEB package created: build/${PACKAGE_NAME}_${VERSION}_${ARCH}.deb"
