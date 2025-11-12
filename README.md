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
brew tap donsolly/kexpose
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
