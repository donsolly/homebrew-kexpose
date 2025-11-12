# This file will be automatically updated by homebrew-releaser
# Place this in your homebrew-kexpose tap repository under Formula/kexpose.rb

class Kexpose < Formula
  desc "Kubernetes port-forward manager with TUI"
  homepage "https://github.com/donsolly/kexpose"
  version "0.1.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/donsolly/kexpose/releases/download/v0.1.0/kexpose-v0.1.0-darwin-arm64.tar.gz"
      sha256 "REPLACE_WITH_ARM64_SHA256"
    else
      url "https://github.com/donsolly/kexpose/releases/download/v0.1.0/kexpose-v0.1.0-darwin-amd64.tar.gz"
      sha256 "REPLACE_WITH_AMD64_SHA256"
    end
  end

  depends_on :macos

  def install
    if Hardware::CPU.arm?
      bin.install "kexpose-darwin-arm64" => "kexpose"
    else
      bin.install "kexpose-darwin-amd64" => "kexpose"
    end

    # Generate shell completions if available
    # Uncomment if kexpose supports completion command:
    # generate_completions_from_executable(bin/"kexpose", "completion")
  end

  def caveats
    <<~EOS
      kexpose requires:
      - Access to a Kubernetes cluster with valid kubeconfig
      - lsof (included in macOS) for port scanning

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
