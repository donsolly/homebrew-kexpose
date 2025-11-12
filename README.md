# kexpose Homebrew Tap

Official Homebrew tap for [kexpose](https://github.com/donsolly/kexpose), a Kubernetes port-forward manager with a terminal UI.

## Why use this tap?

- **One-line install** of the latest signed macOS binaries (Intel and Apple Silicon).
- **Automatic updates** as soon as new kexpose releases are published.
- **`brew doctor`-style checks** via `kexpose doctor` to verify your environment.

## Requirements

- macOS with Homebrew installed
- Access to a Kubernetes cluster (valid `kubeconfig`)
- `lsof` (ships with macOS) for port scanning

## Installation

```bash
brew tap donsolly/homebrew-kexpose
brew install kexpose
```

After installation:

```bash
kexpose --version   # confirm the binary works
kexpose doctor      # quick environment/cluster checks
```

## Upgrading

```bash
brew update && brew upgrade kexpose
```

Homebrew keeps both the CLI and the tap metadata up to date; no manual downloads required.

## Quick Start

### Launch the TUI

Simply run:

```bash
kexpose
```

The TUI will open with:
- **Left pane**: Browse Services/Pods
- **Right pane**: Active port forwards
- **Header**: Current context and namespace
- **Footer**: Keyboard shortcuts

### Basic Usage

1. **Navigate**: Use `↑/↓` or `j/k` to move through the list
2. **Switch panes**: Press `Tab` to toggle between Browse and Active Forwards
3. **Change context**: Press `c` to open the context selector (shows in header with hint)
4. **Change namespace**: Press `n` to open the namespace selector (shows in header with hint)
5. **Toggle view**: Press `p` to switch between Services and Pods
6. **Start forward**: Select a service/pod and press `f`
7. **Stop forward**: Select an active forward and press `x`
8. **Restart forward**: Select an active forward and press `r`
9. **Refresh**: Press `R` to reload the current view
10. **Quit**: Press `q` or `Ctrl+C`

### Context & Namespace Switching

The header displays your current context and namespace with keyboard hints:
- `Context: prod-cluster (c)` - Press **c** to change
- `Namespace: default (n)` - Press **n** to change

When you press `c` or `n`, an interactive selector appears:
- Shows current selection highlighted
- Navigate with `↑/↓` or `j/k`
- Shows position counter (e.g., "3/15")
- Press `Enter` to confirm, `Esc` to cancel
- Automatically reloads resources after switching

### Creating Port Forwards

To start a port forward:

1. **Select a resource**: Navigate to a Service or Pod in the Browse pane
2. **Press `f`**: This creates the port forward
3. **Success message**: Shows exactly how to access it: `Forward started! Access at http://localhost:9004 (→ kubecost-aggregator:9004)`
4. **Find it**: The forward appears in the Active Forwards pane on the right

**The Active Forwards pane shows:**
- **Status indicator**: ● (running), ◐ (connecting), ✗ (error), ⟲ (reconnecting)
- **Resource**: Service/kubecost-aggregator
- **Access URL**: `localhost:9004→9004` (highlighted in blue)
- **Uptime**: How long it's been running

**Port selection:**
- kexpose tries to use the same local port as the remote port
- If that port is busy, it automatically finds the next available port
- The success message tells you which port was used

**Example:**
```
● Service/kubecost-aggregator localhost:9004→9004 2m
```
This means: Access the service at `http://localhost:9004` - it's been running for 2 minutes.

### CLI Commands

kexpose also provides CLI commands for non-interactive use:

```bash
# List active forwards
kexpose list

# Start a forward (non-TUI)
kexpose start svc/myservice -n default -L 8080:80

# Stop a forward
kexpose stop <forward-id>

# Check system requirements
kexpose doctor
```

## Troubleshooting

- `kexpose doctor` surfaces the most common configuration issues (missing kubeconfig, port conflicts, etc.).
- Logs live under `~/.kexpose/logs/kexpose.log`.
- Still stuck? Open an issue with details about your macOS version, Homebrew version, and the command you ran.

## How releases are managed

This tap is refreshed automatically whenever a new kexpose tag (e.g. `v1.0.0`) is published:

1. GitHub Actions builds the release artifacts.
2. `homebrew-releaser` downloads the binaries, computes SHA256 checksums, and updates `Formula/kexpose.rb`.
3. The updated formula is committed to `homebrew-kexpose`, ensuring `brew install kexpose` always retrieves the latest release.

## Repository layout

```
homebrew-kexpose/
├── Formula/
│   └── kexpose.rb  # Homebrew formula maintained by automation
└── README.md       # This document
```

## Need more info?

- Project documentation and source: [donsolly/kexpose-dev](https://github.com/donsolly/kexpose-dev)
- Tap issues and discussions: use the GitHub Issues tab in this repository
