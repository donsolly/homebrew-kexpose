# This file is automatically updated by the release workflow
# DO NOT manually edit version, url, or sha256 fields - they will be overwritten

class Kexpose < Formula
  desc "Cross-platform Kubernetes port-forward manager with TUI"
  homepage "https://github.com/donsolly/homebrew-kexpose"
  version "0.1.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/donsolly/homebrew-kexpose/releases/download/v0.1.0/kexpose-v0.1.0-darwin-arm64.tar.gz"
      sha256 "d75027c74c084f27cdee9bd5dc955ee99108d28f4507e4082f81d8fab2b73d31"
    else
      url "https://github.com/donsolly/homebrew-kexpose/releases/download/v0.1.0/kexpose-v0.1.0-darwin-amd64.tar.gz"
      sha256 "83ee5cf52ab26a8006f4ad2ac2ce1f4f722d013c751ffacd67c08df47dcdef23"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/donsolly/homebrew-kexpose/releases/download/v0.1.0/kexpose-v0.1.0-linux-arm64.tar.gz"
      sha256 "6b43954519ab98e32bbbbb12ca111def2927faa5f763b4cc9dfae8fb3bfdb3d4"
    else
      url "https://github.com/donsolly/homebrew-kexpose/releases/download/v0.1.0/kexpose-v0.1.0-linux-amd64.tar.gz"
      sha256 "6b43954519ab98e32bbbbb12ca111def2927faa5f763b4cc9dfae8fb3bfdb3d4"
    end
  end

  depends_on "lsof" if OS.linux?

  def install
    bin.install "kexpose"
  end

  def caveats
    <<~EOS
      kexpose requires:
      - Access to a Kubernetes cluster with valid kubeconfig
      - lsof for port scanning
        macOS: pre-installed
        Linux: install with your package manager (apt install lsof, yum install lsof, etc.)

      Run 'kexpose doctor' to check your system configuration.

      Configuration: ~/.kexpose/
      Logs: ~/.kexpose/logs/kexpose.log
    EOS
  end

  test do
    # Test version command
    assert_match version.to_s, shell_output("#{bin}/kexpose --version")

    # Test doctor command (will fail without kubeconfig, but validates binary works)
    system "#{bin}/kexpose", "doctor"
  end
end
