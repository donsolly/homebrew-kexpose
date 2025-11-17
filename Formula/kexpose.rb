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
      sha256 "4c5b0b6d11de81516946cbb5d09e1e3aa54e0e7005a719b431323d155c8da0b6"
    else
      url "https://github.com/donsolly/homebrew-kexpose/releases/download/v0.1.0/kexpose-v0.1.0-darwin-amd64.tar.gz"
      sha256 "8dbb65ed0cda0776e1185419e0a3df88fbdc53c9476ace86ce36e746a403a405"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/donsolly/homebrew-kexpose/releases/download/v0.1.0/kexpose-v0.1.0-linux-arm64.tar.gz"
      sha256 "PLACEHOLDER_LINUX_ARM64_SHA256"
    else
      url "https://github.com/donsolly/homebrew-kexpose/releases/download/v0.1.0/kexpose-v0.1.0-linux-amd64.tar.gz"
      sha256 "PLACEHOLDER_LINUX_AMD64_SHA256"
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
