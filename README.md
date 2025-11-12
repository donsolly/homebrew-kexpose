# Homebrew Tap for kexpose

This directory contains the Homebrew formula template for kexpose.

## For the Public Homebrew Tap Repository

The files in this directory should be copied to your public `homebrew-kexpose` tap repository:

```
homebrew-kexpose/
├── Formula/
│   └── kexpose.rb    (from .brew/Formula/kexpose.rb)
└── README.md
```

## Installation (for users)

```bash
brew tap donsolly/kexpose
brew install kexpose
```

## Upgrading

```bash
brew update
brew upgrade kexpose
```

## How It Works

The formula is automatically updated by GitHub Actions when a new release is created:

1. Tag is pushed to the main repo (e.g., `v1.0.0`)
2. Release workflow builds binaries and creates GitHub release
3. `homebrew-releaser` action automatically:
   - Downloads the release artifacts
   - Calculates SHA256 checksums
   - Updates the formula with new version and checksums
   - Commits to the homebrew-kexpose repository

## More Information

Visit [kexpose on GitHub](https://github.com/donsolly/kexpose) for documentation and support.
