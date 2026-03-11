# This file is automatically updated by the release workflow
# DO NOT manually edit version, url, or sha256 fields - they will be overwritten

class Kexpose < Formula
  desc "Cross-platform Kubernetes port-forward manager with TUI"
  homepage "https://github.com/donsolly/homebrew-kexpose"
  version "0.1.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/donsolly/homebrew-kexpose/releases/download/v0.1.1/kexpose-v0.1.1-darwin-arm64.tar.gz"
      sha256 "a82814ac885b223604820a888190b89ff16dc5a15602f68d6cbdaa1be702b85f"
    else
      url "https://github.com/donsolly/homebrew-kexpose/releases/download/v0.1.1/kexpose-v0.1.1-darwin-amd64.tar.gz"
      sha256 "50a40d7b365d6d4f5cc58636e57702586091583d8113b500d9560e1b7f3125d3"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/donsolly/homebrew-kexpose/releases/download/v0.1.1/kexpose-v0.1.1-linux-arm64.tar.gz"
      sha256 "e79525a0254fc0a9122039a88014a4b4cf57a1c393346338feea5003dc882cb7"
    else
      url "https://github.com/donsolly/homebrew-kexpose/releases/download/v0.1.0/kexpose-v0.1.0-linux-amd64.tar.gz"
      sha256 "e79525a0254fc0a9122039a88014a4b4cf57a1c393346338feea5003dc882cb7"
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
