#!/bin/bash
set -e

# Build RPM package for kexpose
# Usage: ./build-rpm.sh <version> <arch>
# Example: ./build-rpm.sh 1.0.0 x86_64

VERSION=${1:-$(git describe --tags --always --dirty | sed 's/^v//')}
ARCH=${2:-x86_64}
PACKAGE_NAME="kexpose"

# Map Go arch to RPM arch
if [ "${ARCH}" = "amd64" ]; then
    RPM_ARCH="x86_64"
    GO_ARCH="amd64"
elif [ "${ARCH}" = "x86_64" ]; then
    RPM_ARCH="x86_64"
    GO_ARCH="amd64"
elif [ "${ARCH}" = "arm64" ]; then
    RPM_ARCH="aarch64"
    GO_ARCH="arm64"
elif [ "${ARCH}" = "aarch64" ]; then
    RPM_ARCH="aarch64"
    GO_ARCH="arm64"
else
    echo "Unsupported architecture: ${ARCH}"
    exit 1
fi

echo "Building RPM package for ${PACKAGE_NAME} ${VERSION} (${RPM_ARCH})..."

# Check for binary
if [ ! -f "build/${PACKAGE_NAME}-linux-${GO_ARCH}" ]; then
    echo "Error: Binary not found at build/${PACKAGE_NAME}-linux-${GO_ARCH}"
    echo "Run 'make build-all' first"
    exit 1
fi

# Create RPM build structure
BUILD_DIR="build/rpm"
mkdir -p "${BUILD_DIR}"/{BUILD,RPMS,SOURCES,SPECS,SRPMS}

# Copy binary to SOURCES
cp "build/${PACKAGE_NAME}-linux-${GO_ARCH}" "${BUILD_DIR}/SOURCES/${PACKAGE_NAME}"

# Create spec file
cat > "${BUILD_DIR}/SPECS/${PACKAGE_NAME}.spec" <<EOF
Name:           ${PACKAGE_NAME}
Version:        ${VERSION}
Release:        1%{?dist}
Summary:        Terminal UI for Kubernetes port-forwarding

License:        MIT
URL:            https://github.com/donsolly/homebrew-kexpose
Source0:        ${PACKAGE_NAME}

BuildArch:      ${RPM_ARCH}
Requires:       lsof

%description
kexpose is a terminal UI (TUI) application for discovering Kubernetes
Services/Pods and exposing them locally via reliable, ergonomic port-forwards
with conflict detection, context/namespace management, and auto-reconnection.

Features:
- Beautiful terminal UI built with Charmbracelet Bubbletea
- Smart port management with conflict detection
- Auto-reconnection with exponential backoff
- Context & namespace switching
- Service/Pod discovery with fuzzy search
- Process scanning for port management
- Rules & favorites for quick access
- Zero configuration setup

%prep
# No prep needed for pre-built binary

%build
# No build needed for pre-built binary

%install
mkdir -p %{buildroot}%{_bindir}
install -m 0755 %{SOURCE0} %{buildroot}%{_bindir}/${PACKAGE_NAME}

%files
%{_bindir}/${PACKAGE_NAME}

%post
# Check if lsof is available
if ! command -v lsof >/dev/null 2>&1; then
    echo "Warning: lsof is not installed. kexpose requires lsof for port scanning."
    echo "Install it with: sudo yum install lsof  (or: sudo dnf install lsof)"
fi

%changelog
* $(date "+%a %b %d %Y") Builder <builder@localhost> - ${VERSION}-1
- Release ${VERSION}
EOF

# Build the RPM
rpmbuild --define "_topdir ${PWD}/${BUILD_DIR}" \
         --define "_rpmdir ${PWD}/build" \
         --target "${RPM_ARCH}" \
         -bb "${BUILD_DIR}/SPECS/${PACKAGE_NAME}.spec"

echo "RPM package created in build/${RPM_ARCH}/"
ls -lh "build/${RPM_ARCH}/${PACKAGE_NAME}-${VERSION}-1"*".rpm"
